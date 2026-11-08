import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/dependencies.dart';
import '../data/app_database.dart';
import '../views/ajustes/ajustes_screen.dart';
import '../views/clientes/cliente_detalle_screen.dart';
import '../views/clientes/cliente_form_screen.dart';
import '../views/clientes/clientes_screen.dart';
import '../views/clientes/vehiculo_detalle_screen.dart';
import '../views/clientes/vehiculo_form_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/home_shell.dart';
import '../views/inventario/inventario_screen.dart';
import '../views/inventario/repuesto_form_screen.dart';
import '../views/mecanicos/mecanicos_screen.dart';
import '../views/ordenes/orden_detalle_screen.dart';
import '../views/ordenes/orden_form_screen.dart';
import '../views/ordenes/ordenes_screen.dart';
import '../views/reportes/reportes_screen.dart';
import '../views/widgets/ui_helpers.dart';

final _raiz = GlobalKey<NavigatorState>(debugLabel: 'raiz');

/// Mapa de navegación de toda la app (GoRouter).
///
///  Barra inferior (5 ramas, cada una conserva su propia pila):
///    /                      Inicio
///    /ordenes               Órdenes        ─ nueva, :id
///    /clientes              Clientes       ─ nuevo, :id, vehiculos/:id …
///    /inventario            Inventario     ─ nuevo, :id/editar
///    /reportes              Reportes
///  Pantallas completas (sobre la barra): formularios, /mecanicos, /ajustes
GoRouter crearRouter(AppDependencies d) {
  int numero(GoRouterState s, String clave) =>
      int.tryParse(s.pathParameters[clave] ?? '') ?? -1;

  return GoRouter(
    navigatorKey: _raiz,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            HomeShell(shell: shell, inventario: d.inventario),
        branches: [
          // ---------------------------------------------------------- Inicio
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => DashboardScreen(
                  ordenes: d.ordenes,
                  inventario: d.inventario,
                  mecanicos: d.mecanicos,
                ),
              ),
            ],
          ),

          // ---------------------------------------------------------- Órdenes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ordenes',
                builder: (context, state) => OrdenesScreen(vm: d.ordenes),
                routes: [
                  // "nueva" va antes de ":id" para que no se confunda con un id.
                  GoRoute(
                    path: 'nueva',
                    parentNavigatorKey: _raiz,
                    builder: (context, state) => OrdenFormScreen(
                      ordenes: d.ordenes,
                      clientes: d.clientes,
                      mecanicos: d.mecanicos,
                      vehiculoIdInicial: int.tryParse(
                        state.uri.queryParameters['vehiculo'] ?? '',
                      ),
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = numero(state, 'id');
                      return OrdenDetalleScreen(
                        key: ValueKey('orden-$id'),
                        db: d.db,
                        ordenId: id,
                        inventario: d.inventario,
                        mecanicos: d.mecanicos,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // --------------------------------------------------------- Clientes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/clientes',
                builder: (context, state) => ClientesScreen(vm: d.clientes),
                routes: [
                  GoRoute(
                    path: 'nuevo',
                    parentNavigatorKey: _raiz,
                    builder: (context, state) =>
                        ClienteFormScreen(vm: d.clientes),
                  ),
                  GoRoute(
                    path: 'vehiculos/:vid',
                    builder: (context, state) {
                      final id = numero(state, 'vid');
                      return VehiculoDetalleScreen(
                        key: ValueKey('vehiculo-$id'),
                        db: d.db,
                        vehiculoId: id,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'editar',
                        parentNavigatorKey: _raiz,
                        builder: (context, state) {
                          final id = numero(state, 'vid');
                          final v = d.clientes.vehiculos
                              .where((x) => x.vehiculo.id == id)
                              .firstOrNull;
                          if (v == null) return const _NoEncontrado();
                          return VehiculoFormScreen(
                            vm: d.clientes,
                            clienteId: v.cliente.id,
                            vehiculo: v.vehiculo,
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = numero(state, 'id');
                      return ClienteDetalleScreen(
                        key: ValueKey('cliente-$id'),
                        db: d.db,
                        clienteId: id,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'editar',
                        parentNavigatorKey: _raiz,
                        builder: (context, state) {
                          final id = numero(state, 'id');
                          final Cliente? c = d.clientes.clientes
                              .where((x) => x.id == id)
                              .firstOrNull;
                          if (c == null) return const _NoEncontrado();
                          return ClienteFormScreen(vm: d.clientes, cliente: c);
                        },
                      ),
                      GoRoute(
                        path: 'vehiculos/nuevo',
                        parentNavigatorKey: _raiz,
                        builder: (context, state) => VehiculoFormScreen(
                          vm: d.clientes,
                          clienteId: numero(state, 'id'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // ------------------------------------------------------- Inventario
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventario',
                builder: (context, state) =>
                    InventarioScreen(vm: d.inventario),
                routes: [
                  GoRoute(
                    path: 'nuevo',
                    parentNavigatorKey: _raiz,
                    builder: (context, state) =>
                        RepuestoFormScreen(vm: d.inventario),
                  ),
                  GoRoute(
                    path: ':id/editar',
                    parentNavigatorKey: _raiz,
                    builder: (context, state) {
                      final id = numero(state, 'id');
                      final Repuesto? r = d.inventario.todos
                          .where((x) => x.id == id)
                          .firstOrNull;
                      if (r == null) return const _NoEncontrado();
                      return RepuestoFormScreen(vm: d.inventario, repuesto: r);
                    },
                  ),
                ],
              ),
            ],
          ),

          // --------------------------------------------------------- Reportes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reportes',
                builder: (context, state) =>
                    ReportesScreen(vm: d.reportes, ordenes: d.ordenes),
              ),
            ],
          ),
        ],
      ),

      // ------------------------------------------- Pantallas fuera de la barra
      GoRoute(
        path: '/mecanicos',
        parentNavigatorKey: _raiz,
        builder: (context, state) =>
            MecanicosScreen(vm: d.mecanicos, ordenes: d.ordenes),
      ),
      GoRoute(
        path: '/ajustes',
        parentNavigatorKey: _raiz,
        builder: (context, state) => AjustesScreen(tema: d.tema, db: d.db),
      ),
    ],
  );
}

class _NoEncontrado extends StatelessWidget {
  const _NoEncontrado();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const EstadoVacio(
        icono: Icons.search_off,
        titulo: 'No se encontró el elemento',
        mensaje: 'Puede que ya no exista.',
      ),
    );
  }
}
