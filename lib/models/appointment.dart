class Appointment {
  final String id;
  final String userId;
  final String petId;
  final String facilityId;
  final String service;
  final DateTime dateTime;
  final String status; // pending, confirmed, completed, cancelled
  final String notes;
  final double totalPrice;

  Appointment({
    required this.id,
    required this.userId,
    required this.petId,
    required this.facilityId,
    required this.service,
    required this.dateTime,
    required this.status,
    required this.notes,
    required this.totalPrice,
  });

  factory Appointment.fromMap(Map<String, dynamic> map, String id) {
    return Appointment(
      id: id,
      userId: map['userId'] ?? '',
      petId: map['petId'] ?? '',
      facilityId: map['facilityId'] ?? '',
      service: map['service'] ?? '',
      dateTime: map['dateTime']?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'pending',
      notes: map['notes'] ?? '',
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'petId': petId,
      'facilityId': facilityId,
      'service': service,
      'dateTime': dateTime,
      'status': status,
      'notes': notes,
      'totalPrice': totalPrice,
    };
  }
}
