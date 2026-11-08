import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../viewmodels/ordenes_viewmodel.dart';
import '../../viewmodels/reportes_viewmodel.dart';
import '../widgets/orden_tile.dart';
import '../widgets/ui_helpers.dart';

/// Facturación por período y deudas de los clientes.
class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key, required this.vm, required this.ordenes});

  final ReportesViewModel vm;
  final OrdenesViewModel ordenes;

  Future<void> _elegirRango(BuildContext context) async {
    final ahora = DateTime.now();
    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(ahora.year + 1, 12, 31),
      initialDateRange: DateTimeRange(start: vm.desde, end: vm.hasta),
      helpText: 'Elegir período',
      saveText: 'Aplicar',
    );
    if (rango != null) vm.seleccionarRango(rango.start, rango.end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      body: ListenableBuilder(
        listenable: Listenable.merge([vm, ordenes]),
        builder: (context, _) {
          final tema = Theme.of(context);
          final deudas = ordenes.deudas;
          final enPeriodo = vm.ordenesPeriodo;

          return PaginaCentrada(
            maxAncho: 760,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              children: [
                // ------------------------------------------------- Período
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final p in [
                      PeriodoRapido.hoy,
                      PeriodoRapido.semana,
                      PeriodoRapido.mes,
                    ])
                      ChoiceChip(
                        label: Text(p.etiqueta),
                        selected: vm.periodo == p,
                        onSelected: (_) => vm.seleccionarRapido(p),
                      ),
                    ChoiceChip(
                      avatar: const Icon(Icons.date_range, size: 18),
                      label: const Text('Elegir fechas'),
                      selected: vm.periodo == PeriodoRapido.personalizado,
                      onSelected: (_) => _elegirRango(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  vm.desde == vm.hasta
                      ? fmtFecha(vm.desde)
                      : '${fmtFecha(vm.desde)}  →  ${fmtFecha(vm.hasta)}',
                  style: tema.textTheme.bodyMedium?.copyWith(
                    color: tema.colorScheme.onSurfaceVariant,
                  ),
                ),

                // ------------------------------------------- Facturación
                const SeccionTitulo('Facturación del período'),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icono: Icons.receipt_long_outlined,
                        valor: fmtMonto(vm.facturado),
                        etiqueta: 'Facturado',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        icono: Icons.payments_outlined,
                        valor: fmtMonto(vm.cobrado),
                        etiqueta: 'Cobrado',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _linea(context, 'Mano de obra', fmtMonto(vm.manoObra)),
                        _linea(context, 'Repuestos', fmtMonto(vm.repuestos)),
                        _linea(
                          context,
                          'Órdenes del período',
                          '${enPeriodo.length}',
                        ),
                        _linea(
                          context,
                          'Falta cobrar de esas órdenes',
                          fmtMonto(vm.pendienteDelPeriodo),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                  child: Text(
                    'Facturado: total de las órdenes recibidas en el período '
                    '(sin canceladas). Cobrado: pagos recibidos en el período.',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                // ------------------------------------------- Deudas
                SeccionTitulo('Clientes con saldo pendiente (${deudas.length})'),
                if (deudas.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Ningún cliente debe dinero. ¡Todo cobrado!'),
                    ),
                  )
                else ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 4),
                    child: Text(
                      'Total por cobrar: ${fmtMonto(ordenes.totalPorCobrar)}',
                      style: tema.textTheme.titleSmall?.copyWith(
                        color: tema.colorScheme.error,
                      ),
                    ),
                  ),
                  for (final d in deudas)
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text(d.nombre),
                        subtitle: Text(
                          '${d.telefono} · ${d.ordenes} ${d.ordenes == 1 ? 'orden' : 'órdenes'}',
                        ),
                        trailing: Text(
                          fmtMonto(d.saldo),
                          style: tema.textTheme.titleMedium?.copyWith(
                            color: tema.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => context.go('/clientes/${d.clienteId}'),
                      ),
                    ),
                ],

                // ------------------------------------------- Órdenes
                if (enPeriodo.isNotEmpty) ...[
                  const SeccionTitulo('Órdenes del período'),
                  for (final o in enPeriodo) OrdenTile(orden: o),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _linea(BuildContext context, String texto, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(texto)),
          Text(valor, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
