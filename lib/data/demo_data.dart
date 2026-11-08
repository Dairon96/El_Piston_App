import '../core/errors.dart';
import '../models/estado_orden.dart';
import 'app_database.dart';

/// Carga datos de ejemplo para poder probar la app (y tomar las capturas)
/// sin tener que escribir todo a mano. Solo funciona con la base vacía.
Future<void> cargarDatosDemo(AppDatabase db) async {
  if (await db.clientesDao.contarClientes() > 0) {
    throw const ReglaNegocio(
      'Ya hay datos registrados: los ejemplos solo se cargan con la base vacía.',
    );
  }

  final mecanicos = await db.mecanicosDao.obtenerMecanicos();
  final m1 = mecanicos.first.id;
  final m2 = mecanicos.length > 1 ? mecanicos[1].id : m1;

  await db.transaction(() async {
    // ------------------------------------------------------- Inventario
    final repDao = db.repuestosDao;
    final filtro = await repDao.crearRepuesto(
      nombre: 'Filtro de aceite',
      codigo: 'FA-100',
      precioVenta: 12.5,
      existencias: 20,
      stockMinimo: 5,
    );
    final pastillas = await repDao.crearRepuesto(
      nombre: 'Pastillas de freno',
      codigo: 'PF-210',
      precioVenta: 45,
      existencias: 8,
      stockMinimo: 4,
    );
    await repDao.crearRepuesto(
      nombre: 'Bujía',
      codigo: 'BJ-330',
      precioVenta: 6.75,
      existencias: 16,
      stockMinimo: 6,
    );
    // Estos dos quedan "por agotarse" para ver las alertas.
    await repDao.crearRepuesto(
      nombre: 'Batería 12V',
      codigo: 'BT-440',
      precioVenta: 120,
      existencias: 3,
      stockMinimo: 3,
    );
    final aceite = await repDao.crearRepuesto(
      nombre: 'Aceite 10W-40 (1 L)',
      codigo: 'AC-550',
      precioVenta: 9,
      existencias: 6,
      stockMinimo: 6,
    );
    await repDao.crearRepuesto(
      nombre: 'Correa de distribución',
      codigo: 'CD-660',
      precioVenta: 38,
      existencias: 6,
      stockMinimo: 2,
    );

    // --------------------------------------------- Clientes y vehículos
    final cDao = db.clientesDao;
    final maria = await cDao.crearCliente(
      nombre: 'María Fernández',
      telefono: '5551 2345',
      direccion: 'Calle 12 #345, Centro',
    );
    final carlos = await cDao.crearCliente(
      nombre: 'Carlos Pérez',
      telefono: '5552 8890',
    );
    final luisa = await cDao.crearCliente(
      nombre: 'Luisa Gómez',
      telefono: '5553 1122',
      direccion: 'Reparto Sur, edificio 4',
    );

    final corolla = await cDao.crearVehiculo(
      clienteId: maria,
      matricula: 'P123456',
      marca: 'Toyota',
      modelo: 'Corolla',
      anio: 2015,
      kilometraje: 98000,
    );
    final hilux = await cDao.crearVehiculo(
      clienteId: carlos,
      matricula: 'B778899',
      marca: 'Toyota',
      modelo: 'Hilux',
      anio: 2012,
      kilometraje: 156000,
    );
    final civic = await cDao.crearVehiculo(
      clienteId: carlos,
      matricula: 'B445566',
      marca: 'Honda',
      modelo: 'Civic',
      anio: 2018,
      kilometraje: 64000,
    );
    final fiat = await cDao.crearVehiculo(
      clienteId: luisa,
      matricula: 'P987654',
      marca: 'Fiat',
      modelo: 'Uno',
      anio: 2009,
      kilometraje: 121000,
    );

    // ----------------------------------------------------------- Órdenes
    final oDao = db.ordenesDao;

    // 1) En reparación, con pago parcial.
    final o1 = await oDao.crearOrden(
      vehiculoId: corolla,
      mecanicoId: m1,
      problema: 'Ruido metálico al frenar',
      kilometraje: 98500,
    );
    await oDao.cambiarEstado(o1, EstadoOrden.enReparacion);
    await oDao.agregarTrabajo(
      ordenId: o1,
      descripcion: 'Cambio de pastillas de freno',
      precioManoObra: 35,
    );
    await oDao.agregarRepuesto(ordenId: o1, repuestoId: pastillas, cantidad: 1);
    await oDao.registrarPago(ordenId: o1, monto: 40, nota: 'Adelanto');

    // 2) Entregada y pagada completa.
    final o2 = await oDao.crearOrden(
      vehiculoId: hilux,
      mecanicoId: m2,
      problema: 'Cambio de aceite y filtro',
      kilometraje: 156400,
    );
    await oDao.agregarTrabajo(
      ordenId: o2,
      descripcion: 'Cambio de aceite y filtro',
      precioManoObra: 20,
    );
    await oDao.agregarRepuesto(ordenId: o2, repuestoId: filtro, cantidad: 1);
    await oDao.agregarRepuesto(ordenId: o2, repuestoId: aceite, cantidad: 4);
    await oDao.registrarPago(ordenId: o2, monto: 68.5, nota: 'Pago completo');
    await oDao.cambiarEstado(o2, EstadoOrden.entregada);

    // 3) En diagnóstico, sin trabajos todavía.
    final o3 = await oDao.crearOrden(
      vehiculoId: civic,
      mecanicoId: m2,
      problema: 'No arranca por las mañanas',
      kilometraje: 64300,
    );
    await oDao.cambiarEstado(o3, EstadoOrden.enDiagnostico);

    // 4) Lista para entregar, el cliente todavía no paga.
    final o4 = await oDao.crearOrden(
      vehiculoId: fiat,
      mecanicoId: m1,
      problema: 'Alineación y balanceo',
      kilometraje: 121400,
    );
    await oDao.agregarTrabajo(
      ordenId: o4,
      descripcion: 'Alineación y balanceo',
      precioManoObra: 25,
    );
    await oDao.cambiarEstado(o4, EstadoOrden.listaParaEntregar);
  });
}
