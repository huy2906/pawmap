import 'package:flutter/material.dart';
import '../models/facility.dart';
import '../theme/app_theme.dart';
import 'booking_screen.dart';

class FacilityDetailScreen extends StatelessWidget {
  final Facility facility;

  const FacilityDetailScreen({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(facility.name, style: const TextStyle(fontSize: 16)),
              background: Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        facility.type.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.primaryMintDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 20),
                          Text(' ${facility.rating} (120 reviews)'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(child: Text(facility.address)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(facility.phone),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Dịch vụ cung cấp',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...facility.services.map((service) => ListTile(
                        leading: const Icon(Icons.check_circle, color: AppTheme.primaryMintDark),
                        title: Text(service['name']),
                        trailing: Text('${service['price']} VND'),
                      )),
                  const SizedBox(height: 24),
                  const Text(
                    'Giờ hoạt động',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Mock open hours
                  const Text('Thứ 2 - Thứ 6: 08:00 - 18:00\nThứ 7 - CN: 09:00 - 16:00'),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookingScreen(facility: facility)),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('ĐẶT LỊCH NGAY'),
        ),
      ),
    );
  }
}
