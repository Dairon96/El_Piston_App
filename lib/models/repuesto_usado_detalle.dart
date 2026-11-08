import '../data/app_database.dart';

/// Un repuesto usado en una orden junto con los datos del repuesto
/// (resultado de un JOIN entre RepuestosUsados y Repuestos).
class RepuestoUsadoDetalle {
  const RepuestoUsadoDetalle({required this.uso, required this.repuesto});

  final RepuestoUsado uso;
  final Repuesto repuesto;

  double get subtotal => uso.cantidad * uso.precioUnitario;
}
