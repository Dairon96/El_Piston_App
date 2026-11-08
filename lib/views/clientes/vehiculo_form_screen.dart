import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../data/app_database.dart';
import '../../viewmodels/clientes_viewmodel.dart';
import '../widgets/ui_helpers.dart';

/// Alta y edición de un vehículo. Si [vehiculo] es null se crea uno nuevo
/// para el cliente [clienteId].
class VehiculoFormScreen extends StatefulWidget {
  const VehiculoFormScreen({
    super.key,
    required this.vm,
    required this.clienteId,
    this.vehiculo,
  });

  final ClientesViewModel vm;
  final int clienteId;
  final Vehiculo? vehiculo;

  @override
  State<VehiculoFormScreen> createState() => _VehiculoFormScreenState();
}

class _VehiculoFormScreenState extends State<VehiculoFormScreen> {
  final _form = GlobalKey<FormState>();
  late final _matricula = TextEditingController(text: widget.vehiculo?.matricula);
  late final _marca = TextEditingController(text: widget.vehiculo?.marca);
  late final _modelo = TextEditingController(text: widget.vehiculo?.modelo);
  late final _anio = TextEditingController(
    text: widget.vehiculo == null ? '' : '${widget.vehiculo!.anio}',
  );
  late final _km = TextEditingController(
    text: widget.vehiculo == null ? '' : '${widget.vehiculo!.kilometraje}',
  );
  bool _guardando = false;

  bool get _editando => widget.vehiculo != null;

  @override
  void dispose() {
    _matricula.dispose();
    _marca.dispose();
    _modelo.dispose();
    _anio.dispose();
    _km.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _guardando = true);
    final router = GoRouter.of(context);

    final ok = await ejecutar(context, () async {
      final anio = int.parse(_anio.text.trim());
      final km = int.parse(_km.text.trim());
      if (_editando) {
        await widget.vm.actualizarVehiculo(
          widget.vehiculo!.id,
          matricula: _matricula.text,
          marca: _marca.text,
          modelo: _modelo.text,
          anio: anio,
          kilometraje: km,
        );
      } else {
        await widget.vm.crearVehiculo(
          clienteId: widget.clienteId,
          matricula: _matricula.text,
          marca: _marca.text,
          modelo: _modelo.text,
          anio: anio,
          kilometraje: km,
        );
      }
    });

    if (!mounted) return;
    if (ok) {
      router.go('/clientes/${widget.clienteId}');
    } else {
      setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final anioMax = DateTime.now().year + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar vehículo' : 'Nuevo vehículo'),
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
                controller: _matricula,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                decoration: decoracion(
                  'Matrícula',
                  icono: Icons.pin_outlined,
                  ayuda: 'Identifica al vehículo cada vez que vuelve',
                ),
                validator: (v) {
                  final t = (v ?? '').trim().replaceAll(' ', '');
                  if (t.length < 3) return 'Escribe la matrícula (mínimo 3 caracteres)';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _marca,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: decoracion('Marca'),
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Obligatoria' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _modelo,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: decoracion('Modelo'),
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Obligatorio' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _anio,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: decoracion('Año'),
                      validator: (v) {
                        final a = int.tryParse((v ?? '').trim());
                        if (a == null || a < 1950 || a > anioMax) {
                          return '1950 - $anioMax';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _km,
                      keyboardType: TextInputType.number,
                      decoration: decoracion('Kilometraje', sufijo: 'km'),
                      validator: (v) {
                        final k = int.tryParse((v ?? '').trim());
                        if (k == null || k < 0) return 'Número válido';
                        final previo = widget.vehiculo?.kilometraje;
                        if (previo != null && k < previo) {
                          return 'Mín. ${fmtKm(previo)}';
                        }
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
                label: Text(_editando ? 'Guardar cambios' : 'Guardar vehículo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
