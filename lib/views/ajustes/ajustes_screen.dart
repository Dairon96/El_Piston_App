import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/demo_data.dart';
import '../../viewmodels/tema_viewmodel.dart';
import '../widgets/ui_helpers.dart';

/// Apariencia (claro / oscuro) y carga de datos de ejemplo.
class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key, required this.tema, required this.db});

  final TemaViewModel tema;
  final AppDatabase db;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: PaginaCentrada(
        maxAncho: 640,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SeccionTitulo('Apariencia'),
            ListenableBuilder(
              listenable: tema,
              builder: (context, _) => SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: Icon(Icons.brightness_auto),
                    label: Text('Sistema'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: Icon(Icons.light_mode_outlined),
                    label: Text('Claro'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: Icon(Icons.dark_mode_outlined),
                    label: Text('Oscuro'),
                  ),
                ],
                selected: {tema.modo},
                onSelectionChanged: (s) => tema.cambiar(s.first),
              ),
            ),
            const SeccionTitulo('Datos'),
            Card(
              child: ListTile(
                leading: const Icon(Icons.science_outlined),
                title: const Text('Cargar datos de ejemplo'),
                subtitle: const Text(
                  'Agrega clientes, vehículos, repuestos y órdenes de muestra. '
                  'Solo funciona si todavía no hay clientes registrados.',
                ),
                onTap: () async {
                  final ok = await confirmar(
                    context,
                    titulo: 'Cargar datos de ejemplo',
                    mensaje:
                        'Se agregarán datos ficticios para probar la aplicación.',
                    accion: 'Cargar',
                  );
                  if (!ok || !context.mounted) return;
                  await ejecutar(
                    context,
                    () => cargarDatosDemo(db),
                    exito: 'Datos de ejemplo cargados',
                  );
                },
              ),
            ),
            const SeccionTitulo('Acerca de'),
            const Card(
              child: ListTile(
                leading: Icon(Icons.build_circle_outlined),
                title: Text('El Pistón · Gestión del taller'),
                subtitle: Text(
                  'Los datos se guardan en este teléfono y la aplicación '
                  'funciona sin conexión a internet.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
