import '../data/app_database.dart';

/// Un vehículo junto con su dueño (resultado de un JOIN).
class VehiculoConCliente {
  const VehiculoConCliente(this.vehiculo, this.cliente);

  final Vehiculo vehiculo;
  final Cliente cliente;

  String get titulo =>
      '${vehiculo.marca} ${vehiculo.modelo} · ${vehiculo.matricula}';
}
