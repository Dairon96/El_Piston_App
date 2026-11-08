/// Error de regla de negocio: el mensaje está pensado para mostrarse
/// directamente al usuario (por ejemplo en un SnackBar).
class ReglaNegocio implements Exception {
  const ReglaNegocio(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}
