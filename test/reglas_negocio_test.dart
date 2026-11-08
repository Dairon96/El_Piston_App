import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:el_piston/core/errors.dart';
import 'package:el_piston/data/app_database.dart';
import 'package:el_piston/models/estado_orden.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pruebas de las reglas del taller sobre una base SQLite en memoria.
void main() {
  late AppDatabase db;
  late int vehiculoId;
  late int mecanicoId;
  late int repuestoId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    mecanicoId = (await db.mecanicosDao.obtenerMecanicos()).first.id;
    final cliente =
        await db.clientesDao.crearCliente(nombre: 'Ana', telefono: '555123');
    vehiculoId = await db.clientesDao.crearVehiculo(
      clienteId: cliente,
      matricula: 'ABC123',
      marca: 'Toyota',
      modelo: 'Corolla',
      anio: 2015,
      kilometraje: 1000,
    );
    repuestoId = await db.repuestosDao.crearRepuesto(
      nombre: 'Filtro',
      codigo: 'F1',
      precioVenta: 10,
      existencias: 5,
      stockMinimo: 2,
    );
  });

  tearDown(() => db.close());

  Future<int> nuevaOrden() => db.ordenesDao.crearOrden(
        vehiculoId: vehiculoId,
        mecanicoId: mecanicoId,
        problema: 'Ruido raro',
        kilometraje: 1200,
      );

  test('usar un repuesto baja las existencias y quitarlo las devuelve',
      () async {
    final orden = await nuevaOrden();
    await db.ordenesDao
        .agregarRepuesto(ordenId: orden, repuestoId: repuestoId, cantidad: 3);

    var rep = await (db.select(db.repuestos)
          ..where((r) => r.id.equals(repuestoId)))
        .getSingle();
    expect(rep.existencias, 2);

    final uso = await db.select(db.repuestosUsados).getSingle();
    await db.ordenesDao.quitarRepuesto(uso.id);
    rep = await (db.select(db.repuestos)..where((r) => r.id.equals(repuestoId)))
        .getSingle();
    expect(rep.existencias, 5);
  });

  test('no se puede usar más repuestos de los que hay', () async {
    final orden = await nuevaOrden();
    expect(
      () => db.ordenesDao.agregarRepuesto(
        ordenId: orden,
        repuestoId: repuestoId,
        cantidad: 6,
      ),
      throwsA(isA<ReglaNegocio>()),
    );
  });

  test('el total es mano de obra + repuestos y el saldo baja con los pagos',
      () async {
    final orden = await nuevaOrden();
    await db.ordenesDao.agregarTrabajo(
      ordenId: orden,
      descripcion: 'Cambio de filtro',
      precioManoObra: 20,
    );
    await db.ordenesDao
        .agregarRepuesto(ordenId: orden, repuestoId: repuestoId, cantidad: 2);

    var o = (await db.ordenesDao.getOrden(orden))!;
    expect(o.manoObra, 20);
    expect(o.repuestos, 20);
    expect(o.total, 40);
    expect(o.saldo, 40);

    await db.ordenesDao.registrarPago(ordenId: orden, monto: 15);
    o = (await db.ordenesDao.getOrden(orden))!;
    expect(o.pagado, 15);
    expect(o.saldo, 25);

    // Un pago mayor al saldo se rechaza.
    expect(
      () => db.ordenesDao.registrarPago(ordenId: orden, monto: 30),
      throwsA(isA<ReglaNegocio>()),
    );

    await db.ordenesDao.registrarPago(ordenId: orden, monto: 25);
    o = (await db.ordenesDao.getOrden(orden))!;
    expect(o.saldo, 0);
  });

  test('cancelar una orden devuelve los repuestos y no se factura', () async {
    final orden = await nuevaOrden();
    await db.ordenesDao.agregarTrabajo(
      ordenId: orden,
      descripcion: 'Revisión',
      precioManoObra: 30,
    );
    await db.ordenesDao
        .agregarRepuesto(ordenId: orden, repuestoId: repuestoId, cantidad: 4);

    await db.ordenesDao.cambiarEstado(orden, EstadoOrden.cancelada);

    final rep = await (db.select(db.repuestos)
          ..where((r) => r.id.equals(repuestoId)))
        .getSingle();
    expect(rep.existencias, 5);

    final o = (await db.ordenesDao.getOrden(orden))!;
    expect(o.cancelada, isTrue);
    expect(o.totalFacturable, 0);
    expect(o.saldo, 0);
    expect(o.fechaCierre, isNotNull);
  });

  test('una orden entregada ya no se puede modificar', () async {
    final orden = await nuevaOrden();
    await db.ordenesDao.cambiarEstado(orden, EstadoOrden.entregada);

    expect(
      () => db.ordenesDao.agregarTrabajo(
        ordenId: orden,
        descripcion: 'Extra',
        precioManoObra: 5,
      ),
      throwsA(isA<ReglaNegocio>()),
    );
    expect(
      () => db.ordenesDao.cambiarEstado(orden, EstadoOrden.recibida),
      throwsA(isA<ReglaNegocio>()),
    );
  });

  test('crear una orden actualiza el kilometraje del vehículo', () async {
    await nuevaOrden();
    final v = await (db.select(db.vehiculos)
          ..where((x) => x.id.equals(vehiculoId)))
        .getSingle();
    expect(v.kilometraje, 1200);
  });

  test('no se repiten matrículas ni códigos de repuesto', () async {
    final cliente = (await db.clientesDao.watchClientes().first).first.id;
    expect(
      () => db.clientesDao.crearVehiculo(
        clienteId: cliente,
        matricula: 'ABC123',
        marca: 'Ford',
        modelo: 'Ka',
        anio: 2010,
        kilometraje: 0,
      ),
      throwsA(isA<ReglaNegocio>()),
    );
    expect(
      () => db.repuestosDao.crearRepuesto(
        nombre: 'Otro',
        codigo: 'F1',
        precioVenta: 1,
        existencias: 1,
        stockMinimo: 1,
      ),
      throwsA(isA<ReglaNegocio>()),
    );
  });

  test('el historial del vehículo y del cliente lista sus órdenes', () async {
    await nuevaOrden();
    await nuevaOrden();
    final cliente = (await db.clientesDao.watchClientes().first).first.id;

    final porVehiculo =
        await db.ordenesDao.watchResumenes(vehiculoId: vehiculoId).first;
    final porCliente =
        await db.ordenesDao.watchResumenes(clienteId: cliente).first;
    expect(porVehiculo.length, 2);
    expect(porCliente.length, 2);
  });
}
