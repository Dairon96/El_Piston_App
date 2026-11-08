import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../viewmodels/clientes_viewmodel.dart';
import '../widgets/ui_helpers.dart';

/// Lista de clientes con búsqueda por nombre, teléfono o matrícula.
class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key, required this.vm});

  final ClientesViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/clientes/nuevo'),
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Nuevo cliente'),
      ),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          final lista = vm.visibles;

          return PaginaCentrada(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: TextField(
                    decoration: decoracion(
                      'Buscar por nombre, teléfono o matrícula',
                      icono: Icons.search,
                    ),
                    onChanged: vm.setBusqueda,
                  ),
                ),
                Expanded(
                  child: vm.cargando
                      ? const Center(child: CircularProgressIndicator())
                      : lista.isEmpty
                          ? EstadoVacio(
                              icono: Icons.people_outline,
                              titulo: vm.busqueda.isEmpty
                                  ? 'Aún no hay clientes'
                                  : 'Sin resultados',
                              mensaje: vm.busqueda.isEmpty
                                  ? 'Registra al primer cliente con el botón de abajo.'
                                  : 'Prueba con otro nombre, teléfono o matrícula.',
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                              itemCount: lista.length,
                              itemBuilder: (context, i) {
                                final c = lista[i];
                                final n = vm.cantidadVehiculos(c.id);
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        c.nombre.characters.first.toUpperCase(),
                                      ),
                                    ),
                                    title: Text(c.nombre),
                                    subtitle: Text(
                                      '${c.telefono} · $n ${n == 1 ? 'vehículo' : 'vehículos'}',
                                    ),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () => context.go('/clientes/${c.id}'),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
