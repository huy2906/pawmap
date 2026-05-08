import 'package:flutter/material.dart';
import 'package:trackasia_gl/trackasia_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
    // Fix: moveCamera ngay lập tức (không animation) đến TP.HCM
    // trước khi style load xong để tránh SDK request tile San Francisco
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(10.7769, 106.7009),
          zoom: 12.0,
        ),
      ),
    );
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

        double targetLat = position.latitude;
        double targetLng = position.longitude;

        // Kiểm tra nếu vị trí nằm ngoài lãnh thổ Việt Nam (ví dụ do máy ảo Emulator mặc định GPS ở Mỹ)
        // Bounding box tương đối của Việt Nam: vĩ độ (8.0 -> 23.5), kinh độ (102.0 -> 109.5)
        if (targetLat < 8.0 || targetLat > 23.5 || 
            targetLng < 102.0 || targetLng > 109.5) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vị trí giả lập nằm ngoài Việt Nam, đang dùng vị trí mặc định tại TP.HCM.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          targetLat = 10.7769;
          targetLng = 106.7009;
        }

        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(targetLat, targetLng),
                zoom: 14.0),
          ),
        );

        // Gọi API tìm kiếm địa điểm xung quanh
        await _fetchNearbyPlaces(targetLat, targetLng);

      } catch (e) {
        debugPrint('Lỗi khi lấy vị trí: $e');
      }
    } else {
      _checkLocationPermission();
    }
  }

  Future<void> _fetchNearbyPlaces(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.track-asia.com/api/v2/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=2000'
        '&key=${ApiKeys.trackAsiaKey}'
        '&type=veterinary|pet_store|pharmacy'
        '&new_admin=true');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final results = data['results'] as List<dynamic>;
          if (results.isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Không tìm thấy địa điểm xung quanh')),
              );
            }
            return;
          }

          await _showPlacesOnMap(results);
          _showPlacesBottomSheet(results, lat, lng);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi từ API: ${data['status']}')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể kết nối đến server')),
          );
        }
      }
    } catch (e) {
      debugPrint('Lỗi API Nearby: $e');
    }
  }

  Future<void> _showPlacesOnMap(List<dynamic> places) async {
    if (_mapController == null) return;

    try {
      await _mapController!.clearCircles();
      await _mapController!.clearSymbols();
    } catch (e) {
      debugPrint('Không thể xoá marker cũ: $e');
    }

    for (var place in places) {
      final geometry = place['geometry']['location'];
      final placeLat = geometry['lat'] as double;
      final placeLng = geometry['lng'] as double;
      final name = place['name'] as String;

      try {
        await _mapController!.addCircle(
          CircleOptions(
            geometry: LatLng(placeLat, placeLng),
            circleRadius: 10,
            circleColor: '#1976D2', // Màu xanh
            circleStrokeWidth: 2,
            circleStrokeColor: '#FFFFFF',
          ),
        );
        await _mapController!.addSymbol(
          SymbolOptions(
            geometry: LatLng(placeLat, placeLng),
            textField: name,
            fontNames: const ['Noto Sans Regular'],
            textOffset: const Offset(0, 2.0),
            textSize: 12,
            textColor: '#1a1a1a',
            textHaloColor: '#FFFFFF',
            textHaloWidth: 1.5,
          ),
        );
      } catch (e) {
        debugPrint('Lỗi thêm marker mới: $e');
      }
    }
  }

  void _showPlacesBottomSheet(List<dynamic> places, double currentLat, double currentLng) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Địa điểm xung quanh',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    final geometry = place['geometry']['location'];
                    final lat = geometry['lat'] as double;
                    final lng = geometry['lng'] as double;

                    final distance = Geolocator.distanceBetween(currentLat, currentLng, lat, lng);
                    final distanceText = distance > 1000 
                        ? '${(distance / 1000).toStringAsFixed(1)} km'
                        : '${distance.toStringAsFixed(0)} m';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.place, color: Colors.blue),
                      ),
                      title: Text(place['name'] ?? 'Không có tên'),
                      subtitle: Text(place['formatted_address'] ?? place['vicinity'] ?? ''),
                      trailing: Text(
                        distanceText,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      onTap: () {
                        _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
                          ),
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
        myLocationEnabled: _locationGranted,
        myLocationTrackingMode: _locationGranted
            ? MyLocationTrackingMode.tracking
            : MyLocationTrackingMode.none,
        // Fix: buộc SDK dùng tọa độ TP.HCM ngay từ đầu,
        // tránh render tile mặc định San Francisco của SDK
        minMaxZoomPreference: const MinMaxZoomPreference(10, 18),
        compassEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _moveToCurrentLocation,
        icon: const Icon(Icons.near_me),
        label: const Text('Xung quanh tôi'),
      ),
    );
  }
}
