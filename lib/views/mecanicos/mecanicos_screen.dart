import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../models/estado_orden.dart';
import '../../viewmodels/mecanicos_viewmodel.dart';
import '../../viewmodels/ordenes_viewmodel.dart';
import '../widgets/estado_chip.dart';
import '../widgets/ui_helpers.dart';

/// Mecánicos del taller y cuánto trabajo tiene cada uno.
class MecanicosScreen extends StatelessWidget {
  const MecanicosScreen({super.key, required this.vm, required this.ordenes});

  final MecanicosViewModel vm;
  final OrdenesViewModel ordenes;

  Future<void> _pedirNombre(BuildContext context, {Mecanico? mecanico}) async {
    final nombre = await showDialog<String>(
      context: context,
      builder: (_) => _DialogoNombre(inicial: mecanico?.nombre),
    );
    if (nombre == null || !context.mounted) return;
    await ejecutar(
      context,
      () => mecanico == null
          ? vm.crear(nombre)
          : vm.renombrar(mecanico.id, nombre),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mecánicos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pedirNombre(context),
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Nuevo mecánico'),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([vm, ordenes]),
        builder: (context, _) {
          if (vm.cargando) {
            return const Center(child: CircularProgressIndicator());
          }
          final tema = Theme.of(context);

          return PaginaCentrada(
            maxAncho: 760,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                for (final m in vm.todos)
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: _tarjeta(context, tema, m),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, ThemeData tema, Mecanico m) {
    final suyas = ordenes.abiertas.where((o) => o.mecanicoId == m.id).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.engineering_outlined,
              color: m.activo ? null : tema.colorScheme.outline,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                m.activo ? m.nombre : '${m.nombre} (inactivo)',
                style: tema.textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: 'Cambiar nombre',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _pedirNombre(context, mecanico: m),
            ),
            Switch(
              value: m.activo,
              onChanged: (v) => ejecutar(context, () => vm.setActivo(m.id, v)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          suyas.isEmpty
              ? 'Sin órdenes abiertas'
              : '${suyas.length} ${suyas.length == 1 ? 'orden abierta' : 'órdenes abiertas'}',
          style: tema.textTheme.labelLarge,
        ),
        if (suyas.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final e in EstadoOrden.abiertos)
                if (suyas.any((o) => o.estado == e))
                  Chip(
                    avatar: Icon(e.icono, size: 16, color: e.color(context)),
                    label: Text(
                      '${e.etiqueta}: ${suyas.where((o) => o.estado == e).length}',
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
            ],
          ),
          const SizedBox(height: 8),
          for (final o in suyas)
            Text(
              '#${o.id} · ${o.matricula} · ${o.problema}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tema.textTheme.bodySmall,
            ),
        ],
      ],
    );
  }
}

class _DialogoNombre extends StatefulWidget {
  const _DialogoNombre({this.inicial});

  final String? inicial;

  @override
  State<_DialogoNombre> createState() => _DialogoNombreState();
}

class _DialogoNombreState extends State<_DialogoNombre> {
  final _form = GlobalKey<FormState>();
  late final _nombre = TextEditingController(text: widget.inicial);

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  void _aceptar() {
    if (!_form.currentState!.validate()) return;
    Navigator.of(context).pop(_nombre.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.inicial == null ? 'Nuevo mecánico' : 'Cambiar nombre'),
      content: Form(
        key: _form,
        child: TextFormField(
          controller: _nombre,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: decoracion('Nombre', icono: Icons.person_outline),
          onFieldSubmitted: (_) => _aceptar(),
          validator: (v) =>
              (v ?? '').trim().length < 2 ? 'Escribe un nombre' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _aceptar, child: const Text('Guardar')),
      ],
    );
  }
}
