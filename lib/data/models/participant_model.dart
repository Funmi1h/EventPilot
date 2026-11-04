class ParticipantModel {
  String? id;
  String eventId;
  String fullName;
  String email;
  String phone;
  String registrationStatus; // pending, confirmed, attended, cancelled
  DateTime? createdAt;
  DateTime? updatedAt;

  ParticipantModel({
    this.id,
    required this.eventId,
    required this.fullName,
    required this.email,
    required this.phone,
    this.registrationStatus = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  bool get isPaid => registrationStatus == 'confirmed' || registrationStatus == 'Payé';

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'P';
  }

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['id']?.toString(),
      eventId: json['event_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      registrationStatus: json['registration_status']?.toString() ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'registration_status': registrationStatus,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}

