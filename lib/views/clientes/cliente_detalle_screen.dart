import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../data/app_database.dart';
import '../../viewmodels/cliente_detalle_viewmodel.dart';
import '../widgets/orden_tile.dart';
import '../widgets/ui_helpers.dart';

/// Un cliente: sus datos, lo que debe, sus vehículos y su historial.
class ClienteDetalleScreen extends StatefulWidget {
  const ClienteDetalleScreen({
    super.key,
    required this.db,
    required this.clienteId,
  });

  final AppDatabase db;
  final int clienteId;

  @override
  State<ClienteDetalleScreen> createState() => _ClienteDetalleScreenState();
}

class _ClienteDetalleScreenState extends State<ClienteDetalleScreen> {
  late final ClienteDetalleViewModel vm = ClienteDetalleViewModel(
    widget.db.clientesDao,
    widget.db.ordenesDao,
    widget.clienteId,
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
        final c = vm.cliente;
        final tema = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(c?.nombre ?? 'Cliente'),
            actions: [
              if (c != null)
                IconButton(
                  tooltip: 'Editar cliente',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => context.push('/clientes/${c.id}/editar'),
                ),
            ],
          ),
          body: vm.cargando
              ? const Center(child: CircularProgressIndicator())
              : c == null
                  ? const EstadoVacio(
                      icono: Icons.search_off,
                      titulo: 'El cliente no existe',
                    )
                  : PaginaCentrada(
                      maxAncho: 760,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.phone_outlined, size: 18),
                                      const SizedBox(width: 8),
                                      Text(c.telefono),
                                    ],
                                  ),
                                  if (c.direccion != null) ...[
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.home_outlined, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(c.direccion!)),
                                      ],
                                    ),
                                  ],
                                  const Divider(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Saldo pendiente',
                                          style: tema.textTheme.titleMedium,
                                        ),
                                      ),
                                      Text(
                                        fmtMonto(vm.deuda),
                                        style: tema.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: vm.deuda > 0
                                              ? tema.colorScheme.error
                                              : tema.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SeccionTitulo(
                            'Vehículos',
                            accion: TextButton.icon(
                              onPressed: () => context
                                  .push('/clientes/${c.id}/vehiculos/nuevo'),
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar'),
                            ),
                          ),
                          if (vm.vehiculos.isEmpty)
                            const Card(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('Este cliente no tiene vehículos.'),
                              ),
                            )
                          else
                            for (final v in vm.vehiculos)
                              Card(
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.directions_car_outlined),
                                  title: Text('${v.marca} ${v.modelo} · ${v.anio}'),
                                  subtitle: Text(
                                    '${v.matricula} · ${fmtKm(v.kilometraje)}',
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () =>
                                      context.go('/clientes/vehiculos/${v.id}'),
                                ),
                              ),
                          const SeccionTitulo('Historial de servicios'),
                          if (vm.historial.isEmpty)
                            const Card(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('Todavía no tiene servicios.'),
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
