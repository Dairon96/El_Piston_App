import 'package:shared_preferences/shared_preferences.dart';

import '../data/app_database.dart';
import '../viewmodels/clientes_viewmodel.dart';
import '../viewmodels/inventario_viewmodel.dart';
import '../viewmodels/mecanicos_viewmodel.dart';
import '../viewmodels/ordenes_viewmodel.dart';
import '../viewmodels/reportes_viewmodel.dart';
import '../viewmodels/tema_viewmodel.dart';

/// Crea UNA sola vez la base de datos y los ViewModels compartidos, y se los
/// entrega a las pantallas por constructor (sin variables globales).
class AppDependencies {
  AppDependencies(SharedPreferences prefs, {AppDatabase? database})
      : db = database ?? AppDatabase(),
        tema = TemaViewModel(prefs) {
    ordenes = OrdenesViewModel(db.ordenesDao);
    clientes = ClientesViewModel(db.clientesDao);
    inventario = InventarioViewModel(db.repuestosDao);
    mecanicos = MecanicosViewModel(db.mecanicosDao);
    reportes = ReportesViewModel(ordenes, db.ordenesDao);
  }

  final AppDatabase db;
  final TemaViewModel tema;
  late final OrdenesViewModel ordenes;
  late final ClientesViewModel clientes;
  late final InventarioViewModel inventario;
  late final MecanicosViewModel mecanicos;
  late final ReportesViewModel reportes;

  Future<void> dispose() async {
    reportes.dispose();
    ordenes.dispose();
    clientes.dispose();
    inventario.dispose();
    mecanicos.dispose();
    tema.dispose();
    await db.close();
  }
}
