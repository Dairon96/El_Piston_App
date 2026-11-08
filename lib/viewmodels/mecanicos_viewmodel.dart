import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/app_database.dart';
import '../data/daos/mecanicos_dao.dart';

/// Los mecánicos del taller.
class MecanicosViewModel extends ChangeNotifier {
  MecanicosViewModel(this._dao) {
    _sub = _dao.watchMecanicos().listen((l) {
      _todos = l;
      _cargando = false;
      notifyListeners();
    });
  }

  final MecanicosDao _dao;
  StreamSubscription<List<Mecanico>>? _sub;

  List<Mecanico> _todos = const [];
  bool _cargando = true;

  bool get cargando => _cargando;
  List<Mecanico> get todos => _todos;

  /// Solo los activos pueden recibir órdenes nuevas.
  List<Mecanico> get activos => _todos.where((m) => m.activo).toList();

  /// El mecánico activo con menos órdenes abiertas (para sugerirlo al crear
  /// una orden y repartir mejor el trabajo).
  Mecanico? menosCargado(Map<int, int> abiertasPorMecanico) {
    Mecanico? mejor;
    var menor = 1 << 30;
    for (final m in activos) {
      final carga = abiertasPorMecanico[m.id] ?? 0;
      if (carga < menor) {
        menor = carga;
        mejor = m;
      }
    }
    return mejor;
  }

  Future<void> crear(String nombre) => _dao.crearMecanico(nombre.trim());

  Future<void> renombrar(int id, String nombre) =>
      _dao.renombrar(id, nombre.trim());

  Future<void> setActivo(int id, bool activo) => _dao.setActivo(id, activo);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
