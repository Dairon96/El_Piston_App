import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/daos/ordenes_dao.dart';
import '../models/deuda_cliente.dart';
import '../models/estado_orden.dart';
import '../models/orden_resumen.dart';

/// Estado compartido de todas las órdenes. Escucha un Stream de Drift: cada
/// vez que cambia algo en la base (una orden, un trabajo, un pago…) la lista
/// llega sola y las pantallas se redibujan.
class OrdenesViewModel extends ChangeNotifier {
  OrdenesViewModel(this._dao) {
    _sub = _dao.watchResumenes().listen(
      (lista) {
        _todas = lista;
        _cargando = false;
        _error = null;
        notifyListeners();
      },
      onError: (Object e) {
        _cargando = false;
        _error = 'No se pudieron leer las órdenes: $e';
        notifyListeners();
      },
    );
  }

  final OrdenesDao _dao;
  StreamSubscription<List<OrdenResumen>>? _sub;

  List<OrdenResumen> _todas = const [];
  bool _cargando = true;
  String? _error;

  // Filtros de la pantalla de órdenes.
  EstadoOrden? _estadoFiltro;
  bool _verTodas = false;
  String _busqueda = '';

  bool get cargando => _cargando;
  String? get error => _error;
  List<OrdenResumen> get todas => _todas;
  String get busqueda => _busqueda;

  // ----------------------------------------------------------------- Filtros

  bool get filtroAbiertas => _estadoFiltro == null && !_verTodas;
  bool get filtroTodas => _estadoFiltro == null && _verTodas;
  EstadoOrden? get estadoFiltro => _estadoFiltro;

  void filtrarAbiertas() {
    _estadoFiltro = null;
    _verTodas = false;
    notifyListeners();
  }

  void filtrarTodas() {
    _estadoFiltro = null;
    _verTodas = true;
    notifyListeners();
  }

  void filtrarEstado(EstadoOrden estado) {
    _estadoFiltro = estado;
    _verTodas = false;
    notifyListeners();
  }

  void setBusqueda(String texto) {
    _busqueda = texto;
    notifyListeners();
  }

  /// Órdenes que se muestran en la lista según filtro y búsqueda.
  List<OrdenResumen> get visibles {
    Iterable<OrdenResumen> lista = _todas.where((o) {
      if (_estadoFiltro != null) return o.estado == _estadoFiltro;
      return _verTodas || o.abierta;
    });

    final q = _busqueda.trim().toLowerCase();
    if (q.isNotEmpty) {
      lista = lista.where(
        (o) =>
            o.matricula.toLowerCase().contains(q) ||
            o.clienteNombre.toLowerCase().contains(q) ||
            o.marca.toLowerCase().contains(q) ||
            o.modelo.toLowerCase().contains(q) ||
            o.problema.toLowerCase().contains(q) ||
            o.mecanicoNombre.toLowerCase().contains(q) ||
            '${o.id}' == q.replaceAll('#', ''),
      );
    }
    return lista.toList();
  }

  // ---------------------------------------------------- Lo que necesita el dueño

  /// Qué órdenes están abiertas (y en qué estado está cada una).
  List<OrdenResumen> get abiertas => _todas.where((o) => o.abierta).toList();

  int contar(EstadoOrden estado) =>
      _todas.where((o) => o.estado == estado).length;

  /// Cuánto trabajo tiene asignado cada mecánico (órdenes abiertas).
  Map<int, int> get abiertasPorMecanico {
    final mapa = <int, int>{};
    for (final o in _todas) {
      if (o.abierta) mapa[o.mecanicoId] = (mapa[o.mecanicoId] ?? 0) + 1;
    }
    return mapa;
  }

  /// Total que los clientes le deben al taller.
  double get totalPorCobrar => _todas.fold(0.0, (suma, o) => suma + o.saldo);

  /// Cuánto debe cada cliente con saldo pendiente (de mayor a menor).
  List<DeudaCliente> get deudas {
    final saldos = <int, double>{};
    final cuenta = <int, int>{};
    final nombres = <int, String>{};
    final telefonos = <int, String>{};

    for (final o in _todas) {
      if (o.saldo <= 0) continue;
      saldos[o.clienteId] = (saldos[o.clienteId] ?? 0) + o.saldo;
      cuenta[o.clienteId] = (cuenta[o.clienteId] ?? 0) + 1;
      nombres[o.clienteId] = o.clienteNombre;
      telefonos[o.clienteId] = o.clienteTelefono;
    }

    final lista = saldos.entries
        .map(
          (e) => DeudaCliente(
            clienteId: e.key,
            nombre: nombres[e.key]!,
            telefono: telefonos[e.key]!,
            saldo: e.value,
            ordenes: cuenta[e.key]!,
          ),
        )
        .toList();
    lista.sort((a, b) => b.saldo.compareTo(a.saldo));
    return lista;
  }

  // ----------------------------------------------------------------- Acciones

  Future<int> crearOrden({
    required int vehiculoId,
    required int mecanicoId,
    required String problema,
    required int kilometraje,
  }) {
    return _dao.crearOrden(
      vehiculoId: vehiculoId,
      mecanicoId: mecanicoId,
      problema: problema.trim(),
      kilometraje: kilometraje,
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
