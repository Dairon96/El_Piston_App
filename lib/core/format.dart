/// Utilidades de formato y números compartidas por toda la app.
library;

String _dos(int n) => n.toString().padLeft(2, '0');

/// Redondea a dos decimales para evitar errores de punto flotante en dinero.
double redondear(double valor) => (valor * 100).roundToDouble() / 100;

/// Formatea un monto: 1234.5 -> $1,234.50
String fmtMonto(double valor) {
  final v = redondear(valor);
  final negativo = v < 0;
  final partes = v.abs().toStringAsFixed(2).split('.');
  final entero = partes[0];
  final buffer = StringBuffer();
  for (var i = 0; i < entero.length; i++) {
    if (i > 0 && (entero.length - i) % 3 == 0) buffer.write(',');
    buffer.write(entero[i]);
  }
  final signo = negativo ? '-' : '';
  return '$signo\$${buffer.toString()}.${partes[1]}';
}

/// dd/MM/yyyy
String fmtFecha(DateTime f) => '${_dos(f.day)}/${_dos(f.month)}/${f.year}';

/// dd/MM/yyyy HH:mm
String fmtFechaHora(DateTime f) =>
    '${fmtFecha(f)} ${_dos(f.hour)}:${_dos(f.minute)}';

/// Convierte "12,5" o "12.5" en 12.5 (null si no es un número).
double? leerNumero(String texto) =>
    double.tryParse(texto.trim().replaceAll(',', '.'));

/// Kilometraje: 45200 -> "45,200 km"
String fmtKm(int km) {
  final s = km.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
    buffer.write(s[i]);
  }
  return '$buffer km';
}
