import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/estado_orden.dart';
import 'daos/clientes_dao.dart';
import 'daos/mecanicos_dao.dart';
import 'daos/ordenes_dao.dart';
import 'daos/repuestos_dao.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// Base de datos única de la app (SQLite en un archivo del teléfono).
/// Funciona sin conexión y conserva los datos aunque la app se cierre.
@DriftDatabase(
  tables: [
    Clientes,
    Vehiculos,
    Mecanicos,
    OrdenesServicio,
    Trabajos,
    Repuestos,
    RepuestosUsados,
    Pagos,
  ],
  daos: [ClientesDao, MecanicosDao, OrdenesDao, RepuestosDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'el_piston'));

  /// Para pruebas con una base en memoria.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // El taller tiene dos mecánicos: se crean al instalar y el dueño
          // les pone su nombre real desde la pantalla "Mecánicos".
          await into(mecanicos)
              .insert(MecanicosCompanion.insert(nombre: 'Mecánico 1'));
          await into(mecanicos)
              .insert(MecanicosCompanion.insert(nombre: 'Mecánico 2'));
        },
        onUpgrade: (m, from, to) async {
          // Cada cambio de esquema futuro se agrega aquí, por ejemplo:
          // if (from < 2) await m.addColumn(clientes, clientes.correo);
        },
        beforeOpen: (details) async {
          // SQLite no verifica las claves foráneas si no se le pide.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
