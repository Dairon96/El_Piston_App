import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/app_database.dart';
import '../data/daos/clientes_dao.dart';
import '../models/vehiculo_con_cliente.dart';

/// Clientes y vehículos del taller (lista compartida + altas y cambios).
class ClientesViewModel extends ChangeNotifier {
  ClientesViewModel(this._dao) {
    _subClientes = _dao.watchClientes().listen((l) {
      _clientes = l;
      _cargando = false;
      notifyListeners();
    });
    _subVehiculos = _dao.watchVehiculosConCliente().listen((l) {
      _vehiculos = l;
      notifyListeners();
    });
  }

  final ClientesDao _dao;
  StreamSubscription<List<Cliente>>? _subClientes;
  StreamSubscription<List<VehiculoConCliente>>? _subVehiculos;

  List<Cliente> _clientes = const [];
  List<VehiculoConCliente> _vehiculos = const [];
  bool _cargando = true;
  String _busqueda = '';

  bool get cargando => _cargando;
  List<Cliente> get clientes => _clientes;
  List<VehiculoConCliente> get vehiculos => _vehiculos;
  String get busqueda => _busqueda;

  void setBusqueda(String texto) {
    _busqueda = texto;
    notifyListeners();
  }

  /// Busca por nombre, teléfono o matrícula de alguno de sus vehículos.
  List<Cliente> get visibles {
    final q = _busqueda.trim().toLowerCase();
    if (q.isEmpty) return _clientes;
    return _clientes.where((c) {
      if (c.nombre.toLowerCase().contains(q) || c.telefono.contains(q)) {
        return true;
      }
      return _vehiculos.any(
        (v) =>
            v.cliente.id == c.id && v.vehiculo.matricula.toLowerCase().contains(q),
      );
    }).toList();
  }

  int cantidadVehiculos(int clienteId) =>
      _vehiculos.where((v) => v.cliente.id == clienteId).length;

  Future<int> crearCliente({
    required String nombre,
    required String telefono,
    String? direccion,
  }) {
    return _dao.crearCliente(
      nombre: nombre.trim(),
      telefono: telefono.trim(),
      direccion: _limpiar(direccion),
    );
  }

  Future<void> actualizarCliente(
    int id, {
    required String nombre,
    required String telefono,
    String? direccion,
  }) {
    return _dao.actualizarCliente(
      id,
      nombre: nombre.trim(),
      telefono: telefono.trim(),
      direccion: _limpiar(direccion),
    );
  }

  Future<int> crearVehiculo({
    required int clienteId,
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    required int kilometraje,
  }) {
    return _dao.crearVehiculo(
      clienteId: clienteId,
      matricula: _normalizarMatricula(matricula),
      marca: marca.trim(),
      modelo: modelo.trim(),
      anio: anio,
      kilometraje: kilometraje,
    );
  }

  Future<void> actualizarVehiculo(
    int id, {
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    required int kilometraje,
  }) {
    return _dao.actualizarVehiculo(
      id,
      matricula: _normalizarMatricula(matricula),
      marca: marca.trim(),
      modelo: modelo.trim(),
      anio: anio,
      kilometraje: kilometraje,
    );
  }

  static String _normalizarMatricula(String m) =>
      m.trim().toUpperCase().replaceAll(' ', '');

  static String? _limpiar(String? texto) {
    final t = texto?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  @override
  void dispose() {
    _subClientes?.cancel();
    _subVehiculos?.cancel();
    super.dispose();
  }
}
