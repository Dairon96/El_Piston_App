import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/dependencies.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(ElPistonApp(dependencias: AppDependencies(prefs)));
}

class ElPistonApp extends StatefulWidget {
  const ElPistonApp({super.key, required this.dependencias});

  final AppDependencies dependencias;

  @override
  State<ElPistonApp> createState() => _ElPistonAppState();
}

class _ElPistonAppState extends State<ElPistonApp> {
  // El router se crea una sola vez: si se creara en build, cada cambio de
  // tema reiniciaría la navegación.
  late final GoRouter _router = crearRouter(widget.dependencias);

  @override
  void dispose() {
    _router.dispose();
    widget.dependencias.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.dependencias.tema,
      builder: (context, _) => MaterialApp.router(
        title: 'El Pistón',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: widget.dependencias.tema.modo,
        routerConfig: _router,
        locale: const Locale('es'),
        supportedLocales: const [Locale('es'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
