import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/app_database.dart';
import '../data/daos/clientes_dao.dart';
import '../data/daos/ordenes_dao.dart';
import '../models/orden_resumen.dart';

/// Un vehículo con su dueño y su historial de servicios.
class VehiculoDetalleViewModel extends ChangeNotifier {
  VehiculoDetalleViewModel(
    ClientesDao clientesDao,
    OrdenesDao ordenesDao,
    this.vehiculoId,
  ) {
    _subs.add(
      clientesDao.watchVehiculo(vehiculoId).listen((v) {
        _vehiculo = v;
        _cargando = false;
        notifyListeners();
        if (v != null && _clienteId != v.clienteId) {
          _clienteId = v.clienteId;
          _subs.add(
            clientesDao.watchCliente(v.clienteId).listen((c) {
              _cliente = c;
              notifyListeners();
            }),
          );
        }
      }),
    );
    _subs.add(
      ordenesDao.watchResumenes(vehiculoId: vehiculoId).listen((l) {
        _historial = l;
        notifyListeners();
      }),
    );
  }

  final int vehiculoId;
  final List<StreamSubscription<dynamic>> _subs = [];

  int? _clienteId;
  Vehiculo? _vehiculo;
  Cliente? _cliente;
  List<OrdenResumen> _historial = const [];
  bool _cargando = true;

  bool get cargando => _cargando;
  Vehiculo? get vehiculo => _vehiculo;
  Cliente? get cliente => _cliente;
  List<OrdenResumen> get historial => _historial;

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }
}
