import 'package:xml/xml.dart';
import '../models/fattura.dart';

class FatturaXmlParser {
  static Fattura parse(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);

      final headerNodes = document.findAllElements('FatturaElettronicaHeader');
      if (headerNodes.isEmpty) {
        throw Exception('Formato non valido: manca FatturaElettronicaHeader');
      }
      final header = headerNodes.first;

      final bodyNodes = document.findAllElements('FatturaElettronicaBody');
      if (bodyNodes.isEmpty) {
        throw Exception('Formato non valido: manca FatturaElettronicaBody');
      }
      final body = bodyNodes.first;

      // Cedente
      final cedenteNode = header.findAllElements('CedentePrestatore').first;
      final cedenteDenominazione = _getDenominazione(cedenteNode);

      // Cessionario
      final cessionarioNode = header
          .findAllElements('CessionarioCommittente')
          .first;
      final cessionarioDenominazione = _getDenominazione(cessionarioNode);

      // Dati Generali
      final datiGenerali = body.findAllElements('DatiGeneraliDocumento').first;
      final numero = datiGenerali.findAllElements('Numero').first.innerText;
      final data = datiGenerali.findAllElements('Data').first.innerText;

      final causaleNodes = datiGenerali.findAllElements('Causale');
      final causale = causaleNodes.isNotEmpty
          ? causaleNodes.map((n) => n.innerText).join('\n')
          : '';

      final importoNodes = datiGenerali.findAllElements(
        'ImportoTotaleDocumento',
      );
      final importoTotale = importoNodes.isNotEmpty
          ? double.tryParse(importoNodes.first.innerText) ?? 0.0
          : 0.0;

      // Righe
      final righeNodes = body.findAllElements('DettaglioLinee');
      final List<RigaFattura> righe = [];

      for (var rigaNode in righeNodes) {
        final descNode = rigaNode.findAllElements('Descrizione');
        final pUnitNode = rigaNode.findAllElements('PrezzoUnitario');
        final pTotNode = rigaNode.findAllElements('PrezzoTotale');

        righe.add(
          RigaFattura(
            descrizione: descNode.isNotEmpty ? descNode.first.innerText : '',
            prezzoUnitario: pUnitNode.isNotEmpty
                ? double.tryParse(pUnitNode.first.innerText) ?? 0.0
                : 0.0,
            prezzoTotale: pTotNode.isNotEmpty
                ? double.tryParse(pTotNode.first.innerText) ?? 0.0
                : 0.0,
          ),
        );
      }

      return Fattura(
        cedente: cedenteDenominazione,
        cessionario: cessionarioDenominazione,
        numero: numero,
        data: data,
        causale: causale,
        importoTotale: importoTotale,
        righe: righe,
      );
    } catch (e) {
      throw Exception('Errore di parsing del file XML: $e');
    }
  }

  static String _getDenominazione(XmlElement node) {
    if (node.findAllElements('Denominazione').isNotEmpty) {
      return node.findAllElements('Denominazione').first.innerText;
    } else if (node.findAllElements('Nome').isNotEmpty &&
        node.findAllElements('Cognome').isNotEmpty) {
      return "${node.findAllElements('Nome').first.innerText} ${node.findAllElements('Cognome').first.innerText}";
    }
    return "Sconosciuto";
  }
}
