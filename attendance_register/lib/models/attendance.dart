class Attendance {
  final String id;
  final String participantId;
  final String date; // Format: YYYY-MM-DD
  final bool isPresent;

  Attendance({
    required this.id,
    required this.participantId,
    required this.date,
    required this.isPresent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participant_id': participantId,
      'date': date,
      'is_present': isPresent ? 1 : 0,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      participantId: map['participant_id'],
      date: map['date'],
      isPresent: map['is_present'] == 1,
    );
  }
}
