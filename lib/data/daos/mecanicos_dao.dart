import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'mecanicos_dao.g.dart';

@DriftAccessor(tables: [Mecanicos])
class MecanicosDao extends DatabaseAccessor<AppDatabase>
    with _$MecanicosDaoMixin {
  MecanicosDao(super.attachedDatabase);

  Stream<List<Mecanico>> watchMecanicos() {
    return (select(mecanicos)..orderBy([(m) => OrderingTerm.asc(m.nombre)]))
        .watch();
  }

  Future<List<Mecanico>> obtenerMecanicos() {
    return (select(mecanicos)..orderBy([(m) => OrderingTerm.asc(m.id)])).get();
  }

  Future<int> crearMecanico(String nombre) {
    return into(mecanicos).insert(MecanicosCompanion.insert(nombre: nombre));
  }

  Future<void> renombrar(int id, String nombre) async {
    await (update(mecanicos)..where((m) => m.id.equals(id)))
        .write(MecanicosCompanion(nombre: Value(nombre)));
  }

  Future<void> setActivo(int id, bool activo) async {
    await (update(mecanicos)..where((m) => m.id.equals(id)))
        .write(MecanicosCompanion(activo: Value(activo)));
  }
}
