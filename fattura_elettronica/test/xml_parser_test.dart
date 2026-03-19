import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:fattura_elettronica/utils/xml_parser.dart';

void main() {
  test('Parses Fattura Elettronica XML correctly', () {
    final file = File(
      '/Users/massimopettina/Documents/judo/pec/19_03_2026/IT00402150247_0021M.xml',
    );
    final xmlString = file.readAsStringSync();

    final fattura = FatturaXmlParser.parse(xmlString);

    expect(fattura.cedente, 'COMUNE DI SCHIO');
    expect(fattura.cessionario, 'A.S.D. FUJI SAN JUDO SCHIO');
    expect(fattura.numero, '11/SP');
    expect(fattura.data, '2026-03-19');
    expect(fattura.importoTotale, 1471.88);
    expect(fattura.righe.length, 4);
    expect(fattura.righe.first.prezzoTotale, 332.36);
  });
}
