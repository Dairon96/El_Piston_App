import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/app_database.dart';
import '../data/daos/clientes_dao.dart';
import '../data/daos/ordenes_dao.dart';
import '../models/orden_resumen.dart';

/// Un cliente con sus vehículos, su historial de servicios y su deuda.
class ClienteDetalleViewModel extends ChangeNotifier {
  ClienteDetalleViewModel(
    ClientesDao clientesDao,
    OrdenesDao ordenesDao,
    this.clienteId,
  ) {
    _subs.add(
      clientesDao.watchCliente(clienteId).listen((c) {
        _cliente = c;
        _cargando = false;
        notifyListeners();
      }),
    );
    _subs.add(
      clientesDao.watchVehiculosDe(clienteId).listen((l) {
        _vehiculos = l;
        notifyListeners();
      }),
    );
    _subs.add(
      ordenesDao.watchResumenes(clienteId: clienteId).listen((l) {
        _historial = l;
        notifyListeners();
      }),
    );
  }

  final int clienteId;
  final List<StreamSubscription<dynamic>> _subs = [];

  Cliente? _cliente;
  List<Vehiculo> _vehiculos = const [];
  List<OrdenResumen> _historial = const [];
  bool _cargando = true;

  bool get cargando => _cargando;
  Cliente? get cliente => _cliente;
  List<Vehiculo> get vehiculos => _vehiculos;
  List<OrdenResumen> get historial => _historial;

  /// Lo que este cliente le debe al taller.
  double get deuda => _historial.fold(0.0, (suma, o) => suma + o.saldo);

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }
}
