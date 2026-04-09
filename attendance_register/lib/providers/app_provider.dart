import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/group.dart' as app_models;
import '../models/participant.dart';
import '../models/attendance.dart';
import '../services/database_helper.dart';
import 'package:intl/intl.dart';

class AppProvider with ChangeNotifier {
  List<app_models.Group> groups = [];
  Map<String, List<Participant>> groupParticipants = {};
  Set<String> lessonDates = {};
  
  // Date format yyyy-MM-dd
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  AppProvider() {
    loadGroups();
    loadLessonDates();
  }

  Future<void> loadLessonDates() async {
    final dates = await DatabaseHelper.instance.getAllLessonDates();
    lessonDates = dates.toSet();
    notifyListeners();
  }

  Future<void> loadGroups() async {
    groups = await DatabaseHelper.instance.getGroups();
    notifyListeners();
  }

  Future<void> addGroup(String name) async {
    final group = app_models.Group(id: const Uuid().v4(), name: name);
    await DatabaseHelper.instance.insertGroup(group);
    await loadGroups();
  }

  Future<void> loadParticipants(String groupId) async {
    final participants = await DatabaseHelper.instance.getParticipantsForGroup(groupId);
    groupParticipants[groupId] = participants;
    notifyListeners();
  }

  Future<void> addParticipant(String groupId, String firstName, String lastName) async {
    final participant = Participant(
      id: const Uuid().v4(),
      groupId: groupId,
      firstName: firstName,
      lastName: lastName,
    );
    await DatabaseHelper.instance.insertParticipant(participant);
    await loadParticipants(groupId);
  }

  Future<void> updateParticipant(Participant participant) async {
    await DatabaseHelper.instance.updateParticipant(participant);
    await loadParticipants(participant.groupId);
  }

  Future<void> deleteParticipant(String participantId, String groupId) async {
    await DatabaseHelper.instance.deleteParticipant(participantId);
    await loadParticipants(groupId);
  }

  Future<List<Attendance>> getAttendancesForParticipant(String participantId) async {
    return await DatabaseHelper.instance.getAttendancesForParticipant(participantId);
  }

  Future<List<Attendance>> getAttendancesForGroupAndDate(String groupId, DateTime date) async {
    final dateString = _dateFormat.format(date);
    return await DatabaseHelper.instance.getAttendancesForGroupAndDate(groupId, dateString);
  }

  Future<List<Map<String, dynamic>>> getParticipantAttendanceHistory(Participant p) async {
    return await DatabaseHelper.instance.getParticipantAttendanceHistory(p.id, p.groupId);
  }

  Future<void> toggleAttendance(String participantId, DateTime date, bool isPresent) async {
    final dateString = _dateFormat.format(date);
    final attendance = Attendance(
      id: const Uuid().v4(),
      participantId: participantId,
      date: dateString,
      isPresent: isPresent,
    );
    await DatabaseHelper.instance.setAttendance(attendance);
    await loadLessonDates();
    notifyListeners();
  }
}
