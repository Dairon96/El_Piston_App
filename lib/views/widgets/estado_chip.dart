import 'package:flutter/material.dart';

import '../../models/estado_orden.dart';

/// Iconos y colores de cada estado de la orden, calculados desde el tema
/// para que se vean bien tanto en modo claro como en oscuro.
extension EstadoOrdenUi on EstadoOrden {
  IconData get icono => switch (this) {
        EstadoOrden.recibida => Icons.move_to_inbox_outlined,
        EstadoOrden.enDiagnostico => Icons.search,
        EstadoOrden.enReparacion => Icons.build_outlined,
        EstadoOrden.listaParaEntregar => Icons.check_circle_outline,
        EstadoOrden.entregada => Icons.verified_outlined,
        EstadoOrden.cancelada => Icons.cancel_outlined,
      };

  Color color(BuildContext context) {
    final tema = Theme.of(context);
    final oscuro = tema.brightness == Brightness.dark;
    return switch (this) {
      EstadoOrden.recibida =>
        oscuro ? Colors.blueGrey.shade200 : Colors.blueGrey.shade700,
      EstadoOrden.enDiagnostico =>
        oscuro ? Colors.amber.shade300 : Colors.amber.shade900,
      EstadoOrden.enReparacion =>
        oscuro ? Colors.lightBlue.shade200 : Colors.blue.shade800,
      EstadoOrden.listaParaEntregar =>
        oscuro ? Colors.lightGreen.shade300 : Colors.green.shade800,
      EstadoOrden.entregada =>
        oscuro ? Colors.grey.shade400 : Colors.grey.shade700,
      EstadoOrden.cancelada => tema.colorScheme.error,
    };
  }
}

/// Etiqueta de color con el estado de una orden.
class EstadoChip extends StatelessWidget {
  const EstadoChip(this.estado, {super.key});

  final EstadoOrden estado;

  @override
  Widget build(BuildContext context) {
    final color = estado.color(context);
    final fondo = Color.alphaBlend(
      color.withAlpha(40),
      Theme.of(context).colorScheme.surface,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(estado.icono, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            estado.etiqueta,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
