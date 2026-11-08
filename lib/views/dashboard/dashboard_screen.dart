import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../models/estado_orden.dart';
import '../../viewmodels/inventario_viewmodel.dart';
import '../../viewmodels/mecanicos_viewmodel.dart';
import '../../viewmodels/ordenes_viewmodel.dart';
import '../widgets/estado_chip.dart';
import '../widgets/orden_tile.dart';
import '../widgets/ui_helpers.dart';

/// Panel de inicio: responde de un vistazo a lo que el dueño necesita saber.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.ordenes,
    required this.inventario,
    required this.mecanicos,
  });

  final OrdenesViewModel ordenes;
  final InventarioViewModel inventario;
  final MecanicosViewModel mecanicos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/ordenes/nueva'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva orden'),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([ordenes, inventario, mecanicos]),
        builder: (context, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar.large(
                title: const Text('El Pistón'),
                actions: [
                  IconButton(
                    tooltip: 'Mecánicos',
                    icon: const Icon(Icons.engineering_outlined),
                    onPressed: () => context.push('/mecanicos'),
                  ),
                  IconButton(
                    tooltip: 'Ajustes',
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => context.push('/ajustes'),
                  ),
                ],
              ),
              if (ordenes.cargando)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverToBoxAdapter(
                  child: PaginaCentrada(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                      child: _contenido(context),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _contenido(BuildContext context) {
    final tema = Theme.of(context);
    final abiertas = ordenes.abiertas;
    final bajo = inventario.bajoStock;
    final carga = ordenes.abiertasPorMecanico;
    final activos = mecanicos.activos;
    final maxCarga = carga.values.fold<int>(0, (m, v) => v > m ? v : m);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ------------------------------------------------------ Indicadores
        Row(
          children: [
            Expanded(
              child: StatCard(
                icono: Icons.assignment_outlined,
                valor: '${abiertas.length}',
                etiqueta: 'Órdenes abiertas',
                onTap: () {
                  ordenes.filtrarAbiertas();
                  context.go('/ordenes');
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                icono: Icons.payments_outlined,
                valor: fmtMonto(ordenes.totalPorCobrar),
                etiqueta: 'Por cobrar',
                onTap: () => context.go('/reportes'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatCard(
                icono: Icons.warning_amber_rounded,
                valor: '${bajo.length}',
                etiqueta: 'Repuestos por agotarse',
                alerta: bajo.isNotEmpty,
                onTap: () {
                  inventario.setSoloBajo(true);
                  context.go('/inventario');
                },
              ),
            ),
          ],
        ),

        // ------------------------------------------- Órdenes por estado
        const SeccionTitulo('Órdenes abiertas por estado'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final estado in EstadoOrden.abiertos)
              ActionChip(
                avatar: Icon(estado.icono, size: 18, color: estado.color(context)),
                label: Text('${estado.etiqueta}: ${ordenes.contar(estado)}'),
                onPressed: () {
                  ordenes.filtrarEstado(estado);
                  context.go('/ordenes');
                },
              ),
          ],
        ),

        // ------------------------------------------- Carga por mecánico
        SeccionTitulo(
          'Carga por mecánico',
          accion: TextButton(
            onPressed: () => context.push('/mecanicos'),
            child: const Text('Ver detalle'),
          ),
        ),
        if (activos.isEmpty)
          const Text('No hay mecánicos activos.')
        else
          for (final m in activos)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.engineering_outlined),
                        const SizedBox(width: 10),
                        Expanded(child: Text(m.nombre)),
                        Text(
                          '${carga[m.id] ?? 0} abiertas',
                          style: tema.textTheme.labelLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: maxCarga == 0 ? 0 : (carga[m.id] ?? 0) / maxCarga,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              ),
            ),

        // ------------------------------------------- Repuestos por agotarse
        if (bajo.isNotEmpty) ...[
          SeccionTitulo(
            'Repuestos por agotarse',
            accion: TextButton(
              onPressed: () {
                inventario.setSoloBajo(true);
                context.go('/inventario');
              },
              child: const Text('Ver inventario'),
            ),
          ),
          for (final r in bajo.take(5))
            Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: tema.colorScheme.errorContainer,
              child: ListTile(
                leading: Icon(
                  Icons.warning_amber_rounded,
                  color: tema.colorScheme.onErrorContainer,
                ),
                title: Text(
                  r.nombre,
                  style: TextStyle(color: tema.colorScheme.onErrorContainer),
                ),
                subtitle: Text(
                  'Código ${r.codigo} · mínimo ${r.stockMinimo}',
                  style: TextStyle(color: tema.colorScheme.onErrorContainer),
                ),
                trailing: Text(
                  r.existencias == 0 ? 'Agotado' : '${r.existencias} uds.',
                  style: tema.textTheme.titleSmall?.copyWith(
                    color: tema.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],

        // ------------------------------------------- Últimas órdenes abiertas
        SeccionTitulo(
          'Órdenes abiertas',
          accion: TextButton(
            onPressed: () {
              ordenes.filtrarAbiertas();
              context.go('/ordenes');
            },
            child: const Text('Ver todas'),
          ),
        ),
        if (abiertas.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: EstadoVacio(
              icono: Icons.task_alt,
              titulo: 'No hay órdenes abiertas',
              mensaje: 'Cuando llegue un cliente, crea una nueva orden.',
            ),
          )
        else
          for (final o in abiertas.take(5)) OrdenTile(orden: o),
      ],
    );
  }
}
