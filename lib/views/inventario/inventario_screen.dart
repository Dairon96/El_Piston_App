import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../data/app_database.dart';
import '../../viewmodels/inventario_viewmodel.dart';
import '../widgets/ui_helpers.dart';

/// Inventario de repuestos con alertas visibles de "por agotarse".
class InventarioScreen extends StatelessWidget {
  const InventarioScreen({super.key, required this.vm});

  final InventarioViewModel vm;

  Future<void> _reponer(BuildContext context, Repuesto r) async {
    final unidades = await showDialog<int>(
      context: context,
      builder: (_) => _DialogoReponer(repuesto: r),
    );
    if (unidades == null || !context.mounted) return;
    await ejecutar(
      context,
      () => vm.reponer(r.id, unidades),
      exito: 'Se sumaron $unidades unidades de ${r.nombre}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario de repuestos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/inventario/nuevo'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo repuesto'),
      ),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          final lista = vm.visibles;
          final tema = Theme.of(context);

          return PaginaCentrada(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: TextField(
                    decoration: decoracion(
                      'Buscar por nombre o código',
                      icono: Icons.search,
                    ),
                    onChanged: vm.setBusqueda,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      FilterChip(
                        avatar: const Icon(Icons.warning_amber_rounded, size: 18),
                        label: Text('Por agotarse (${vm.bajoStock.length})'),
                        selected: vm.soloBajo,
                        onSelected: vm.setSoloBajo,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${vm.todos.length} repuestos',
                        style: tema.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: vm.cargando
                      ? const Center(child: CircularProgressIndicator())
                      : lista.isEmpty
                          ? EstadoVacio(
                              icono: Icons.inventory_2_outlined,
                              titulo: vm.soloBajo
                                  ? 'Nada por agotarse'
                                  : 'No hay repuestos',
                              mensaje: vm.soloBajo
                                  ? 'Todos los repuestos tienen existencias suficientes.'
                                  : 'Registra el primer repuesto con el botón de abajo.',
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                              itemCount: lista.length,
                              itemBuilder: (context, i) =>
                                  _tarjeta(context, lista[i]),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Repuesto r) {
    final tema = Theme.of(context);
    final bajo = InventarioViewModel.estaPorAgotarse(r);
    final fondo = bajo ? tema.colorScheme.errorContainer : null;
    final texto = bajo ? tema.colorScheme.onErrorContainer : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: fondo,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/inventario/${r.id}/editar'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                bajo ? Icons.warning_amber_rounded : Icons.settings_outlined,
                color: texto,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.nombre,
                      style: tema.textTheme.titleMedium?.copyWith(color: texto),
                    ),
                    Text(
                      '${r.codigo} · ${fmtMonto(r.precioVenta)}',
                      style: tema.textTheme.bodySmall?.copyWith(color: texto),
                    ),
                    if (bajo)
                      Text(
                        r.existencias == 0
                            ? 'Agotado: hay que comprar'
                            : 'Por agotarse (mínimo ${r.stockMinimo})',
                        style: tema.textTheme.labelMedium?.copyWith(
                          color: texto,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${r.existencias}',
                    style: tema.textTheme.headlineSmall?.copyWith(
                      color: texto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('en stock', style: tema.textTheme.bodySmall?.copyWith(color: texto)),
                ],
              ),
              IconButton(
                tooltip: 'Reponer existencias',
                color: texto,
                icon: const Icon(Icons.add_box_outlined),
                onPressed: () => _reponer(context, r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogoReponer extends StatefulWidget {
  const _DialogoReponer({required this.repuesto});

  final Repuesto repuesto;

  @override
  State<_DialogoReponer> createState() => _DialogoReponerState();
}

class _DialogoReponerState extends State<_DialogoReponer> {
  final _form = GlobalKey<FormState>();
  final _unidades = TextEditingController();

  @override
  void dispose() {
    _unidades.dispose();
    super.dispose();
  }

  void _aceptar() {
    if (!_form.currentState!.validate()) return;
    Navigator.of(context).pop(int.parse(_unidades.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reponer existencias'),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.repuesto.nombre}: hay ${widget.repuesto.existencias} unidades.',
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _unidades,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: decoracion('Unidades compradas'),
              onFieldSubmitted: (_) => _aceptar(),
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null || n <= 0) return 'Escribe una cantidad mayor que 0';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _aceptar, child: const Text('Reponer')),
      ],
    );
  }
}
