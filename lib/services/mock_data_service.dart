import 'package:cloud_firestore/cloud_firestore.dart';

class MockDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadMockFacilities() async {
    final CollectionReference facilities = _firestore.collection('facilities');

    final List<Map<String, dynamic>> mockData = [
      {
        'name': 'Phòng khám thú y PetCare',
        'type': 'vet',
        'address': '123 Nguyễn Thị Minh Khai, Quận 1, TP.HCM',
        'coordinates': {'lat': 10.7769, 'lng': 106.7009},
        'geohash': 'w3gvd',
        'phone': '0901234567',
        'openHours': {
          'mon': {'open': '08:00', 'close': '18:00'},
        },
        'services': [
          {'name': 'Khám tổng quát', 'price': 200000, 'duration': 30},
          {'name': 'Tiêm vaccine', 'price': 150000, 'duration': 15},
        ],
        'images': ['https://via.placeholder.com/400x200'],
        'rating': {'average': 4.8, 'count': 120},
        'verified': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      // Thêm các cơ sở mẫu khác tại đây...
    ];

    for (var data in mockData) {
      await facilities.add(data);
    }
  }
}
