import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/fattura.dart';

class PdfGenerator {
  static Future<void> printFattura(Fattura fattura) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Fattura Elettronica',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                  pw.Text(
                    'Documento di Cortesia',
                    style: const pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 32),

            // Mittente and Destinatario
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Mittente (Cedente)',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        fattura.cedente,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 40),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Destinatario (Cessionario)',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        fattura.cessionario,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 36),

            // Info row
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _buildDocData('Data Documento', fattura.data),
                  _buildDocData('Numero', fattura.numero),
                  _buildDocData(
                    'Totale Documento',
                    'EUR ${fattura.importoTotale.toStringAsFixed(2)}',
                    isHighlight: true,
                  ),
                ],
              ),
            ),

            if (fattura.causale.isNotEmpty) ...[
              pw.SizedBox(height: 24),
              pw.Text(
                'Causale:',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(fattura.causale),
            ],

            pw.SizedBox(height: 40),
            pw.Text(
              'Dettaglio Beni e Servizi',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),

            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blueGrey800,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              data: [
                ['Descrizione', 'Prezzo Unit.', 'Totale'],
                ...fattura.righe.map(
                  (r) => [
                    r.descrizione,
                    'EUR ${r.prezzoUnitario.toStringAsFixed(2)}',
                    'EUR ${r.prezzoTotale.toStringAsFixed(2)}',
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 48),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generato automaticamente dall'App Lettore FatturaPA",
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ),
          ];
        },
      ),
    );

    // Call printing module
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name:
          'Fattura_${fattura.numero.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}',
    );
  }

  static pw.Widget _buildDocData(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
            fontSize: 10,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: isHighlight ? 16 : 14,
            color: isHighlight ? PdfColors.green800 : PdfColors.black,
          ),
        ),
      ],
    );
  }
}
