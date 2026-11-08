import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Modo claro / oscuro / del sistema, recordado entre sesiones.
class TemaViewModel extends ChangeNotifier {
  TemaViewModel(this._prefs) : _modo = _leer(_prefs);

  static const _clave = 'theme_mode';

  final SharedPreferences _prefs;
  ThemeMode _modo;

  ThemeMode get modo => _modo;

  static ThemeMode _leer(SharedPreferences prefs) {
    switch (prefs.getString(_clave)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> cambiar(ThemeMode nuevo) async {
    _modo = nuevo;
    notifyListeners();
    await _prefs.setString(_clave, nuevo.name);
  }
}
