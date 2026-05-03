class Review {
  final String id;
  final String userId;
  final String facilityId;
  final String appointmentId;
  final double rating;
  final String text;
  final List<String> images;
  final String ownerReply;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.facilityId,
    required this.appointmentId,
    required this.rating,
    required this.text,
    required this.images,
    required this.ownerReply,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map, String id) {
    return Review(
      id: id,
      userId: map['userId'] ?? '',
      facilityId: map['facilityId'] ?? '',
      appointmentId: map['appointmentId'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      text: map['text'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      ownerReply: map['ownerReply'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'facilityId': facilityId,
      'appointmentId': appointmentId,
      'rating': rating,
      'text': text,
      'images': images,
      'ownerReply': ownerReply,
      'createdAt': createdAt,
    };
  }
}
