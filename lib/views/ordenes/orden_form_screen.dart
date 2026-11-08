import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors.dart';
import '../../core/format.dart';
import '../../data/app_database.dart';
import '../../models/vehiculo_con_cliente.dart';
import '../../viewmodels/clientes_viewmodel.dart';
import '../../viewmodels/mecanicos_viewmodel.dart';
import '../../viewmodels/ordenes_viewmodel.dart';
import '../widgets/ui_helpers.dart';

/// Formulario para registrar la llegada de un vehículo (nueva orden).
class OrdenFormScreen extends StatefulWidget {
  const OrdenFormScreen({
    super.key,
    required this.ordenes,
    required this.clientes,
    required this.mecanicos,
    this.vehiculoIdInicial,
  });

  final OrdenesViewModel ordenes;
  final ClientesViewModel clientes;
  final MecanicosViewModel mecanicos;
  final int? vehiculoIdInicial;

  @override
  State<OrdenFormScreen> createState() => _OrdenFormScreenState();
}

class _OrdenFormScreenState extends State<OrdenFormScreen> {
  final _form = GlobalKey<FormState>();
  final _km = TextEditingController();
  final _problema = TextEditingController();

  VehiculoConCliente? _vehiculo;
  Mecanico? _mecanico;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    final id = widget.vehiculoIdInicial;
    if (id != null) {
      for (final v in widget.clientes.vehiculos) {
        if (v.vehiculo.id == id) {
          _vehiculo = v;
          _km.text = '${v.vehiculo.kilometraje}';
        }
      }
    }
    // Se sugiere el mecánico con menos trabajo para repartir mejor la carga.
    _mecanico =
        widget.mecanicos.menosCargado(widget.ordenes.abiertasPorMecanico);
  }

  @override
  void dispose() {
    _km.dispose();
    _problema.dispose();
    super.dispose();
  }

  Future<void> _elegirVehiculo() async {
    final elegido = await elegirDeLista<VehiculoConCliente>(
      context,
      titulo: 'Elegir vehículo',
      items: widget.clientes.vehiculos,
      etiqueta: (v) => v.titulo,
      detalle: (v) => 'Cliente: ${v.cliente.nombre}',
      seleccionado: _vehiculo,
    );
    if (elegido == null) return;
    setState(() {
      _vehiculo = elegido;
      _km.text = '${elegido.vehiculo.kilometraje}';
    });
  }

  Future<void> _elegirMecanico() async {
    final carga = widget.ordenes.abiertasPorMecanico;
    final elegido = await elegirDeLista<Mecanico>(
      context,
      titulo: 'Asignar a un mecánico',
      items: widget.mecanicos.activos,
      etiqueta: (m) => m.nombre,
      detalle: (m) => '${carga[m.id] ?? 0} órdenes abiertas',
      seleccionado: _mecanico,
      buscable: false,
    );
    if (elegido != null) setState(() => _mecanico = elegido);
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _guardando = true);
    final router = GoRouter.of(context);
    final mensajero = ScaffoldMessenger.of(context);
    final colorError = Theme.of(context).colorScheme.error;

    try {
      final id = await widget.ordenes.crearOrden(
        vehiculoId: _vehiculo!.vehiculo.id,
        mecanicoId: _mecanico!.id,
        problema: _problema.text,
        kilometraje: int.parse(_km.text.trim()),
      );
      mensajero.showSnackBar(SnackBar(content: Text('Orden #$id creada')));
      router.go('/ordenes/$id');
    } on ReglaNegocio catch (e) {
      mensajero.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: colorError),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sinVehiculos = widget.clientes.vehiculos.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva orden de servicio')),
      body: PaginaCentrada(
        maxAncho: 640,
        child: Form(
          key: _form,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (sinVehiculos)
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Todavía no hay vehículos registrados. Primero registra '
                          'al cliente y su vehículo.',
                        ),
                        const SizedBox(height: 8),
                        FilledButton.tonalIcon(
                          onPressed: () => context.push('/clientes/nuevo'),
                          icon: const Icon(Icons.person_add_alt),
                          label: const Text('Registrar cliente'),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                CampoSelector(
                  etiqueta: 'Vehículo',
                  icono: Icons.directions_car_outlined,
                  valor: _vehiculo?.titulo,
                  ayuda: _vehiculo == null
                      ? 'Busca por matrícula, marca o cliente'
                      : 'Cliente: ${_vehiculo!.cliente.nombre}',
                  mensajeRequerido: 'Selecciona el vehículo',
                  onTap: _elegirVehiculo,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => context.push('/clientes/nuevo'),
                    icon: const Icon(Icons.person_add_alt, size: 18),
                    label: const Text('Es un cliente o vehículo nuevo'),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              TextFormField(
                controller: _km,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: decoracion(
                  'Kilometraje al ingresar',
                  icono: Icons.speed,
                  sufijo: 'km',
                  ayuda: _vehiculo == null
                      ? null
                      : 'Última vez: ${fmtKm(_vehiculo!.vehiculo.kilometraje)}',
                ),
                validator: (valor) {
                  final km = int.tryParse((valor ?? '').trim());
                  if (km == null || km < 0) return 'Escribe un kilometraje válido';
                  final ultimo = _vehiculo?.vehiculo.kilometraje;
                  if (ultimo != null && km < ultimo) {
                    return 'No puede ser menor al último registrado '
                        '(${fmtKm(ultimo)})';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _problema,
                maxLines: 4,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                decoration: decoracion(
                  'Problema que reporta el cliente',
                  icono: Icons.report_problem_outlined,
                ),
                validator: (valor) {
                  if ((valor ?? '').trim().length < 5) {
                    return 'Describe el problema (mínimo 5 caracteres)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              CampoSelector(
                etiqueta: 'Mecánico asignado',
                icono: Icons.engineering_outlined,
                valor: _mecanico?.nombre,
                ayuda: 'Se sugiere el que tiene menos trabajo',
                mensajeRequerido: 'Asigna un mecánico',
                onTap: _elegirMecanico,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardando || sinVehiculos ? null : _guardar,
                icon: _guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                label: const Text('Crear orden'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
