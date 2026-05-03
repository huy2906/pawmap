class Pet {
  final String id;
  final String ownerId;
  final String name;
  final String species; // dog, cat, bird, etc.
  final String breed;
  final DateTime birthDate;
  final String gender;
  final double weight;
  final String color;

  Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    required this.breed,
    required this.birthDate,
    required this.gender,
    required this.weight,
    required this.color,
  });

  factory Pet.fromMap(Map<String, dynamic> map, String id) {
    return Pet(
      id: id,
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      species: map['species'] ?? '',
      breed: map['breed'] ?? '',
      birthDate: map['birthDate']?.toDate() ?? DateTime.now(),
      gender: map['gender'] ?? '',
      weight: map['weight']?.toDouble() ?? 0.0,
      color: map['color'] ?? '',
    );
  }
}
