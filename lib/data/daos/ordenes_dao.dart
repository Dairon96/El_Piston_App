import 'package:drift/drift.dart';

import '../../core/errors.dart';
import '../../core/format.dart';
import '../../models/estado_orden.dart';
import '../../models/orden_resumen.dart';
import '../../models/repuesto_usado_detalle.dart';
import '../app_database.dart';
import '../tables.dart';

part 'ordenes_dao.g.dart';

/// Órdenes de servicio: creación, trabajos, repuestos, pagos y cambios de
/// estado. Todas las reglas que tocan varias tablas viven aquí dentro de
/// transacciones (si algo falla, no queda nada a medias).
@DriftAccessor(
  tables: [
    OrdenesServicio,
    Trabajos,
    RepuestosUsados,
    Pagos,
    Repuestos,
    Vehiculos,
    Clientes,
    Mecanicos,
  ],
)
class OrdenesDao extends DatabaseAccessor<AppDatabase>
    with _$OrdenesDaoMixin {
  OrdenesDao(super.attachedDatabase);

  // ------------------------------------------------------------------
  // Consulta principal: la orden con vehículo, cliente, mecánico y totales
  // ------------------------------------------------------------------
  // Se usa SQL con subconsultas para que los totales (mano de obra,
  // repuestos y pagos) se calculen en una sola consulta sin multiplicar filas.
  static const String _sqlResumen = '''
SELECT
  o.id AS id,
  o.estado AS estado,
  o.fecha_entrada AS fecha_entrada,
  o.fecha_cierre AS fecha_cierre,
  o.problema AS problema,
  o.kilometraje_ingreso AS kilometraje,
  v.id AS vehiculo_id,
  v.matricula AS matricula,
  v.marca AS marca,
  v.modelo AS modelo,
  c.id AS cliente_id,
  c.nombre AS cliente_nombre,
  c.telefono AS cliente_telefono,
  m.id AS mecanico_id,
  m.nombre AS mecanico_nombre,
  COALESCE((SELECT SUM(t.precio_mano_obra) FROM trabajos t
            WHERE t.orden_id = o.id), 0.0) AS mano_obra,
  COALESCE((SELECT SUM(r.cantidad * r.precio_unitario) FROM repuestos_usados r
            WHERE r.orden_id = o.id), 0.0) AS repuestos,
  COALESCE((SELECT SUM(p.monto) FROM pagos p
            WHERE p.orden_id = o.id), 0.0) AS pagado
FROM ordenes_servicio o
JOIN vehiculos v ON v.id = o.vehiculo_id
JOIN clientes c ON c.id = v.cliente_id
JOIN mecanicos m ON m.id = o.mecanico_id
''';

  static const String _sqlOrden = ' ORDER BY o.fecha_entrada DESC, o.id DESC';

  Set<ResultSetImplementation> get _tablasResumen => {
        ordenesServicio,
        trabajos,
        repuestosUsados,
        pagos,
        vehiculos,
        clientes,
        mecanicos,
      };

  static OrdenResumen _mapearResumen(QueryRow fila) {
    final d = fila.data;
    double numero(String clave) => (d[clave] as num?)?.toDouble() ?? 0;
    // Drift guarda las fechas como segundos desde 1970.
    DateTime fecha(int segundos) =>
        DateTime.fromMillisecondsSinceEpoch(segundos * 1000);
    final cierre = d['fecha_cierre'] as int?;

    return OrdenResumen(
      id: d['id'] as int,
      estado: EstadoOrden.values[d['estado'] as int],
      fechaEntrada: fecha(d['fecha_entrada'] as int),
      fechaCierre: cierre == null ? null : fecha(cierre),
      problema: d['problema'] as String,
      kilometraje: d['kilometraje'] as int,
      vehiculoId: d['vehiculo_id'] as int,
      matricula: d['matricula'] as String,
      marca: d['marca'] as String,
      modelo: d['modelo'] as String,
      clienteId: d['cliente_id'] as int,
      clienteNombre: d['cliente_nombre'] as String,
      clienteTelefono: d['cliente_telefono'] as String,
      mecanicoId: d['mecanico_id'] as int,
      mecanicoNombre: d['mecanico_nombre'] as String,
      manoObra: numero('mano_obra'),
      repuestos: numero('repuestos'),
      pagado: numero('pagado'),
    );
  }

  Selectable<OrdenResumen> _resumenes({
    String filtro = '',
    List<Variable> variables = const [],
  }) {
    return customSelect(
      '$_sqlResumen $filtro $_sqlOrden',
      variables: variables,
      readsFrom: _tablasResumen,
    ).map(_mapearResumen);
  }

  /// Todas las órdenes (la más reciente primero). Se puede filtrar por
  /// vehículo o por cliente para obtener sus historiales.
  Stream<List<OrdenResumen>> watchResumenes({int? vehiculoId, int? clienteId}) {
    if (vehiculoId != null) {
      return _resumenes(
        filtro: 'WHERE o.vehiculo_id = ?',
        variables: [Variable.withInt(vehiculoId)],
      ).watch();
    }
    if (clienteId != null) {
      return _resumenes(
        filtro: 'WHERE c.id = ?',
        variables: [Variable.withInt(clienteId)],
      ).watch();
    }
    return _resumenes().watch();
  }

  Stream<OrdenResumen?> watchOrden(int id) {
    return _resumenes(
      filtro: 'WHERE o.id = ?',
      variables: [Variable.withInt(id)],
    ).watchSingleOrNull();
  }

  Future<OrdenResumen?> getOrden(int id) {
    return _resumenes(
      filtro: 'WHERE o.id = ?',
      variables: [Variable.withInt(id)],
    ).getSingleOrNull();
  }

  // ------------------------------------------------------------------
  // Detalle de una orden
  // ------------------------------------------------------------------

  Stream<List<Trabajo>> watchTrabajos(int ordenId) {
    return (select(trabajos)
          ..where((t) => t.ordenId.equals(ordenId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  Stream<List<RepuestoUsadoDetalle>> watchRepuestosUsados(int ordenId) {
    final consulta = select(repuestosUsados).join([
      innerJoin(repuestos, repuestos.id.equalsExp(repuestosUsados.repuestoId)),
    ])
      ..where(repuestosUsados.ordenId.equals(ordenId))
      ..orderBy([OrderingTerm.asc(repuestosUsados.id)]);

    return consulta.watch().map(
          (filas) => filas
              .map(
                (f) => RepuestoUsadoDetalle(
                  uso: f.readTable(repuestosUsados),
                  repuesto: f.readTable(repuestos),
                ),
              )
              .toList(),
        );
  }

  Stream<List<Pago>> watchPagos(int ordenId) {
    return (select(pagos)
          ..where((p) => p.ordenId.equals(ordenId))
          ..orderBy([(p) => OrderingTerm.desc(p.id)]))
        .watch();
  }

  /// Pagos cobrados entre [desde] (incluido) y [hasta] (excluido).
  Stream<List<Pago>> watchPagosEnRango(DateTime desde, DateTime hasta) {
    return (select(pagos)
          ..where(
            (p) =>
                p.fecha.isBiggerOrEqualValue(desde) &
                p.fecha.isSmallerThanValue(hasta),
          )
          ..orderBy([(p) => OrderingTerm.desc(p.fecha)]))
        .watch();
  }

  // ------------------------------------------------------------------
  // Reglas de negocio
  // ------------------------------------------------------------------

  Future<EstadoOrden> _estadoDe(int ordenId) async {
    final fila = await (select(ordenesServicio)
          ..where((o) => o.id.equals(ordenId)))
        .getSingleOrNull();
    if (fila == null) throw const ReglaNegocio('La orden ya no existe.');
    return fila.estado;
  }

  Future<void> _exigirAbierta(int ordenId, String accion) async {
    final estado = await _estadoDe(ordenId);
    if (!estado.abierta) {
      throw ReglaNegocio(
        'La orden está ${estado.etiqueta.toLowerCase()}: no se puede $accion.',
      );
    }
  }

  /// Evita que al quitar un trabajo o repuesto el total quede por debajo de
  /// lo que el cliente ya pagó.
  Future<void> _validarTotalContraPagos(int ordenId, double reduccion) async {
    final orden = await getOrden(ordenId);
    if (orden == null) return;
    if (redondear(orden.total - reduccion) < redondear(orden.pagado) - 0.004) {
      throw const ReglaNegocio(
        'No se puede quitar: el cliente ya pagó más que el nuevo total de la orden.',
      );
    }
  }

  /// Crea una orden en estado "recibida" y actualiza el kilometraje del
  /// vehículo (el de la última vez que llegó).
  Future<int> crearOrden({
    required int vehiculoId,
    required int mecanicoId,
    required String problema,
    required int kilometraje,
  }) {
    return transaction(() async {
      final id = await into(ordenesServicio).insert(
        OrdenesServicioCompanion.insert(
          vehiculoId: vehiculoId,
          mecanicoId: mecanicoId,
          fechaEntrada: DateTime.now(),
          problema: problema,
          estado: EstadoOrden.recibida,
          kilometrajeIngreso: kilometraje,
        ),
      );
      await (update(vehiculos)..where((v) => v.id.equals(vehiculoId)))
          .write(VehiculosCompanion(kilometraje: Value(kilometraje)));
      return id;
    });
  }

  Future<void> agregarTrabajo({
    required int ordenId,
    required String descripcion,
    required double precioManoObra,
  }) {
    return transaction(() async {
      await _exigirAbierta(ordenId, 'agregar trabajos');
      await into(trabajos).insert(
        TrabajosCompanion.insert(
          ordenId: ordenId,
          descripcion: descripcion,
          precioManoObra: precioManoObra,
        ),
      );
    });
  }

  Future<void> eliminarTrabajo(int trabajoId) {
    return transaction(() async {
      final trabajo = await (select(trabajos)
            ..where((t) => t.id.equals(trabajoId)))
          .getSingleOrNull();
      if (trabajo == null) return;
      await _exigirAbierta(trabajo.ordenId, 'modificar los trabajos');
      await _validarTotalContraPagos(trabajo.ordenId, trabajo.precioManoObra);
      await (delete(trabajos)..where((t) => t.id.equals(trabajoId))).go();
    });
  }

  /// Usa un repuesto en la orden y DESCUENTA las existencias del inventario.
  /// Devuelve el repuesto ya actualizado para que la pantalla pueda avisar
  /// si quedó por agotarse.
  Future<Repuesto> agregarRepuesto({
    required int ordenId,
    required int repuestoId,
    required int cantidad,
  }) {
    return transaction(() async {
      if (cantidad <= 0) {
        throw const ReglaNegocio('La cantidad debe ser mayor que 0.');
      }
      await _exigirAbierta(ordenId, 'agregar repuestos');

      final rep = await (select(repuestos)
            ..where((r) => r.id.equals(repuestoId)))
          .getSingle();
      if (rep.existencias < cantidad) {
        throw ReglaNegocio(
          'No hay suficientes existencias de ${rep.nombre} '
          '(quedan ${rep.existencias}).',
        );
      }

      // Si ya se usó este repuesto al mismo precio, se suma a esa línea.
      final previos = await (select(repuestosUsados)
            ..where(
              (u) =>
                  u.ordenId.equals(ordenId) &
                  u.repuestoId.equals(repuestoId) &
                  u.precioUnitario.equals(rep.precioVenta),
            ))
          .get();

      if (previos.isNotEmpty) {
        final linea = previos.first;
        await (update(repuestosUsados)..where((u) => u.id.equals(linea.id)))
            .write(
          RepuestosUsadosCompanion(cantidad: Value(linea.cantidad + cantidad)),
        );
      } else {
        await into(repuestosUsados).insert(
          RepuestosUsadosCompanion.insert(
            ordenId: ordenId,
            repuestoId: repuestoId,
            cantidad: cantidad,
            precioUnitario: rep.precioVenta,
          ),
        );
      }

      final nuevasExistencias = rep.existencias - cantidad;
      await (update(repuestos)..where((r) => r.id.equals(repuestoId)))
          .write(RepuestosCompanion(existencias: Value(nuevasExistencias)));

      return rep.copyWith(existencias: nuevasExistencias);
    });
  }

  /// Quita un repuesto de la orden y lo DEVUELVE al inventario.
  Future<void> quitarRepuesto(int repuestoUsadoId) {
    return transaction(() async {
      final uso = await (select(repuestosUsados)
            ..where((u) => u.id.equals(repuestoUsadoId)))
          .getSingleOrNull();
      if (uso == null) return;

      await _exigirAbierta(uso.ordenId, 'modificar los repuestos');
      await _validarTotalContraPagos(
        uso.ordenId,
        uso.cantidad * uso.precioUnitario,
      );

      final rep = await (select(repuestos)
            ..where((r) => r.id.equals(uso.repuestoId)))
          .getSingle();
      await (update(repuestos)..where((r) => r.id.equals(uso.repuestoId)))
          .write(
        RepuestosCompanion(existencias: Value(rep.existencias + uso.cantidad)),
      );
      await (delete(repuestosUsados)..where((u) => u.id.equals(uso.id))).go();
    });
  }

  /// Registra un pago (total o parcial). No puede superar el saldo.
  Future<void> registrarPago({
    required int ordenId,
    required double monto,
    String? nota,
  }) {
    return transaction(() async {
      if (monto <= 0) {
        throw const ReglaNegocio('El monto debe ser mayor que cero.');
      }
      final orden = await getOrden(ordenId);
      if (orden == null) throw const ReglaNegocio('La orden ya no existe.');
      if (orden.cancelada) {
        throw const ReglaNegocio(
          'No se pueden registrar pagos en una orden cancelada.',
        );
      }
      if (monto > orden.saldo + 0.004) {
        throw ReglaNegocio(
          'El pago supera el saldo pendiente (${fmtMonto(orden.saldo)}).',
        );
      }
      await into(pagos).insert(
        PagosCompanion.insert(
          ordenId: ordenId,
          monto: redondear(monto),
          nota: Value(nota),
        ),
      );
    });
  }

  /// Cambia el estado de la orden. Una orden entregada o cancelada ya no
  /// se puede mover. Al cancelar, los repuestos vuelven al inventario.
  Future<void> cambiarEstado(int ordenId, EstadoOrden nuevo) {
    return transaction(() async {
      final actual = await _estadoDe(ordenId);
      if (actual == nuevo) return;
      if (!actual.abierta) {
        throw ReglaNegocio(
          'La orden ya está ${actual.etiqueta.toLowerCase()} y no puede '
          'cambiar de estado.',
        );
      }
      if (nuevo == EstadoOrden.cancelada) {
        await _devolverRepuestos(ordenId);
      }
      await (update(ordenesServicio)..where((o) => o.id.equals(ordenId)))
          .write(
        OrdenesServicioCompanion(
          estado: Value(nuevo),
          fechaCierre: Value(nuevo.abierta ? null : DateTime.now()),
        ),
      );
    });
  }

  Future<void> _devolverRepuestos(int ordenId) async {
    final usos = await (select(repuestosUsados)
          ..where((u) => u.ordenId.equals(ordenId)))
        .get();
    for (final uso in usos) {
      final rep = await (select(repuestos)
            ..where((r) => r.id.equals(uso.repuestoId)))
          .getSingle();
      await (update(repuestos)..where((r) => r.id.equals(uso.repuestoId)))
          .write(
        RepuestosCompanion(existencias: Value(rep.existencias + uso.cantidad)),
      );
    }
  }

  Future<void> reasignarMecanico(int ordenId, int mecanicoId) {
    return transaction(() async {
      await _exigirAbierta(ordenId, 'cambiar de mecánico');
      await (update(ordenesServicio)..where((o) => o.id.equals(ordenId)))
          .write(OrdenesServicioCompanion(mecanicoId: Value(mecanicoId)));
    });
  }
}
