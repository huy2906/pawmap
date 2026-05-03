import 'package:flutter/material.dart';
import 'package:trackasia_gl/trackasia_gl.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TrackAsiaMapController? _mapController;
  final String _styleUrl =
      'https://maps.track-asia.com/styles/v1/streets.json?key=db017177761694204b5f9f312923e00869';

  void _onMapCreated(TrackAsiaMapController controller) {
    _mapController = controller;
  }

  Future<void> _onStyleLoaded() async {
    if (_mapController == null || !mounted) return;

    final clinics = [
      {'name': 'PetCare TPHCM', 'lat': 10.7769, 'lng': 106.7009},
      {'name': 'Thú y Sài Gòn Pet', 'lat': 10.7850, 'lng': 106.6980},
      {'name': 'AnimalsLove Clinic', 'lat': 10.7700, 'lng': 106.7120},
    ];

    for (final clinic in clinics) {
      try {
        await _mapController!.addCircle(
          CircleOptions(
            geometry: LatLng(clinic['lat'] as double, clinic['lng'] as double),
            circleRadius: 10,
            circleColor: '#2E7D32',
            circleStrokeWidth: 2,
            circleStrokeColor: '#FFFFFF',
          ),
        );
        await _mapController!.addSymbol(
          SymbolOptions(
            geometry: LatLng(clinic['lat'] as double, clinic['lng'] as double),
            textField: clinic['name'] as String,
            textOffset: const Offset(0, 2.0),
            textSize: 12,
            textColor: '#1a1a1a',
            textHaloColor: '#FFFFFF',
            textHaloWidth: 1.5,
          ),
        );
      } catch (e) {
        debugPrint('Error adding marker: \$e');
      }
    }
  }

  void _moveToCurrentLocation() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(target: LatLng(10.7769, 106.7009), zoom: 14.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản Đồ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Vị trí của tôi',
            onPressed: _moveToCurrentLocation,
          ),
        ],
      ),
      body: TrackAsiaMap(
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _moveToCurrentLocation,
        icon: const Icon(Icons.near_me),
        label: const Text('Xung quanh tôi'),
      ),
    );
  }
}
