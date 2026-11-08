import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../viewmodels/inventario_viewmodel.dart';

/// Estructura principal: barra de navegación inferior en teléfonos y riel
/// lateral en pantallas anchas (tablet / horizontal). Cada pestaña conserva
/// su propia pila de navegación (StatefulShellRoute).
class HomeShell extends StatelessWidget {
  const HomeShell({
    super.key,
    required this.shell,
    required this.inventario,
  });

  final StatefulNavigationShell shell;
  final InventarioViewModel inventario;

  static const _destinos = <({IconData icono, IconData activo, String texto})>[
    (icono: Icons.dashboard_outlined, activo: Icons.dashboard, texto: 'Inicio'),
    (
      icono: Icons.assignment_outlined,
      activo: Icons.assignment,
      texto: 'Órdenes'
    ),
    (icono: Icons.people_outline, activo: Icons.people, texto: 'Clientes'),
    (
      icono: Icons.inventory_2_outlined,
      activo: Icons.inventory_2,
      texto: 'Inventario'
    ),
    (icono: Icons.bar_chart_outlined, activo: Icons.bar_chart, texto: 'Reportes'),
  ];

  /// Icono con una insignia roja si es la pestaña de inventario y hay
  /// repuestos por agotarse.
  Widget _icono(int indice, IconData icono, int alertas) {
    if (indice == 3 && alertas > 0) {
      return Badge(label: Text('$alertas'), child: Icon(icono));
    }
    return Icon(icono);
  }

  void _ir(int indice) {
    shell.goBranch(indice, initialLocation: indice == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: inventario,
      builder: (context, _) {
        final alertas = inventario.bajoStock.length;
        final ancho = MediaQuery.sizeOf(context).width;

        if (ancho >= 600) {
          final extendido = ancho >= 840;
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: shell.currentIndex,
                  onDestinationSelected: _ir,
                  extended: extendido,
                  labelType: extendido
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Icon(
                      Icons.build_circle,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  destinations: [
                    for (var i = 0; i < _destinos.length; i++)
                      NavigationRailDestination(
                        icon: _icono(i, _destinos[i].icono, alertas),
                        selectedIcon: _icono(i, _destinos[i].activo, alertas),
                        label: Text(_destinos[i].texto),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: shell),
              ],
            ),
          );
        }

        return Scaffold(
          body: shell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: _ir,
            destinations: [
              for (var i = 0; i < _destinos.length; i++)
                NavigationDestination(
                  icon: _icono(i, _destinos[i].icono, alertas),
                  selectedIcon: _icono(i, _destinos[i].activo, alertas),
                  label: _destinos[i].texto,
                ),
            ],
          ),
        );
      },
    );
  }
}
