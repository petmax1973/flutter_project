import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/group.dart' as app_models;
import '../models/participant.dart';
import '../models/attendance.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('attendance.db');
    return _database!;
  }

  Future<List<String>> getAllLessonDates() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT DISTINCT date FROM attendances');
    return result.map((json) => json['date'] as String).toList();
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    // Abilitiamo il supporto per le foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE groups (
  id $idType,
  name $textType
)
''');

    await db.execute('''
CREATE TABLE participants (
  id $idType,
  group_id $textType,
  first_name $textType,
  last_name $textType,
  FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE CASCADE
)
''');

    await db.execute('''
CREATE TABLE attendances (
  id $idType,
  participant_id $textType,
  date $textType,
  is_present $boolType,
  FOREIGN KEY (participant_id) REFERENCES participants (id) ON DELETE CASCADE
)
''');
  }

  // --- Group Methods ---
  Future<void> insertGroup(app_models.Group group) async {
    final db = await instance.database;
    await db.insert('groups', group.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<app_models.Group>> getGroups() async {
    final db = await instance.database;
    final result = await db.query('groups', orderBy: 'name ASC');
    return result.map((json) => app_models.Group.fromMap(json)).toList();
  }

  // --- Participant Methods ---
  Future<void> insertParticipant(Participant participant) async {
    final db = await instance.database;
    await db.insert('participants', participant.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Participant>> getParticipantsForGroup(String groupId) async {
    final db = await instance.database;
    final result = await db.query(
      'participants',
      where: 'group_id = ?',
      whereArgs: [groupId],
      orderBy: 'last_name ASC, first_name ASC',
    );
    return result.map((json) => Participant.fromMap(json)).toList();
  }

  Future<void> updateParticipant(Participant participant) async {
    final db = await instance.database;
    await db.update(
      'participants',
      participant.toMap(),
      where: 'id = ?',
      whereArgs: [participant.id],
    );
  }

  Future<void> deleteParticipant(String participantId) async {
    final db = await instance.database;
    await db.delete(
      'participants',
      where: 'id = ?',
      whereArgs: [participantId],
    );
  }

  // --- Attendance Methods ---
  Future<void> setAttendance(Attendance attendance) async {
    final db = await instance.database;
    // Check if exists for participant + date
    final existing = await db.query(
      'attendances',
      where: 'participant_id = ? AND date = ?',
      whereArgs: [attendance.participantId, attendance.date],
    );

    if (existing.isNotEmpty) {
      await db.update(
        'attendances',
        attendance.toMap(),
        where: 'participant_id = ? AND date = ?',
        whereArgs: [attendance.participantId, attendance.date],
      );
    } else {
      await db.insert('attendances', attendance.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Attendance>> getAttendancesForParticipant(String participantId) async {
    final db = await instance.database;
    final result = await db.query(
      'attendances',
      where: 'participant_id = ?',
      whereArgs: [participantId],
      orderBy: 'date DESC',
    );
    return result.map((json) => Attendance.fromMap(json)).toList();
  }

  Future<List<Attendance>> getAttendancesForGroupAndDate(String groupId, String date) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT a.* FROM attendances a
      JOIN participants p ON a.participant_id = p.id
      WHERE p.group_id = ? AND a.date = ?
    ''', [groupId, date]);
    return result.map((json) => Attendance.fromMap(json)).toList();
  }

  Future<List<Map<String, dynamic>>> getParticipantAttendanceHistory(String participantId, String groupId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT dates.date, COALESCE(a.is_present, 0) as is_present
      FROM (
        SELECT DISTINCT att.date
        FROM attendances att
        JOIN participants p2 ON att.participant_id = p2.id
        WHERE p2.group_id = ?
      ) dates
      LEFT JOIN attendances a 
        ON a.date = dates.date AND a.participant_id = ?
      ORDER BY dates.date DESC
    ''', [groupId, participantId]);
    return result;
  }
}
