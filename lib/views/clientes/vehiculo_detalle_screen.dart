import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../data/app_database.dart';
import '../../viewmodels/vehiculo_detalle_viewmodel.dart';
import '../widgets/orden_tile.dart';
import '../widgets/ui_helpers.dart';

/// Un vehículo: sus datos y todas las veces que ha venido al taller.
class VehiculoDetalleScreen extends StatefulWidget {
  const VehiculoDetalleScreen({
    super.key,
    required this.db,
    required this.vehiculoId,
  });

  final AppDatabase db;
  final int vehiculoId;

  @override
  State<VehiculoDetalleScreen> createState() => _VehiculoDetalleScreenState();
}

class _VehiculoDetalleScreenState extends State<VehiculoDetalleScreen> {
  late final VehiculoDetalleViewModel vm = VehiculoDetalleViewModel(
    widget.db.clientesDao,
    widget.db.ordenesDao,
    widget.vehiculoId,
  );

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        final v = vm.vehiculo;
        final c = vm.cliente;
        final tema = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(v == null ? 'Vehículo' : v.matricula),
            actions: [
              if (v != null)
                IconButton(
                  tooltip: 'Editar vehículo',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      context.push('/clientes/vehiculos/${v.id}/editar'),
                ),
            ],
          ),
          floatingActionButton: v == null
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => context.push('/ordenes/nueva?vehiculo=${v.id}'),
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva orden'),
                ),
          body: vm.cargando
              ? const Center(child: CircularProgressIndicator())
              : v == null
                  ? const EstadoVacio(
                      icono: Icons.search_off,
                      titulo: 'El vehículo no existe',
                    )
                  : PaginaCentrada(
                      maxAncho: 760,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${v.marca} ${v.modelo}',
                                    style: tema.textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Año ${v.anio}'),
                                  Text(
                                    'Último kilometraje: ${fmtKm(v.kilometraje)}',
                                  ),
                                  if (c != null) ...[
                                    const Divider(height: 24),
                                    InkWell(
                                      onTap: () =>
                                          context.go('/clientes/${c.id}'),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 4),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.person_outline),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Dueño: ${c.nombre}',
                                                style: TextStyle(
                                                  color: tema.colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                            const Icon(Icons.chevron_right),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          SeccionTitulo(
                            'Historial de servicios (${vm.historial.length})',
                          ),
                          if (vm.historial.isEmpty)
                            const Card(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('Este vehículo aún no tiene servicios.'),
                              ),
                            )
                          else
                            for (final o in vm.historial) OrdenTile(orden: o),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
