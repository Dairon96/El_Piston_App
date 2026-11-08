import 'package:drift/drift.dart';

import '../../core/errors.dart';
import '../../models/vehiculo_con_cliente.dart';
import '../app_database.dart';
import '../tables.dart';

part 'clientes_dao.g.dart';

/// Consultas de clientes y de sus vehículos.
@DriftAccessor(tables: [Clientes, Vehiculos])
class ClientesDao extends DatabaseAccessor<AppDatabase>
    with _$ClientesDaoMixin {
  ClientesDao(super.attachedDatabase);

  // ---------------------------------------------------------------- Clientes

  Stream<List<Cliente>> watchClientes() {
    return (select(clientes)..orderBy([(c) => OrderingTerm.asc(c.nombre)]))
        .watch();
  }

  Stream<Cliente?> watchCliente(int id) {
    return (select(clientes)..where((c) => c.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<int> contarClientes() async {
    final todos = await select(clientes).get();
    return todos.length;
  }

  Future<int> crearCliente({
    required String nombre,
    required String telefono,
    String? direccion,
  }) {
    return into(clientes).insert(
      ClientesCompanion.insert(
        nombre: nombre,
        telefono: telefono,
        direccion: Value(direccion),
      ),
    );
  }

  Future<void> actualizarCliente(
    int id, {
    required String nombre,
    required String telefono,
    String? direccion,
  }) async {
    await (update(clientes)..where((c) => c.id.equals(id))).write(
      ClientesCompanion(
        nombre: Value(nombre),
        telefono: Value(telefono),
        direccion: Value(direccion),
      ),
    );
  }

  // --------------------------------------------------------------- Vehículos

  Stream<List<Vehiculo>> watchVehiculosDe(int clienteId) {
    return (select(vehiculos)
          ..where((v) => v.clienteId.equals(clienteId))
          ..orderBy([(v) => OrderingTerm.asc(v.matricula)]))
        .watch();
  }

  Stream<Vehiculo?> watchVehiculo(int id) {
    return (select(vehiculos)..where((v) => v.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Todos los vehículos con su dueño (JOIN), para elegirlos al crear una orden.
  Stream<List<VehiculoConCliente>> watchVehiculosConCliente() {
    final consulta = select(vehiculos).join([
      innerJoin(clientes, clientes.id.equalsExp(vehiculos.clienteId)),
    ])
      ..orderBy([OrderingTerm.asc(vehiculos.matricula)]);

    return consulta.watch().map(
          (filas) => filas
              .map(
                (f) => VehiculoConCliente(
                  f.readTable(vehiculos),
                  f.readTable(clientes),
                ),
              )
              .toList(),
        );
  }

  Future<Vehiculo?> buscarPorMatricula(String matricula) {
    return (select(vehiculos)..where((v) => v.matricula.equals(matricula)))
        .getSingleOrNull();
  }

  Future<int> crearVehiculo({
    required int clienteId,
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    required int kilometraje,
  }) async {
    final existente = await buscarPorMatricula(matricula);
    if (existente != null) {
      throw ReglaNegocio('Ya existe un vehículo con la matrícula $matricula.');
    }
    return into(vehiculos).insert(
      VehiculosCompanion.insert(
        clienteId: clienteId,
        matricula: matricula,
        marca: marca,
        modelo: modelo,
        anio: anio,
        kilometraje: Value(kilometraje),
      ),
    );
  }

  Future<void> actualizarVehiculo(
    int id, {
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    required int kilometraje,
  }) async {
    final otro = await buscarPorMatricula(matricula);
    if (otro != null && otro.id != id) {
      throw ReglaNegocio('Ya existe otro vehículo con la matrícula $matricula.');
    }
    await (update(vehiculos)..where((v) => v.id.equals(id))).write(
      VehiculosCompanion(
        matricula: Value(matricula),
        marca: Value(marca),
        modelo: Value(modelo),
        anio: Value(anio),
        kilometraje: Value(kilometraje),
      ),
    );
  }
}
