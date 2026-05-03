class Facility {
  final String id;
  final String name;
  final String type; // vet / grooming / hotel / shop / rescue
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final Map<String, dynamic> openHours;
  final List<dynamic> services;
  final List<String> images;
  final double rating;

  Facility({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.openHours,
    required this.services,
    required this.images,
    required this.rating,
  });

  factory Facility.fromMap(Map<String, dynamic> map, String id) {
    return Facility(
      id: id,
      name: map['name'] ?? '',
      type: map['type'] ?? 'vet',
      address: map['address'] ?? '',
      latitude: map['coordinates']?['lat'] ?? 0.0,
      longitude: map['coordinates']?['lng'] ?? 0.0,
      phone: map['phone'] ?? '',
      openHours: map['openHours'] ?? {},
      services: map['services'] ?? [],
      images: List<String>.from(map['images'] ?? []),
      rating: map['rating']?['average']?.toDouble() ?? 0.0,
    );
  }
}
