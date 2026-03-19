class Fattura {
  final String cedente;
  final String cessionario;
  final String numero;
  final String data;
  final String causale;
  final double importoTotale;
  final List<RigaFattura> righe;

  Fattura({
    required this.cedente,
    required this.cessionario,
    required this.numero,
    required this.data,
    required this.causale,
    required this.importoTotale,
    required this.righe,
  });
}

class RigaFattura {
  final String descrizione;
  final double prezzoUnitario;
  final double prezzoTotale;

  RigaFattura({
    required this.descrizione,
    required this.prezzoUnitario,
    required this.prezzoTotale,
  });
}
