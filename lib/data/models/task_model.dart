class TaskModel {
  String? id;
  String eventId;
  String title;
  String? description;
  DateTime dueDate; // c'est due_date en base de donneés
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

//ici je definis les regles métiers 
// une tach est terminée  si son statut est 'completed'
  bool get isCompleted => status == 'completed';

  // une tach est en retard si la date limite est passée et la tâche non terminée
  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return deadlineDay.isBefore(today);//si la deadline est passé avant today
  }

  // libellé en français pour l'affichage dans l'interface
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

  //convertir du json en dart 
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      eventId: json['event_id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['due_date']),
      status: json['status'] ?? 'todo',
      enableReminder: json['enable_reminder'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // conversion de dart vers json
  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(), // timestamptz
      'status': status,
      'enable_reminder': enableReminder,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

}