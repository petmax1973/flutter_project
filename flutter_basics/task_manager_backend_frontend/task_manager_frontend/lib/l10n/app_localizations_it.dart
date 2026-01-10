// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Gestore Task';

  @override
  String get tasks => 'Task';

  @override
  String get noTasks => 'Nessun task trovato';

  @override
  String get search => 'Cerca task...';

  @override
  String get filterStatus => 'Filtra per stato';

  @override
  String get clearAll => 'Pulisci tutto';

  @override
  String get addTask => 'Aggiungi Task';

  @override
  String get editTask => 'Modifica Task';

  @override
  String get taskDetails => 'Dettagli Task';

  @override
  String get title => 'Titolo';

  @override
  String get description => 'Descrizione';

  @override
  String get assignedTo => 'Assegnato a';

  @override
  String get status => 'Stato';

  @override
  String get priority => 'Priorità';

  @override
  String get save => 'Salva';

  @override
  String get delete => 'Elimina';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirmDelete => 'Conferma eliminazione';

  @override
  String get deleteWarning => 'Sei sicuro di voler eliminare questo task?';

  @override
  String get fieldRequired => 'Questo campo è obbligatorio';

  @override
  String get error => 'Errore';

  @override
  String get loading => 'Caricamento...';

  @override
  String get statusPending => 'In attesa';

  @override
  String get statusInProgress => 'In corso';

  @override
  String get statusSuspended => 'Sospeso';

  @override
  String get statusToRelease => 'Da rilasciare';

  @override
  String get statusCompleted => 'Completato';
}
