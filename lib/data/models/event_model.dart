class EventModel {
  String? id;
  String userId;
  String name;
  String type;
  String? description;
  DateTime date;
  String time;
  String location;
  double budget;
  bool isPaid;
  double ticketPrice;
  String? publicLink;
  DateTime? createdAt;

  EventModel({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.description,
    required this.date,
    required this.time,
    this.location = '',
    required this.budget,
    this.isPaid = false,
    this.ticketPrice = 0.0,
    this.publicLink,
    this.createdAt,
  });

  //convertir un map supabase en eventmodel de facon securisee
  factory EventModel.fromJson(Map<String, dynamic> json) {
    //securiser la conversion du budget
    final rawBudget = json['initial_budget'] ?? json['budget'];
    double parsedBudget = 0.0;
    if (rawBudget is num) {
      parsedBudget = rawBudget.toDouble();
    } else if (rawBudget != null) {
      parsedBudget = double.tryParse(rawBudget.toString()) ?? 0.0;
    }

    //securiser la conversion du tarif de participation
    final rawFee = json['participation_fee'] ?? json['ticket_price'];
    double parsedFee = 0.0;
    if (rawFee is num) {
      parsedFee = rawFee.toDouble();
    } else if (rawFee != null) {
      parsedFee = double.tryParse(rawFee.toString()) ?? 0.0;
    }

    //securiser la conversion de la date
    DateTime parsedDate = DateTime.now();
    final rawDate = json['event_date'] ?? json['date'];
    if (rawDate != null) {
      parsedDate = DateTime.tryParse(rawDate.toString()) ?? DateTime.now();
    }

    return EventModel(
      id: json['id']?.toString(),
      userId: json['organizer_id']?.toString() ?? json['user_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['event_type']?.toString() ?? json['type']?.toString() ?? 'Événement',
      description: json['description']?.toString(),
      date: parsedDate,
      time: json['event_time']?.toString() ?? json['time']?.toString() ?? '10:00',
      location: json['location']?.toString() ?? '',
      budget: parsedBudget,
      isPaid: json['is_paid'] == true,
      ticketPrice: parsedFee,
      publicLink: (json['id'] != null && json['id'].toString().isNotEmpty)
          ? 'http://localhost:8080/#/public/event?id=${json['id']}'
          : (json['public_url']?.toString() ?? json['public_link']?.toString() ?? 'http://localhost:8080/#/public/event'),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  //lien public formate pour consulter et partager l'evenement
  String get computedPublicUrl {
    if (id != null && id!.isNotEmpty) {
      return 'http://localhost:8080/#/public/event?id=$id';
    }
    return publicLink ?? 'http://localhost:8080/#/public/event';
  }

  //convertit un objet eventmodel en map pour supabase
  Map<String, dynamic> toJson() {
    return {
      'organizer_id': userId,
      'name': name,
      'event_type': type,
      'description': description,
      'event_date': date.toIso8601String().split('T').first,
      'event_time': time,
      'initial_budget': budget,
      'is_paid': isPaid,
      'participation_fee': ticketPrice,
      'public_url': (id != null && id!.isNotEmpty)
          ? 'http://localhost:8080/#/public/event?id=$id'
          : 'http://localhost:8080/#/public/event',
    };
  }
}
