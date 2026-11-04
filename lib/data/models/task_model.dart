class TaskModel {
  String? id;
  String eventId;
  String title;
  String? description;
  DateTime dueDate;
  String status; // todo, in_progress, completed
  bool enableReminder;
  DateTime? createdAt;
  DateTime? updatedAt;

  TaskModel({
    this.id,
    required this.eventId,
    required this.title,
    this.description,
    required this.dueDate,
    this.status = 'todo',
    this.enableReminder = true,
    this.createdAt,
    this.updatedAt,
  });

  bool get isCompleted => status == 'completed';

  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return deadlineDay.isBefore(today);
  }

  String get displayStatus {
    switch (status) {
      case 'completed':
        return 'Terminée';
      case 'in_progress':
        return 'En cours';
      case 'todo':
      default:
        return 'À faire';
    }
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id']?.toString(),
      eventId: json['event_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      dueDate: json['due_date'] != null
          ? (DateTime.tryParse(json['due_date']) ?? DateTime.now())
          : DateTime.now(),
      status: json['status'] ?? 'todo',
      enableReminder: json['enable_reminder'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
