/// Cuánto debe un cliente en total (suma del saldo de sus órdenes).
class DeudaCliente {
  const DeudaCliente({
    required this.clienteId,
    required this.nombre,
    required this.telefono,
    required this.saldo,
    required this.ordenes,
  });

  final int clienteId;
  final String nombre;
  final String telefono;
  final double saldo;

  /// Cantidad de órdenes con saldo pendiente.
  final int ordenes;
}
