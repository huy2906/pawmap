import 'package:flutter/material.dart';
import '../models/facility.dart';
import '../screens/facility_detail_screen.dart';
import '../theme/app_theme.dart';

class FacilityQuickInfoSheet extends StatelessWidget {
  final Facility facility;

  const FacilityQuickInfoSheet({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  facility.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryMint.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  facility.type.toUpperCase(),
                  style: const TextStyle(color: AppTheme.primaryMintDark, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 18),
              Text(' ${facility.rating} (120 đánh giá)'),
            ],
          ),
          const SizedBox(height: 12),
          Text(facility.address, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions),
                  label: const Text('Chỉ đường'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FacilityDetailScreen(facility: facility)),
                    );
                  },
                  child: const Text('Chi tiết'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
