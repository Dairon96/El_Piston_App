import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_database.dart';
import '../../viewmodels/clientes_viewmodel.dart';
import '../widgets/ui_helpers.dart';

/// Alta y edición de un cliente. Si [cliente] es null se crea uno nuevo.
class ClienteFormScreen extends StatefulWidget {
  const ClienteFormScreen({super.key, required this.vm, this.cliente});

  final ClientesViewModel vm;
  final Cliente? cliente;

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _form = GlobalKey<FormState>();
  late final _nombre = TextEditingController(text: widget.cliente?.nombre);
  late final _telefono = TextEditingController(text: widget.cliente?.telefono);
  late final _direccion = TextEditingController(text: widget.cliente?.direccion);
  bool _guardando = false;

  bool get _editando => widget.cliente != null;

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _direccion.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _guardando = true);
    final router = GoRouter.of(context);

    final ok = await ejecutar(context, () async {
      if (_editando) {
        await widget.vm.actualizarCliente(
          widget.cliente!.id,
          nombre: _nombre.text,
          telefono: _telefono.text,
          direccion: _direccion.text,
        );
      } else {
        final id = await widget.vm.crearCliente(
          nombre: _nombre.text,
          telefono: _telefono.text,
          direccion: _direccion.text,
        );
        // Tras crear al cliente, lo natural es registrar su vehículo.
        router.go('/clientes/$id/vehiculos/nuevo');
        return;
      }
      router.pop();
    });

    if (!ok && mounted) setState(() => _guardando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar cliente' : 'Nuevo cliente'),
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
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: decoracion('Nombre completo', icono: Icons.person_outline),
                validator: (v) =>
                    (v ?? '').trim().length < 2 ? 'Escribe el nombre del cliente' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefono,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: decoracion('Teléfono', icono: Icons.phone_outlined),
                validator: (v) {
                  final texto = (v ?? '').trim();
                  final digitos = texto.replaceAll(RegExp(r'\D'), '');
                  if (digitos.length < 6) {
                    return 'Escribe un teléfono válido (mínimo 6 dígitos)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _direccion,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                decoration: decoracion(
                  'Dirección (opcional)',
                  icono: Icons.home_outlined,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardando ? null : _guardar,
                icon: const Icon(Icons.check),
                label: Text(_editando ? 'Guardar cambios' : 'Guardar y agregar vehículo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
