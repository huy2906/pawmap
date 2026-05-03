import 'package:flutter/material.dart';
import 'package:trackasia_gl/trackasia_gl.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  TrackAsiaMapController? _mapController;
  final String _styleUrl =
      'https://maps.track-asia.com/styles/v1/streets.json?key=db017177761694204b5f9f312923e00869';
  bool _searching = true;

  void _onMapCreated(TrackAsiaMapController controller) {
    _mapController = controller;
  }

  void _onStyleLoaded() {
    _findNearestEmergencyFacility();
  }

  Future<void> _findNearestEmergencyFacility() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _searching = false);

    const nearestFacilityCoords = LatLng(10.7769, 106.7009);

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(target: nearestFacilityCoords, zoom: 15),
      ),
    );

    try {
      await _mapController?.addCircle(
        const CircleOptions(
          geometry: LatLng(10.7769, 106.7009),
          circleRadius: 14,
          circleColor: '#FF0000',
          circleStrokeWidth: 3,
          circleStrokeColor: '#FFFFFF',
        ),
      );
      await _mapController?.addSymbol(
        const SymbolOptions(
          geometry: LatLng(10.7769, 106.7009),
          textField: 'PetCare 24/7',
          textOffset: Offset(0, 2.2),
          textSize: 14,
          textColor: '#CC0000',
          textHaloColor: '#FFFFFF',
          textHaloWidth: 2,
        ),
      );
    } catch (e) {
      debugPrint('Error adding marker: \$e');
    }

    if (mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.red, size: 56),
              const SizedBox(height: 12),
              const Text(
                'TÌM THẤY PHÒNG KHÁM CẤP CỨU GẦN NHẤT',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text('Phòng Khám PetCare 24/7',
                  style: TextStyle(fontSize: 16)),
              const Text('Cách bạn 2.5 km',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.directions),
                      label: const Text('Chỉ đường'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      label: const Text('GỌI NGAY'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CẤP CỨU 24/7'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          TrackAsiaMap(
            styleString: _styleUrl,
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.7769, 106.7009),
              zoom: 12.0,
            ),
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoaded,
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.tracking,
          ),
          if (_searching)
            Container(
              color: Colors.black45,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Đang tìm phòng khám gần nhất...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
