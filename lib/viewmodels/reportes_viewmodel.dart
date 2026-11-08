import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/app_database.dart';
import '../data/daos/ordenes_dao.dart';
import '../models/orden_resumen.dart';
import 'ordenes_viewmodel.dart';

enum PeriodoRapido {
  hoy('Hoy'),
  semana('Esta semana'),
  mes('Este mes'),
  personalizado('Personalizado');

  const PeriodoRapido(this.etiqueta);

  final String etiqueta;
}

/// "¿Cuánto se facturó en un período?"
///
/// - Facturado: total (mano de obra + repuestos) de las órdenes NO canceladas
///   cuya fecha de entrada cae dentro del período.
/// - Cobrado: pagos recibidos dentro del período (sea cual sea la orden).
class ReportesViewModel extends ChangeNotifier {
  ReportesViewModel(this._ordenes, this._dao) {
    _ordenes.addListener(notifyListeners);
    seleccionarRapido(PeriodoRapido.mes);
  }

  final OrdenesViewModel _ordenes;
  final OrdenesDao _dao;

  PeriodoRapido _rapido = PeriodoRapido.mes;
  late DateTime _desde;
  late DateTime _hasta; // inclusive (a las 00:00 del último día)
  StreamSubscription<List<Pago>>? _subPagos;
  List<Pago> _pagos = const [];

  PeriodoRapido get periodo => _rapido;
  DateTime get desde => _desde;
  DateTime get hasta => _hasta;

  static DateTime _soloFecha(DateTime f) => DateTime(f.year, f.month, f.day);

  DateTime get _hastaExclusivo =>
      DateTime(_hasta.year, _hasta.month, _hasta.day + 1);

  void seleccionarRapido(PeriodoRapido p) {
    final hoy = _soloFecha(DateTime.now());
    switch (p) {
      case PeriodoRapido.hoy:
        _desde = hoy;
        _hasta = hoy;
      case PeriodoRapido.semana:
        _desde = DateTime(hoy.year, hoy.month, hoy.day - (hoy.weekday - 1));
        _hasta = DateTime(_desde.year, _desde.month, _desde.day + 6);
      case PeriodoRapido.mes:
        _desde = DateTime(hoy.year, hoy.month, 1);
        _hasta = DateTime(hoy.year, hoy.month + 1, 0);
      case PeriodoRapido.personalizado:
        return;
    }
    _rapido = p;
    _suscribirPagos();
    notifyListeners();
  }

  void seleccionarRango(DateTime desde, DateTime hasta) {
    _desde = _soloFecha(desde);
    _hasta = _soloFecha(hasta);
    _rapido = PeriodoRapido.personalizado;
    _suscribirPagos();
    notifyListeners();
  }

  void _suscribirPagos() {
    _subPagos?.cancel();
    _subPagos = _dao.watchPagosEnRango(_desde, _hastaExclusivo).listen((l) {
      _pagos = l;
      notifyListeners();
    });
  }

  /// Órdenes del período (sin las canceladas).
  List<OrdenResumen> get ordenesPeriodo {
    final fin = _hastaExclusivo;
    return _ordenes.todas
        .where(
          (o) =>
              !o.cancelada &&
              !o.fechaEntrada.isBefore(_desde) &&
              o.fechaEntrada.isBefore(fin),
        )
        .toList();
  }

  double get facturado =>
      ordenesPeriodo.fold(0.0, (s, o) => s + o.totalFacturable);

  double get manoObra => ordenesPeriodo.fold(0.0, (s, o) => s + o.manoObra);

  double get repuestos => ordenesPeriodo.fold(0.0, (s, o) => s + o.repuestos);

  double get cobrado => _pagos.fold(0.0, (s, p) => s + p.monto);

  /// Saldo que todavía falta cobrar de las órdenes del período.
  double get pendienteDelPeriodo =>
      ordenesPeriodo.fold(0.0, (s, o) => s + o.saldo);

  @override
  void dispose() {
    _ordenes.removeListener(notifyListeners);
    _subPagos?.cancel();
    super.dispose();
  }
}
