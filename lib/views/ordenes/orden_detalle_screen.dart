import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../data/app_database.dart';
import '../../models/estado_orden.dart';
import '../../models/orden_resumen.dart';
import '../../viewmodels/inventario_viewmodel.dart';
import '../../viewmodels/mecanicos_viewmodel.dart';
import '../../viewmodels/orden_detalle_viewmodel.dart';
import '../widgets/estado_chip.dart';
import '../widgets/ui_helpers.dart';
import 'orden_dialogs.dart';

/// Todo sobre una orden: estado, trabajos, repuestos y pagos.
class OrdenDetalleScreen extends StatefulWidget {
  const OrdenDetalleScreen({
    super.key,
    required this.db,
    required this.ordenId,
    required this.inventario,
    required this.mecanicos,
  });

  final AppDatabase db;
  final int ordenId;
  final InventarioViewModel inventario;
  final MecanicosViewModel mecanicos;

  @override
  State<OrdenDetalleScreen> createState() => _OrdenDetalleScreenState();
}

class _OrdenDetalleScreenState extends State<OrdenDetalleScreen> {
  late final OrdenDetalleViewModel vm =
      OrdenDetalleViewModel(widget.db.ordenesDao, widget.ordenId);

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------ Acciones

  Future<void> _avanzar(OrdenResumen o) async {
    final siguiente = o.estado.siguiente;
    if (siguiente == null) return;

    if (siguiente == EstadoOrden.entregada && o.saldo > 0) {
      final seguir = await confirmar(
        context,
        titulo: 'El cliente aún debe dinero',
        mensaje:
            'Falta cobrar ${fmtMonto(o.saldo)} de esta orden. ¿Entregar el vehículo de todos modos?',
        accion: 'Entregar',
      );
      if (!seguir || !mounted) return;
    }
    await ejecutar(
      context,
      () => vm.cambiarEstado(siguiente),
      exito: 'Orden ahora: ${siguiente.etiqueta}',
    );
  }

  Future<void> _cancelar() async {
    final ok = await confirmar(
      context,
      titulo: 'Cancelar la orden',
      mensaje:
          'La orden quedará cancelada, no se facturará y los repuestos usados volverán al inventario. Esto no se puede deshacer.',
      accion: 'Cancelar orden',
      destructiva: true,
    );
    if (!ok || !mounted) return;
    await ejecutar(
      context,
      () => vm.cambiarEstado(EstadoOrden.cancelada),
      exito: 'Orden cancelada',
    );
  }

  Future<void> _cambiarMecanico(OrdenResumen o) async {
    final elegido = await elegirDeLista<Mecanico>(
      context,
      titulo: 'Reasignar mecánico',
      items: widget.mecanicos.activos,
      etiqueta: (m) => m.nombre,
      detalle: (m) => m.id == o.mecanicoId ? 'Asignado actualmente' : '',
      buscable: false,
    );
    if (elegido == null || elegido.id == o.mecanicoId || !mounted) return;
    await ejecutar(
      context,
      () => vm.reasignarMecanico(elegido.id),
      exito: 'Orden asignada a ${elegido.nombre}',
    );
  }

  Future<void> _agregarTrabajo() async {
    final datos = await pedirTrabajo(context);
    if (datos == null || !mounted) return;
    await ejecutar(
      context,
      () => vm.agregarTrabajo(datos.descripcion, datos.precio),
    );
  }

  Future<void> _quitarTrabajo(Trabajo t) async {
    final ok = await confirmar(
      context,
      titulo: 'Quitar trabajo',
      mensaje: '¿Quitar "${t.descripcion}" de la orden?',
      accion: 'Quitar',
      destructiva: true,
    );
    if (!ok || !mounted) return;
    await ejecutar(context, () => vm.eliminarTrabajo(t.id));
  }

