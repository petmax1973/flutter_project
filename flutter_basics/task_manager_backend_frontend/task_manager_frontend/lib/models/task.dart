class Task {
  final int? id;
  final String title;
  final String? description;
  final String status;
  final String? assignedTo;
  final int priority;
  final int? createdAt;
  final int? updatedAt;

  Task({
    this.id,
    required this.title,
    this.description,
    this.status = 'pending',
    this.assignedTo,
    this.priority = 1,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      assignedTo: json['assigned_to'],
      priority: json['priority'] ?? 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'status': status,
      if (assignedTo != null) 'assigned_to': assignedTo,
      'priority': priority,
    };
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    String? assignedTo,
    int? priority,
    int? createdAt,
    int? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
