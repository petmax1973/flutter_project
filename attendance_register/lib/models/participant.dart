class Participant {
  final String id;
  final String groupId;
  final String firstName;
  final String lastName;

  Participant({
    required this.id,
    required this.groupId,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'group_id': groupId,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      id: map['id'],
      groupId: map['group_id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
    );
  }
}
