import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../data/app_database.dart';
import '../widgets/ui_helpers.dart';

// Diálogos de captura de la pantalla de detalle de la orden. Cada uno es un
// StatefulWidget para liberar sus controladores correctamente.

// ------------------------------------------------------------------ Trabajo

Future<({String descripcion, double precio})?> pedirTrabajo(
  BuildContext context,
) {
  return showDialog<({String descripcion, double precio})>(
    context: context,
    builder: (_) => const _DialogoTrabajo(),
  );
}

class _DialogoTrabajo extends StatefulWidget {
  const _DialogoTrabajo();

  @override
  State<_DialogoTrabajo> createState() => _DialogoTrabajoState();
}

class _DialogoTrabajoState extends State<_DialogoTrabajo> {
  final _form = GlobalKey<FormState>();
  final _descripcion = TextEditingController();
  final _precio = TextEditingController();

  @override
  void dispose() {
    _descripcion.dispose();
    _precio.dispose();
    super.dispose();
  }

  void _aceptar() {
    if (!_form.currentState!.validate()) return;
    Navigator.of(context).pop((
      descripcion: _descripcion.text.trim(),
      precio: redondear(leerNumero(_precio.text)!),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar trabajo'),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descripcion,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: decoracion(
                'Trabajo realizado',
                ayuda: 'Ej.: cambio de aceite, alineación',
              ),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Describe el trabajo' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _precio,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: decoracion('Mano de obra', prefijo: '\$ '),
              onFieldSubmitted: (_) => _aceptar(),
              validator: (v) {
                final n = leerNumero(v ?? '');
                if (n == null || n < 0) return 'Escribe un precio válido';
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
        FilledButton(onPressed: _aceptar, child: const Text('Agregar')),
      ],
    );
  }
}

// ----------------------------------------------------------------- Repuesto

Future<({Repuesto repuesto, int cantidad})?> pedirRepuesto(
  BuildContext context,
  List<Repuesto> disponibles,
) {
  return showDialog<({Repuesto repuesto, int cantidad})>(
    context: context,
    builder: (_) => _DialogoRepuesto(disponibles: disponibles),
  );
}

class _DialogoRepuesto extends StatefulWidget {
  const _DialogoRepuesto({required this.disponibles});

  final List<Repuesto> disponibles;

  @override
  State<_DialogoRepuesto> createState() => _DialogoRepuestoState();
}

class _DialogoRepuestoState extends State<_DialogoRepuesto> {
  final _form = GlobalKey<FormState>();
  final _cantidad = TextEditingController(text: '1');
  Repuesto? _repuesto;

  @override
  void dispose() {
    _cantidad.dispose();
    super.dispose();
  }

  Future<void> _elegir() async {
    final r = await elegirDeLista<Repuesto>(
      context,
      titulo: 'Elegir repuesto',
      items: widget.disponibles,
      etiqueta: (r) => r.nombre,
      detalle: (r) =>
          '${r.codigo} · ${fmtMonto(r.precioVenta)} · ${r.existencias} en existencia',
      seleccionado: _repuesto,
    );
    if (r != null) setState(() => _repuesto = r);
  }

  void _aceptar() {
    if (!_form.currentState!.validate()) return;
    Navigator.of(context).pop((
      repuesto: _repuesto!,
      cantidad: int.parse(_cantidad.text.trim()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Usar repuesto'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CampoSelector(
                etiqueta: 'Repuesto',
                icono: Icons.settings_outlined,
                valor: _repuesto == null
                    ? null
                    : '${_repuesto!.nombre} (${fmtMonto(_repuesto!.precioVenta)})',
                ayuda: _repuesto == null
                    ? null
                    : 'Disponibles: ${_repuesto!.existencias}',
                mensajeRequerido: 'Selecciona un repuesto',
                onTap: _elegir,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cantidad,
                keyboardType: TextInputType.number,
                decoration: decoracion('Cantidad'),
                onFieldSubmitted: (_) => _aceptar(),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  if (n == null || n <= 0) return 'Escribe una cantidad válida';
                  if (_repuesto != null && n > _repuesto!.existencias) {
                    return 'Solo hay ${_repuesto!.existencias} disponibles';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _aceptar, child: const Text('Agregar')),
      ],
    );
  }
}

// --------------------------------------------------------------------- Pago

Future<({double monto, String? nota})?> pedirPago(
  BuildContext context,
  double saldo,
) {
  return showDialog<({double monto, String? nota})>(
    context: context,
    builder: (_) => _DialogoPago(saldo: saldo),
  );
}

class _DialogoPago extends StatefulWidget {
  const _DialogoPago({required this.saldo});

  final double saldo;

  @override
  State<_DialogoPago> createState() => _DialogoPagoState();
}

class _DialogoPagoState extends State<_DialogoPago> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _monto =
      TextEditingController(text: widget.saldo.toStringAsFixed(2));
  final _nota = TextEditingController();

  @override
  void dispose() {
    _monto.dispose();
    _nota.dispose();
    super.dispose();
  }

  void _aceptar() {
    if (!_form.currentState!.validate()) return;
    final nota = _nota.text.trim();
    Navigator.of(context).pop((
      monto: redondear(leerNumero(_monto.text)!),
      nota: nota.isEmpty ? null : nota,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registrar pago'),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saldo pendiente: ${fmtMonto(widget.saldo)}'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _monto,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: decoracion(
                'Monto recibido',
                prefijo: '\$ ',
                ayuda: 'Puedes pagar una parte ahora y el resto después',
              ),
              validator: (v) {
                final n = leerNumero(v ?? '');
                if (n == null || n <= 0) return 'Escribe un monto mayor que 0';
                if (redondear(n) > widget.saldo + 0.004) {
                  return 'Supera el saldo (${fmtMonto(widget.saldo)})';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nota,
              textCapitalization: TextCapitalization.sentences,
              decoration: decoracion('Nota (opcional)', ayuda: 'Ej.: adelanto'),
              onFieldSubmitted: (_) => _aceptar(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _aceptar, child: const Text('Registrar')),
      ],
    );
  }
}
