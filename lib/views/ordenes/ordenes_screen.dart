import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/estado_orden.dart';
import '../../viewmodels/ordenes_viewmodel.dart';
import '../widgets/orden_tile.dart';
import '../widgets/ui_helpers.dart';

/// Lista de órdenes con búsqueda y filtro por estado.
class OrdenesScreen extends StatefulWidget {
  const OrdenesScreen({super.key, required this.vm});

  final OrdenesViewModel vm;

  @override
  State<OrdenesScreen> createState() => _OrdenesScreenState();
}

class _OrdenesScreenState extends State<OrdenesScreen> {
  late final TextEditingController _busqueda;

  @override
  void initState() {
    super.initState();
    _busqueda = TextEditingController(text: widget.vm.busqueda);
  }

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;

    return Scaffold(
      appBar: AppBar(title: const Text('Órdenes de servicio')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/ordenes/nueva'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva orden'),
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
                    controller: _busqueda,
                    textInputAction: TextInputAction.search,
                    decoration: decoracion(
                      'Buscar por matrícula, cliente o problema',
                      icono: Icons.search,
                    ).copyWith(
                      suffixIcon: _busqueda.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Limpiar',
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _busqueda.clear();
                                vm.setBusqueda('');
                              },
                            ),
                    ),
                    onChanged: vm.setBusqueda,
                  ),
                ),
                SizedBox(
                  height: 52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _chip(
                        'Abiertas (${vm.abiertas.length})',
                        vm.filtroAbiertas,
                        vm.filtrarAbiertas,
                      ),
                      for (final e in EstadoOrden.values)
                        _chip(
                          '${e.etiqueta} (${vm.contar(e)})',
                          vm.estadoFiltro == e,
                          () => vm.filtrarEstado(e),
                        ),
                      _chip(
                        'Todas (${vm.todas.length})',
                        vm.filtroTodas,
                        vm.filtrarTodas,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: vm.cargando
                      ? const Center(child: CircularProgressIndicator())
                      : vm.error != null
                          ? EstadoVacio(
                              icono: Icons.error_outline,
                              titulo: 'Algo salió mal',
                              mensaje: vm.error,
                            )
                          : lista.isEmpty
                              ? const EstadoVacio(
                                  icono: Icons.assignment_outlined,
                                  titulo: 'No hay órdenes para mostrar',
                                  mensaje:
                                      'Prueba con otro filtro o crea una orden nueva.',
                                )
                              : ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 4, 16, 96),
                                  itemCount: lista.length,
                                  itemBuilder: (context, i) =>
                                      OrdenTile(orden: lista[i]),
                                ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _chip(String texto, bool seleccionado, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(texto),
        selected: seleccionado,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
