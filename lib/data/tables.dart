import 'package:drift/drift.dart';

import '../models/estado_orden.dart';

// Modelo de datos del taller "El Pistón".
//
//  Clientes 1──* Vehiculos 1──* OrdenesServicio *──1 Mecanicos
//                                   │1
//                  ┌────────────────┼────────────────┐
//                  *                *                *
//              Trabajos      RepuestosUsados *──1 Repuestos      Pagos
//
// Cada getter es una columna y los nombres de columna salen del código
// (por ejemplo `precioManoObra` -> `precio_mano_obra`).

@DataClassName('Cliente')
class Clientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 80)();
  TextColumn get telefono => text().withLength(min: 1, max: 30)();
  // La dirección es opcional: "a veces" se anota.
  TextColumn get direccion => text().nullable()();
}

@DataClassName('Vehiculo')
class Vehiculos extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Un cliente puede traer varios vehículos.
  IntColumn get clienteId => integer().references(Clientes, #id)();
  // La matrícula identifica al vehículo: un vehículo puede volver muchas veces.
  TextColumn get matricula => text().withLength(min: 3, max: 15).unique()();
  TextColumn get marca => text().withLength(min: 1, max: 40)();
  TextColumn get modelo => text().withLength(min: 1, max: 40)();
  IntColumn get anio => integer()();
  // Kilometraje con el que llegó la última vez.
  IntColumn get kilometraje => integer().withDefault(const Constant(0))();
}

@DataClassName('Mecanico')
class Mecanicos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 60)();
  // Un mecánico inactivo no aparece al asignar órdenes nuevas, pero
  // conserva su historial.
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
}

@DataClassName('OrdenServicio')
class OrdenesServicio extends Table {
  @override
  String get tableName => 'ordenes_servicio';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehiculoId => integer().references(Vehiculos, #id)();
  IntColumn get mecanicoId => integer().references(Mecanicos, #id)();
  DateTimeColumn get fechaEntrada => dateTime()();
  TextColumn get problema => text().withLength(min: 1, max: 500)();
  IntColumn get estado => intEnum<EstadoOrden>()();
  // Kilometraje que marcaba el vehículo al ingresar en ESTA visita.
  IntColumn get kilometrajeIngreso => integer()();
  // Se llena al entregar o cancelar.
  DateTimeColumn get fechaCierre => dateTime().nullable()();
}

@DataClassName('Trabajo')
class Trabajos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesServicio, #id)();
  TextColumn get descripcion => text().withLength(min: 1, max: 120)();
  // Precio de la mano de obra de este trabajo.
  RealColumn get precioManoObra => real()();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('Repuesto')
class Repuestos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 80)();
  TextColumn get codigo => text().withLength(min: 1, max: 30).unique()();
  RealColumn get precioVenta => real()();
  IntColumn get existencias => integer().withDefault(const Constant(0))();
  // Cuando las existencias bajan a este número (o menos) se avisa al dueño.
  IntColumn get stockMinimo => integer().withDefault(const Constant(3))();
}

@DataClassName('RepuestoUsado')
class RepuestosUsados extends Table {
  @override
  String get tableName => 'repuestos_usados';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesServicio, #id)();
  IntColumn get repuestoId => integer().references(Repuestos, #id)();
  IntColumn get cantidad => integer()();
  // Se guarda el precio del momento: si mañana sube el repuesto, las
  // órdenes ya hechas no cambian de total.
  RealColumn get precioUnitario => real()();
}

@DataClassName('Pago')
class Pagos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesServicio, #id)();
  RealColumn get monto => real()();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  TextColumn get nota => text().nullable()();
}
