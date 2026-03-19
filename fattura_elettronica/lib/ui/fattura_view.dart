import 'package:flutter/material.dart';
import '../models/fattura.dart';
import '../utils/pdf_generator.dart';

class FatturaView extends StatelessWidget {
  final Fattura fattura;

  const FatturaView({super.key, required this.fattura});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.blueAccent.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dettaglio Fattura',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: () async {
                        try {
                          await PdfGenerator.printFattura(fattura);
                        } catch (e, stackTrace) {
                          debugPrint('Errore PDF: $e\\n$stackTrace');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Errore generazione PDF: $e', style: const TextStyle(color: Colors.white)),
                                backgroundColor: Colors.red.shade800,
                                duration: const Duration(seconds: 15),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.print),
                      label: const Text('Stampa / Salva PDF'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onTertiary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.receipt_long,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 48, thickness: 2),

            // Mittente and Destinatario details
            Wrap(
              spacing: 32,
              runSpacing: 24,
              children: [
                SizedBox(
                  width: 300,
                  child: _buildInfoSection(
                    context,
                    'Mittente (Cedente)',
                    fattura.cedente,
                    Icons.business,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: _buildInfoSection(
                    context,
                    'Destinatario (Cessionario)',
                    fattura.cessionario,
                    Icons.person,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // General Document Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              child: Wrap(
                spacing: 48,
                runSpacing: 16,
                alignment: WrapAlignment.spaceAround,
                children: [
                  _buildDocData(context, 'Numero', fattura.numero),
                  _buildDocData(context, 'Data', fattura.data),
                  _buildDocData(
                    context,
                    'Totale Documento',
                    '€ ${fattura.importoTotale.toStringAsFixed(2)}',
                    isHighlight: true,
                  ),
                ],
              ),
            ),

            if (fattura.causale.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Causale:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fattura.causale,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 32),

            // Table of Items
            Text(
              'Dettaglio Beni e Servizi',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRigheTable(),

            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Generato automaticamente dal lettore XML FatturaPA',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    String name,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildDocData(
    BuildContext context,
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 22 : 18,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            color: isHighlight
                ? Colors.green.shade700
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildRigheTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
          columns: const [
            DataColumn(
              label: Text(
                'Descrizione',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Prezzo Unit.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                'Totale',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              numeric: true,
            ),
          ],
          rows: fattura.righe
              .map(
                (r) => DataRow(
                  cells: [
                    DataCell(
                      Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Text(
                          r.descrizione,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    DataCell(Text('€ ${r.prezzoUnitario.toStringAsFixed(2)}')),
                    DataCell(
                      Text(
                        '€ ${r.prezzoTotale.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
