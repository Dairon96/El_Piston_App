import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../models/orden_resumen.dart';
import 'estado_chip.dart';

/// Tarjeta resumen de una orden: se usa en el inicio, en la lista de órdenes,
/// en el historial de clientes/vehículos y en los reportes.
class OrdenTile extends StatelessWidget {
  const OrdenTile({super.key, required this.orden});

  final OrdenResumen orden;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final suave = tema.colorScheme.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/ordenes/${orden.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '#${orden.id} · ${orden.matricula}',
                      style: tema.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  EstadoChip(orden.estado),
                ],
              ),
              const SizedBox(height: 4),
              Text('${orden.vehiculo} · ${orden.clienteNombre}'),
              const SizedBox(height: 2),
              Text(
                orden.problema,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tema.textTheme.bodySmall?.copyWith(color: suave),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.engineering_outlined, size: 16, color: suave),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      orden.mecanicoNombre,
                      style: tema.textTheme.bodySmall?.copyWith(color: suave),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (orden.saldo > 0)
                    Text(
                      'Debe ${fmtMonto(orden.saldo)}',
                      style: tema.textTheme.labelLarge?.copyWith(
                        color: tema.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    Text(
                      orden.cancelada ? 'Cancelada' : fmtMonto(orden.total),
                      style: tema.textTheme.labelLarge,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
