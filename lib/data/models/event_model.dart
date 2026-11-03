class EventModel {

  //les propriétés du model Event
  final String? id;
  final String userId;
  final String name;
  final String type;
  final String? description;
  final DateTime date;
  final String time;
  final String location;
  final double budget;
  final bool isPaid;
  final double ticketPrice;
  final String? publicLink;
  final DateTime? createdAt;

  EventModel({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.budget,
    this.isPaid = false,
    this.ticketPrice = 0.0,
    this.publicLink,
    this.createdAt,
  });

  //convertit un objet supabase (qui es en json ou map en objet eventmodel
  //on va utiliser ca en particulier pour la lecture 
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      location: json['location'],
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      isPaid: json['is_paid'] ?? false,
      ticketPrice: (json['ticket_price'] as num?)?.toDouble() ?? 0.0,
      publicLink: json['public_link'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // ca c'est pour onvertit un objet EventModel en Map/JSON pour l'envoyer à Supabase
  //on va utiliser ca pour l'insertion et le update
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'type': type,
      'description': description,
      'date': date.toIso8601String().split('T').first, // Format YYYY-MM-DD
      'time': time,
      'location': location,
      'budget': budget,
      'is_paid': isPaid,
      'ticket_price': ticketPrice,
      'public_link': publicLink,
    };
  }
}