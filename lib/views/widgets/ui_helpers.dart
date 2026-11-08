import 'package:flutter/material.dart';

import '../../core/errors.dart';

/// Decoración común de todos los campos de formulario.
InputDecoration decoracion(
    String etiqueta, {
      IconData? icono,
      String? ayuda,
      String? prefijo,
      String? sufijo,
    }) {
  return InputDecoration(
    labelText: etiqueta,
    helperText: ayuda,
    prefixIcon: icono == null ? null : Icon(icono),
    prefixText: prefijo,
    suffixText: sufijo,
    border: const OutlineInputBorder(),
  );
}

/// Centra el contenido y limita su ancho: en tablets o en horizontal las
/// listas no se estiran de borde a borde.
class PaginaCentrada extends StatelessWidget {
  const PaginaCentrada({super.key, required this.child, this.maxAncho = 900});

  final Widget child;
  final double maxAncho;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxAncho),
        child: child,
      ),
    );
  }
}

/// Pantalla / zona sin contenido, con un mensaje amable.
class EstadoVacio extends StatelessWidget {
  const EstadoVacio({
    super.key,
    required this.icono,
    required this.titulo,
    this.mensaje,
  });

  final IconData icono;
  final String titulo;
  final String? mensaje;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 56, color: tema.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              titulo,
              style: tema.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (mensaje != null) ...[
              const SizedBox(height: 6),
              Text(
                mensaje!,
                style: tema.textTheme.bodyMedium?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Título de sección con una acción opcional a la derecha.
class SeccionTitulo extends StatelessWidget {
  const SeccionTitulo(this.texto, {super.key, this.accion});

  final String texto;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              texto,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (accion != null) accion!,
        ],
      ),
    );
  }
}

/// Tarjeta con un número grande (indicador del panel de inicio).
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icono,
    required this.valor,
    required this.etiqueta,
    this.onTap,
    this.alerta = false,
  });

  final IconData icono;
  final String valor;
  final String etiqueta;
  final VoidCallback? onTap;

  /// Si es true se pinta como advertencia (por ejemplo "stock bajo").
  final bool alerta;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final fondo = alerta ? esquema.errorContainer : esquema.surfaceContainerHighest;
    final texto = alerta ? esquema.onErrorContainer : esquema.onSurface;

    return Card(
      margin: EdgeInsets.zero,
      color: fondo,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icono, size: 26, color: texto),
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  valor,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                etiqueta,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: texto,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ejecutar acciones mostrando los errores de negocio al usuario
// ---------------------------------------------------------------------------

/// Ejecuta [accion]. Si lanza una [ReglaNegocio] muestra su mensaje en un
/// SnackBar. Devuelve true si todo salió bien.
Future<bool> ejecutar(
    BuildContext context,
    Future<void> Function() accion, {
      String? exito,
    }) async {
  final resultado = await ejecutarConValor<bool>(
    context,
        () async {
      await accion();
      return true;
    },
    exito: exito,
  );
  return resultado ?? false;
}

/// Igual que [ejecutar], pero devuelve el valor de la acción (o null si falló).
Future<T?> ejecutarConValor<T>(
    BuildContext context,
    Future<T> Function() accion, {
      String? exito,
    }) async {
  final mensajero = ScaffoldMessenger.of(context);
  final colorError = Theme.of(context).colorScheme.error;
  try {
    final valor = await accion();
    if (exito != null) {
      mensajero.showSnackBar(SnackBar(content: Text(exito)));
    }
    return valor;
  } on ReglaNegocio catch (e) {
    mensajero.showSnackBar(
      SnackBar(content: Text(e.mensaje), backgroundColor: colorError),
    );
  } catch (e) {
    mensajero.showSnackBar(
      SnackBar(
        content: Text('Ocurrió un error inesperado: $e'),
        backgroundColor: colorError,
      ),
    );
  }
  return null;
}

