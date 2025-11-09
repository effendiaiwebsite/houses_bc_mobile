class Appointment {
  final String id;
  final String zpid;
  final String propertyAddress;
  final DateTime dateTime;
  final String type; // 'in-person' or 'virtual'
  final String status; // 'pending', 'confirmed', 'cancelled'
  final String? notes;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.zpid,
    required this.propertyAddress,
    required this.dateTime,
    required this.type,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      zpid: json['zpid'] as String,
      propertyAddress: json['propertyAddress'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      type: json['type'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zpid': zpid,
      'propertyAddress': propertyAddress,
      'dateTime': dateTime.toIso8601String(),
      'type': type,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isPast => dateTime.isBefore(DateTime.now());
}
