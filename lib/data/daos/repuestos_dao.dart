import 'package:drift/drift.dart';

import '../../core/errors.dart';
import '../app_database.dart';
import '../tables.dart';

part 'repuestos_dao.g.dart';

/// Inventario de repuestos.
@DriftAccessor(tables: [Repuestos])
class RepuestosDao extends DatabaseAccessor<AppDatabase>
    with _$RepuestosDaoMixin {
  RepuestosDao(super.attachedDatabase);

  Stream<List<Repuesto>> watchRepuestos() {
    return (select(repuestos)..orderBy([(r) => OrderingTerm.asc(r.nombre)]))
        .watch();
  }

  Future<Repuesto?> buscarPorCodigo(String codigo) {
    return (select(repuestos)..where((r) => r.codigo.equals(codigo)))
        .getSingleOrNull();
  }

  Future<int> crearRepuesto({
    required String nombre,
    required String codigo,
    required double precioVenta,
    required int existencias,
    required int stockMinimo,
  }) async {
    if (await buscarPorCodigo(codigo) != null) {
      throw ReglaNegocio('Ya existe un repuesto con el código $codigo.');
    }
    return into(repuestos).insert(
      RepuestosCompanion.insert(
        nombre: nombre,
        codigo: codigo,
        precioVenta: precioVenta,
        existencias: Value(existencias),
        stockMinimo: Value(stockMinimo),
      ),
    );
  }

  Future<void> actualizarRepuesto(
    int id, {
    required String nombre,
    required String codigo,
    required double precioVenta,
    required int existencias,
    required int stockMinimo,
  }) async {
    final otro = await buscarPorCodigo(codigo);
    if (otro != null && otro.id != id) {
      throw ReglaNegocio('Ya existe otro repuesto con el código $codigo.');
    }
    await (update(repuestos)..where((r) => r.id.equals(id))).write(
      RepuestosCompanion(
        nombre: Value(nombre),
        codigo: Value(codigo),
        precioVenta: Value(precioVenta),
        existencias: Value(existencias),
        stockMinimo: Value(stockMinimo),
      ),
    );
  }

  /// Suma unidades al inventario (cuando el taller compra repuestos).
  Future<void> reponer(int id, int unidades) {
    return transaction(() async {
      if (unidades <= 0) {
        throw const ReglaNegocio('La cantidad a reponer debe ser mayor que 0.');
      }
      final r = await (select(repuestos)..where((x) => x.id.equals(id)))
          .getSingle();
      await (update(repuestos)..where((x) => x.id.equals(id)))
          .write(RepuestosCompanion(existencias: Value(r.existencias + unidades)));
    });
  }
}