  Future<void> _agregarRepuesto() async {
    final disponibles = widget.inventario.disponibles;
    if (disponibles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay repuestos con existencias en el inventario.'),
        ),
      );
      return;
    }
    final datos = await pedirRepuesto(context, disponibles);
    if (datos == null || !mounted) return;

    final mensajero = ScaffoldMessenger.of(context);
    final actualizado = await ejecutarConValor<Repuesto>(
      context,
      () => vm.agregarRepuesto(datos.repuesto.id, datos.cantidad),
    );
    if (actualizado == null) return;

    // Aviso inmediato si el repuesto quedó por agotarse.
    final texto = actualizado.existencias == 0
        ? '${actualizado.nombre}: se agotó. ¡Hay que comprar más!'
        : InventarioViewModel.estaPorAgotarse(actualizado)
            ? '${actualizado.nombre}: quedan ${actualizado.existencias} (mínimo ${actualizado.stockMinimo}). Conviene comprar.'
            : 'Repuesto agregado';
    mensajero.showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _quitarRepuesto(int usoId, String nombre) async {
    final ok = await confirmar(
      context,
      titulo: 'Quitar repuesto',
      mensaje: '¿Quitar "$nombre" de la orden? Volverá al inventario.',
      accion: 'Quitar',
      destructiva: true,
    );
    if (!ok || !mounted) return;
    await ejecutar(context, () => vm.quitarRepuesto(usoId));
  }

  Future<void> _registrarPago(OrdenResumen o) async {
    final datos = await pedirPago(context, o.saldo);
    if (datos == null || !mounted) return;
    await ejecutar(
      context,
      () => vm.registrarPago(datos.monto, datos.nota),
      exito: 'Pago de ${fmtMonto(datos.monto)} registrado',
    );
  }

  // ------------------------------------------------------------------- Pantalla

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        final o = vm.orden;

        return Scaffold(
          appBar: AppBar(
            title: Text('Orden #${widget.ordenId}'),
            actions: [
              if (o != null && o.abierta)
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'mecanico') _cambiarMecanico(o);
                    if (v == 'cancelar') _cancelar();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'mecanico',
                      child: ListTile(
                        leading: Icon(Icons.engineering_outlined),
                        title: Text('Reasignar mecánico'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'cancelar',
                      child: ListTile(
                        leading: Icon(Icons.cancel_outlined),
                        title: Text('Cancelar orden'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          body: vm.cargando
              ? const Center(child: CircularProgressIndicator())
              : o == null
                  ? const EstadoVacio(
                      icono: Icons.search_off,
                      titulo: 'La orden no existe',
                    )
                  : PaginaCentrada(
                      maxAncho: 760,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        children: [
                          _cabecera(context, o),
                          _trabajos(context, o),
                          _repuestos(context, o),
                          _pagos(context, o),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _cabecera(BuildContext context, OrdenResumen o) {
    final tema = Theme.of(context);
    final siguiente = o.estado.siguiente;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${o.vehiculo} · ${o.matricula}',
                    style: tema.textTheme.titleLarge,
                  ),
                ),
                EstadoChip(o.estado),
              ],
            ),
            const SizedBox(height: 12),
            _fila(context, Icons.person_outline, 'Cliente', o.clienteNombre,
                onTap: () => context.go('/clientes/${o.clienteId}')),
            _fila(context, Icons.phone_outlined, 'Teléfono', o.clienteTelefono),
            _fila(context, Icons.directions_car_outlined, 'Vehículo',
                'Ver historial del vehículo',
                onTap: () => context.go('/clientes/vehiculos/${o.vehiculoId}')),
            _fila(context, Icons.speed, 'Kilometraje', fmtKm(o.kilometraje)),
            _fila(context, Icons.event_outlined, 'Entrada',
                fmtFechaHora(o.fechaEntrada)),
            if (o.fechaCierre != null)
              _fila(context, Icons.event_available_outlined, 'Cierre',
                  fmtFechaHora(o.fechaCierre!)),
            _fila(context, Icons.engineering_outlined, 'Mecánico',
                o.mecanicoNombre),
            const Divider(height: 24),
            Text('Problema reportado', style: tema.textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(o.problema),
            if (siguiente != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _avanzar(o),
                  icon: Icon(siguiente.icono),
                  label: Text('Pasar a: ${siguiente.etiqueta}'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _fila(
    BuildContext context,
    IconData icono,
    String etiqueta,
    String valor, {
    VoidCallback? onTap,
  }) {
    final tema = Theme.of(context);
    final contenido = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icono, size: 18, color: tema.colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          SizedBox(
            width: 92,
            child: Text(
              etiqueta,
              style: tema.textTheme.bodySmall?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: onTap == null
                  ? null
                  : TextStyle(
                      color: tema.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
            ),
          ),
        ],
      ),
    );
    return onTap == null ? contenido : InkWell(onTap: onTap, child: contenido);
  }

  Widget _trabajos(BuildContext context, OrdenResumen o) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeccionTitulo(
          'Trabajos realizados',
          accion: o.abierta
              ? TextButton.icon(
                  onPressed: _agregarTrabajo,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                )
              : null,
        ),
        Card(
          child: vm.trabajos.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Todavía no se ha anotado ningún trabajo.'),
                )
              : Column(
                  children: [
                    for (final t in vm.trabajos)
                      ListTile(
                        leading: const Icon(Icons.build_outlined),
                        title: Text(t.descripcion),
                        subtitle: Text(fmtFecha(t.fecha)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(fmtMonto(t.precioManoObra)),
                            if (o.abierta)
                              IconButton(
                                tooltip: 'Quitar trabajo',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _quitarTrabajo(t),
                              ),
                          ],
                        ),
                      ),
                    const Divider(height: 1),
                    _subtotal(context, 'Mano de obra', o.manoObra),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _repuestos(BuildContext context, OrdenResumen o) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeccionTitulo(
          'Repuestos usados',
          accion: o.abierta
              ? TextButton.icon(
                  onPressed: _agregarRepuesto,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                )
              : null,
        ),
        Card(
          child: vm.repuestos.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No se han usado repuestos.'),
                )
              : Column(
                  children: [
                    for (final r in vm.repuestos)
                      ListTile(
                        leading: const Icon(Icons.settings_outlined),
                        title: Text(r.repuesto.nombre),
                        subtitle: Text(
                          '${r.uso.cantidad} × ${fmtMonto(r.uso.precioUnitario)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(fmtMonto(r.subtotal)),
                            if (o.abierta)
                              IconButton(
                                tooltip: 'Quitar repuesto',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _quitarRepuesto(
                                  r.uso.id,
                                  r.repuesto.nombre,
                                ),
                              ),
                          ],
                        ),
                      ),
                    const Divider(height: 1),
                    _subtotal(context, 'Repuestos', o.repuestos),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _pagos(BuildContext context, OrdenResumen o) {
    final tema = Theme.of(context);
    final saldoColor =
        o.saldo > 0 ? tema.colorScheme.error : tema.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SeccionTitulo('Cobro'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _linea(context, 'Mano de obra', fmtMonto(o.manoObra)),
                _linea(context, 'Repuestos', fmtMonto(o.repuestos)),
                const Divider(),
                _linea(
                  context,
                  'Total',
                  fmtMonto(o.total),
                  fuerte: true,
                ),
                _linea(context, 'Pagado', fmtMonto(o.pagado)),
                _linea(
                  context,
                  o.cancelada ? 'Orden cancelada' : 'Falta por pagar',
                  o.cancelada ? '—' : fmtMonto(o.saldo),
                  fuerte: true,
                  color: saldoColor,
                ),
                if (!o.cancelada && o.saldo > 0) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: () => _registrarPago(o),
                      icon: const Icon(Icons.payments_outlined),
                      label: const Text('Registrar pago'),
                    ),
                  ),
                ],
                if (!o.cancelada && o.saldo == 0 && o.total > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: tema.colorScheme.primary),
                        const SizedBox(width: 6),
                        const Text('Orden pagada por completo'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (vm.pagos.isNotEmpty) ...[
          const SeccionTitulo('Pagos recibidos'),
          Card(
            child: Column(
              children: [
                for (final p in vm.pagos)
                  ListTile(
                    leading: const Icon(Icons.payments_outlined),
                    title: Text(fmtMonto(p.monto)),
                    subtitle: Text(
                      p.nota == null
                          ? fmtFechaHora(p.fecha)
                          : '${fmtFechaHora(p.fecha)} · ${p.nota}',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _subtotal(BuildContext context, String texto, double valor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Subtotal ${texto.toLowerCase()}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Text(
            fmtMonto(valor),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }

  Widget _linea(
    BuildContext context,
    String texto,
    String valor, {
    bool fuerte = false,
    Color? color,
  }) {
    final base = fuerte
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;
    final estilo = base?.copyWith(
      color: color,
      fontWeight: fuerte ? FontWeight.bold : null,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(texto, style: estilo)),
          Text(valor, style: estilo),
        ],
      ),
    );
  }
}
