import '../core/format.dart';
import 'estado_orden.dart';

/// Una orden de servicio con los datos del vehículo, del cliente y del
/// mecánico ya unidos, más los totales económicos calculados en la base
/// de datos (mano de obra, repuestos y pagos).
class OrdenResumen {
  const OrdenResumen({
    required this.id,
    required this.estado,
    required this.fechaEntrada,
    required this.fechaCierre,
    required this.problema,
    required this.kilometraje,
    required this.vehiculoId,
    required this.matricula,
    required this.marca,
    required this.modelo,
    required this.clienteId,
    required this.clienteNombre,
    required this.clienteTelefono,
    required this.mecanicoId,
    required this.mecanicoNombre,
    required this.manoObra,
    required this.repuestos,
    required this.pagado,
  });

  final int id;
  final EstadoOrden estado;
  final DateTime fechaEntrada;
  final DateTime? fechaCierre;
  final String problema;
  final int kilometraje;
  final int vehiculoId;
  final String matricula;
  final String marca;
  final String modelo;
  final int clienteId;
  final String clienteNombre;
  final String clienteTelefono;
  final int mecanicoId;
  final String mecanicoNombre;
  final double manoObra;
  final double repuestos;
  final double pagado;

  String get vehiculo => '$marca $modelo';

  bool get abierta => estado.abierta;

  bool get cancelada => estado == EstadoOrden.cancelada;

  /// Mano de obra + repuestos.
  double get total => redondear(manoObra + repuestos);

  /// Lo que cuenta para facturación: una orden cancelada no se factura.
  double get totalFacturable => cancelada ? 0 : total;

  /// Lo que el cliente todavía debe (nunca negativo; 0 si está cancelada).
  double get saldo {
    if (cancelada) return 0;
    final pendiente = redondear(total - pagado);
    return pendiente < 0.005 ? 0 : pendiente;
  }
}
