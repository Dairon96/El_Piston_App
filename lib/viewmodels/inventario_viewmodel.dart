import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/app_database.dart';
import '../data/daos/repuestos_dao.dart';

/// Inventario de repuestos y alertas de "por agotarse".
class InventarioViewModel extends ChangeNotifier {
  InventarioViewModel(this._dao) {
    _sub = _dao.watchRepuestos().listen((l) {
      _todos = l;
      _cargando = false;
      notifyListeners();
    });
  }

  final RepuestosDao _dao;
  StreamSubscription<List<Repuesto>>? _sub;

  List<Repuesto> _todos = const [];
  bool _cargando = true;
  bool _soloBajo = false;
  String _busqueda = '';

  bool get cargando => _cargando;
  List<Repuesto> get todos => _todos;
  bool get soloBajo => _soloBajo;
  String get busqueda => _busqueda;

  /// Un repuesto está "por agotarse" cuando sus existencias llegan al
  /// mínimo que definió el dueño (o menos).
  static bool estaPorAgotarse(Repuesto r) => r.existencias <= r.stockMinimo;

  List<Repuesto> get bajoStock => _todos.where(estaPorAgotarse).toList();

  /// Repuestos con al menos una unidad disponible (para usar en órdenes).
  List<Repuesto> get disponibles =>
      _todos.where((r) => r.existencias > 0).toList();

  List<Repuesto> get visibles {
    Iterable<Repuesto> lista = _soloBajo ? _todos.where(estaPorAgotarse) : _todos;
    final q = _busqueda.trim().toLowerCase();
    if (q.isNotEmpty) {
      lista = lista.where(
        (r) => r.nombre.toLowerCase().contains(q) ||
            r.codigo.toLowerCase().contains(q),
      );
    }
    return lista.toList();
  }

  void setSoloBajo(bool valor) {
    _soloBajo = valor;
    notifyListeners();
  }

  void setBusqueda(String texto) {
    _busqueda = texto;
    notifyListeners();
  }

  Future<int> crearRepuesto({
    required String nombre,
    required String codigo,
    required double precioVenta,
    required int existencias,
    required int stockMinimo,
  }) {
    return _dao.crearRepuesto(
      nombre: nombre.trim(),
      codigo: codigo.trim().toUpperCase(),
      precioVenta: precioVenta,
      existencias: existencias,
      stockMinimo: stockMinimo,
    );
  }

  Future<void> actualizarRepuesto(
    int id, {
    required String nombre,
    required String codigo,
    required double precioVenta,
    required int existencias,
    required int stockMinimo,
  }) {
    return _dao.actualizarRepuesto(
      id,
      nombre: nombre.trim(),
      codigo: codigo.trim().toUpperCase(),
      precioVenta: precioVenta,
      existencias: existencias,
      stockMinimo: stockMinimo,
    );
  }

  Future<void> reponer(int id, int unidades) => _dao.reponer(id, unidades);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