/// Pide confirmación antes de una acción delicada.
Future<bool> confirmar(
    BuildContext context, {
      required String titulo,
      required String mensaje,
      String accion = 'Confirmar',
      bool destructiva = false,
    }) async {
  final esquema = Theme.of(context).colorScheme;
  final respuesta = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: destructiva
              ? FilledButton.styleFrom(
            backgroundColor: esquema.error,
            foregroundColor: esquema.onError,
          )
              : null,
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(accion),
        ),
      ],
    ),
  );
  return respuesta ?? false;
}

// ---------------------------------------------------------------------------
// Selector con búsqueda (bottom sheet) para campos de formulario
// ---------------------------------------------------------------------------

/// Muestra una lista (con buscador) y devuelve el elemento elegido.
Future<T?> elegirDeLista<T>(
    BuildContext context, {
      required String titulo,
      required List<T> items,
      required String Function(T) etiqueta,
      String Function(T)? detalle,
      T? seleccionado,
      bool buscable = true,
    }) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => _HojaSelector<T>(
      titulo: titulo,
      items: items,
      etiqueta: etiqueta,
      detalle: detalle,
      seleccionado: seleccionado,
      buscable: buscable,
    ),
  );
}

class _HojaSelector<T> extends StatefulWidget {
  const _HojaSelector({
    required this.titulo,
    required this.items,
    required this.etiqueta,
    required this.detalle,
    required this.seleccionado,
    required this.buscable,
  });

  final String titulo;
  final List<T> items;
  final String Function(T) etiqueta;
  final String Function(T)? detalle;
  final T? seleccionado;
  final bool buscable;

  @override
  State<_HojaSelector<T>> createState() => _HojaSelectorState<T>();
}

class _HojaSelectorState<T> extends State<_HojaSelector<T>> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final filtrados = widget.items.where((i) {
      if (_q.isEmpty) return true;
      final texto =
      '${widget.etiqueta(i)} ${widget.detalle?.call(i) ?? ''}'.toLowerCase();
      return texto.contains(_q.toLowerCase());
    }).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.titulo,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Cerrar',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            if (widget.buscable)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  autofocus: false,
                  decoration: decoracion('Buscar', icono: Icons.search),
                  onChanged: (v) => setState(() => _q = v),
                ),
              ),
            Expanded(
              child: filtrados.isEmpty
                  ? const EstadoVacio(
                icono: Icons.search_off,
                titulo: 'Sin resultados',
              )
                  : ListView.builder(
                itemCount: filtrados.length,
                itemBuilder: (context, i) {
                  final item = filtrados[i];
                  final elegido = item == widget.seleccionado;
                  return ListTile(
                    title: Text(widget.etiqueta(item)),
                    subtitle: widget.detalle == null
                        ? null
                        : Text(widget.detalle!(item)),
                    trailing: elegido ? const Icon(Icons.check) : null,
                    selected: elegido,
                    onTap: () => Navigator.of(context).pop(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Campo de formulario que se ve como un TextField pero abre un selector.
class CampoSelector extends StatelessWidget {
  const CampoSelector({
    super.key,
    required this.etiqueta,
    required this.icono,
    required this.valor,
    required this.onTap,
    this.ayuda,
    this.mensajeRequerido,
  });

  final String etiqueta;
  final IconData icono;
  final String? valor;
  final VoidCallback onTap;
  final String? ayuda;

  /// Si no es null, el campo es obligatorio y este es el mensaje de error.
  final String? mensajeRequerido;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      // Al cambiar el valor se crea un campo nuevo: así el error "Selecciona…"
      // desaparece en cuanto el usuario elige algo.
      key: ValueKey(valor),
      validator: (_) => (mensajeRequerido != null && valor == null)
          ? mensajeRequerido
          : null,
      builder: (estado) {
        return InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onTap,
          child: InputDecorator(
            isEmpty: valor == null,
            decoration: decoracion(etiqueta, icono: icono, ayuda: ayuda)
                .copyWith(
              errorText: estado.errorText,
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            child: Text(valor ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        );
      },
    );
  }
}