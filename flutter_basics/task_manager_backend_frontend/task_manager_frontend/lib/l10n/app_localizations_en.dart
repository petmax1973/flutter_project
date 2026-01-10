// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Task Manager';

  @override
  String get tasks => 'Tasks';

  @override
  String get noTasks => 'No tasks found';

  @override
  String get search => 'Search tasks...';

  @override
  String get filterStatus => 'Filter by status';

  @override
  String get clearAll => 'Clear All';

  @override
  String get addTask => 'Add Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get taskDetails => 'Task Details';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get assignedTo => 'Assigned To';

  @override
  String get status => 'Status';

  @override
  String get priority => 'Priority';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteWarning => 'Are you sure you want to delete this task?';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusSuspended => 'Suspended';

  @override
  String get statusToRelease => 'To Release';

  @override
  String get statusCompleted => 'Completed';
}
