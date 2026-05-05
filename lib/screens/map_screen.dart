import 'package:flutter/material.dart';
import 'package:trackasia_gl/trackasia_gl.dart';
import 'package:geolocator/geolocator.dart';
import '../config/api_keys.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TrackAsiaMapController? _mapController;
  bool _locationGranted = false;
  final String _styleUrl =
      'https://maps.track-asia.com/styles/v2/streets.json?key=${ApiKeys.trackAsiaKey}';

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (mounted) {
      setState(() {
        _locationGranted = true;
      });
    }
  }

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
            fontNames: const ['Noto Sans Regular'],
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

  Future<void> _moveToCurrentLocation() async {
    if (_locationGranted) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14.0),
          ),
        );
      } catch (e) {
        debugPrint('Lỗi khi lấy vị trí: $e');
      }
    } else {
      _checkLocationPermission();
    }
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
        myLocationEnabled: _locationGranted,
        myLocationTrackingMode: _locationGranted
            ? MyLocationTrackingMode.tracking
            : MyLocationTrackingMode.none,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _moveToCurrentLocation,
        icon: const Icon(Icons.near_me),
        label: const Text('Xung quanh tôi'),
      ),
    );
  }
}
