import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/app_database.dart';
import '../data/daos/ordenes_dao.dart';
import '../models/estado_orden.dart';
import '../models/orden_resumen.dart';
import '../models/repuesto_usado_detalle.dart';

/// ViewModel de UNA orden: la orden con sus totales, sus trabajos, sus
/// repuestos y sus pagos. Cada pantalla de detalle crea el suyo y lo libera
/// en dispose.
class OrdenDetalleViewModel extends ChangeNotifier {
  OrdenDetalleViewModel(this._dao, this.ordenId) {
    _subs.add(
      _dao.watchOrden(ordenId).listen((o) {
        _orden = o;
        _cargando = false;
        notifyListeners();
      }),
    );
    _subs.add(
      _dao.watchTrabajos(ordenId).listen((l) {
        _trabajos = l;
        notifyListeners();
      }),
    );
    _subs.add(
      _dao.watchRepuestosUsados(ordenId).listen((l) {
        _repuestos = l;
        notifyListeners();
      }),
    );
    _subs.add(
      _dao.watchPagos(ordenId).listen((l) {
        _pagos = l;
        notifyListeners();
      }),
    );
  }

  final OrdenesDao _dao;
  final int ordenId;
  final List<StreamSubscription<dynamic>> _subs = [];

  OrdenResumen? _orden;
  List<Trabajo> _trabajos = const [];
  List<RepuestoUsadoDetalle> _repuestos = const [];
  List<Pago> _pagos = const [];
  bool _cargando = true;

  bool get cargando => _cargando;
  OrdenResumen? get orden => _orden;
  List<Trabajo> get trabajos => _trabajos;
  List<RepuestoUsadoDetalle> get repuestos => _repuestos;
  List<Pago> get pagos => _pagos;

  // ----------------------------------------------------------------- Acciones

  Future<void> cambiarEstado(EstadoOrden nuevo) =>
      _dao.cambiarEstado(ordenId, nuevo);

  Future<void> reasignarMecanico(int mecanicoId) =>
      _dao.reasignarMecanico(ordenId, mecanicoId);

  Future<void> agregarTrabajo(String descripcion, double precio) =>
      _dao.agregarTrabajo(
        ordenId: ordenId,
        descripcion: descripcion.trim(),
        precioManoObra: precio,
      );

  Future<void> eliminarTrabajo(int trabajoId) =>
      _dao.eliminarTrabajo(trabajoId);

  /// Devuelve el repuesto con sus existencias ya descontadas.
  Future<Repuesto> agregarRepuesto(int repuestoId, int cantidad) =>
      _dao.agregarRepuesto(
        ordenId: ordenId,
        repuestoId: repuestoId,
        cantidad: cantidad,
      );

  Future<void> quitarRepuesto(int repuestoUsadoId) =>
      _dao.quitarRepuesto(repuestoUsadoId);

  Future<void> registrarPago(double monto, String? nota) => _dao.registrarPago(
        ordenId: ordenId,
        monto: monto,
        nota: (nota == null || nota.trim().isEmpty) ? null : nota.trim(),
      );

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }
}
