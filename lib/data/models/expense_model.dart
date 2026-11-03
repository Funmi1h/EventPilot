class ExpenseModel {
  String? id;
  String eventId;
  String label;
  double amount;
  DateTime expenseDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  ExpenseModel({
    this.id,
    required this.eventId,
    required this.label,
    required this.amount,
    required this.expenseDate,
    this.createdAt,
    this.updatedAt,
  });

  // on convertit le json en objet dart 
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      eventId: json['event_id'],
      label: json['label'],
      amount: (json['amount'] as num).toDouble(),
      expenseDate: DateTime.parse(json['expense_date']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Convertit l'objet Dart en JSON pour Supabase
  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'label': label,
      'amount': amount,
      'expense_date': expenseDate.toIso8601String().split('T').first, // YYYY-MM-DD
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}