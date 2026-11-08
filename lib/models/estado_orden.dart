/// Estados por los que pasa una orden de servicio.
///
/// Se guarda en la base de datos como el índice del enum (intEnum de Drift),
/// por eso NO se debe cambiar el orden de los valores existentes.
enum EstadoOrden {
  recibida('Recibida'),
  enDiagnostico('En diagnóstico'),
  enReparacion('En reparación'),
  listaParaEntregar('Lista para entregar'),
  entregada('Entregada'),
  cancelada('Cancelada');

  const EstadoOrden(this.etiqueta);

  final String etiqueta;

  /// Una orden está "abierta" mientras el taller todavía tiene trabajo con ella.
  bool get abierta =>
      this != EstadoOrden.entregada && this != EstadoOrden.cancelada;

  /// Siguiente paso natural del flujo (null si ya no hay más pasos).
  EstadoOrden? get siguiente => switch (this) {
        EstadoOrden.recibida => EstadoOrden.enDiagnostico,
        EstadoOrden.enDiagnostico => EstadoOrden.enReparacion,
        EstadoOrden.enReparacion => EstadoOrden.listaParaEntregar,
        EstadoOrden.listaParaEntregar => EstadoOrden.entregada,
        EstadoOrden.entregada => null,
        EstadoOrden.cancelada => null,
      };

  /// Estados que se consideran "abiertos", en orden de flujo.
  static const List<EstadoOrden> abiertos = [
    EstadoOrden.recibida,
    EstadoOrden.enDiagnostico,
    EstadoOrden.enReparacion,
    EstadoOrden.listaParaEntregar,
  ];
}
