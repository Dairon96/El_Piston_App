import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../data/app_database.dart';
import '../../viewmodels/inventario_viewmodel.dart';
import '../widgets/ui_helpers.dart';

/// Alta y edición de un repuesto. Si [repuesto] es null se crea uno nuevo.
class RepuestoFormScreen extends StatefulWidget {
  const RepuestoFormScreen({super.key, required this.vm, this.repuesto});

  final InventarioViewModel vm;
  final Repuesto? repuesto;

  @override
  State<RepuestoFormScreen> createState() => _RepuestoFormScreenState();
}

class _RepuestoFormScreenState extends State<RepuestoFormScreen> {
  final _form = GlobalKey<FormState>();
  late final _nombre = TextEditingController(text: widget.repuesto?.nombre);
  late final _codigo = TextEditingController(text: widget.repuesto?.codigo);
  late final _precio = TextEditingController(
    text: widget.repuesto == null
        ? ''
        : widget.repuesto!.precioVenta.toStringAsFixed(2),
  );
  late final _existencias = TextEditingController(
    text: widget.repuesto == null ? '' : '${widget.repuesto!.existencias}',
  );
  late final _minimo = TextEditingController(
    text: widget.repuesto == null ? '3' : '${widget.repuesto!.stockMinimo}',
  );
  bool _guardando = false;

  bool get _editando => widget.repuesto != null;

  @override
  void dispose() {
    _nombre.dispose();
    _codigo.dispose();
    _precio.dispose();
    _existencias.dispose();
    _minimo.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _guardando = true);
    final router = GoRouter.of(context);

    final ok = await ejecutar(context, () async {
      final precio = redondear(leerNumero(_precio.text)!);
      final stock = int.parse(_existencias.text.trim());
      final minimo = int.parse(_minimo.text.trim());
      if (_editando) {
        await widget.vm.actualizarRepuesto(
          widget.repuesto!.id,
          nombre: _nombre.text,
          codigo: _codigo.text,
          precioVenta: precio,
          existencias: stock,
          stockMinimo: minimo,
        );
      } else {
        await widget.vm.crearRepuesto(
          nombre: _nombre.text,
          codigo: _codigo.text,
          precioVenta: precio,
          existencias: stock,
          stockMinimo: minimo,
        );
      }
    });

    if (!mounted) return;
    if (ok) {
      router.pop();
    } else {
      setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar repuesto' : 'Nuevo repuesto'),
      ),
      body: PaginaCentrada(
        maxAncho: 640,
        child: Form(
          key: _form,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nombre,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                decoration: decoracion('Nombre', icono: Icons.settings_outlined),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Escribe el nombre del repuesto' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codigo,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                decoration: decoracion('Código', icono: Icons.qr_code_2),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Escribe el código' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precio,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                decoration: decoracion('Precio de venta', prefijo: '\$ '),
                validator: (v) {
                  final n = leerNumero(v ?? '');
                  if (n == null || n <= 0) return 'Escribe un precio mayor que 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _existencias,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: decoracion('Existencias'),
                      validator: (v) {
                        final n = int.tryParse((v ?? '').trim());
                        if (n == null || n < 0) return 'Número válido';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _minimo,
                      keyboardType: TextInputType.number,
                      decoration: decoracion(
                        'Avisar al llegar a',
                        ayuda: 'Stock mínimo',
                      ),
                      validator: (v) {
                        final n = int.tryParse((v ?? '').trim());
                        if (n == null || n < 0) return 'Número válido';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardando ? null : _guardar,
                icon: const Icon(Icons.check),
                label: Text(_editando ? 'Guardar cambios' : 'Guardar repuesto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
