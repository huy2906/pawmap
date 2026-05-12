import 'package:flutter/material.dart';
import 'package:trackasia_gl/trackasia_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:typed_data';
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

  List<dynamic> _places = [];
  bool _isLoading = false;
  double _currentLat = 10.7769; // Default HCMC
  double _currentLng = 106.7009;
  
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _selectedPlaceIndex = -1;

  Line? _currentRouteLine;
  String? _routeDuration;
  String? _routeDistance;
  bool _isShowingRoute = false;

  Timer? _debounce;
  List<dynamic> _autocompleteResults = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _fetchNearbyPlaces(_currentLat, _currentLng);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _fetchNearbyPlaces(_currentLat, _currentLng);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _fetchNearbyPlaces(_currentLat, _currentLng);
      return;
    }

    if (mounted) {
      setState(() {
        _locationGranted = true;
      });
    }
    
    _moveToCurrentLocation();
  }

  void _onMapCreated(TrackAsiaMapController controller) {
    _mapController = controller;
    
    controller.onSymbolTapped.add(_onSymbolTapped);

    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentLat, _currentLng),
          zoom: 14.0,
        ),
      ),
    );
  }

  Future<void> _onStyleLoaded() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/images/round_pushpin.png');
      final Uint8List list = bytes.buffer.asUint8List();
      await _mapController?.addImage('custom-marker', list);
    } catch (e) {
      debugPrint('Lỗi tải round_pushpin: $e');
    }

    try {
      final ByteData bytesBlue = await rootBundle.load('assets/images/blue_marker.png');
      final Uint8List listBlue = bytesBlue.buffer.asUint8List();
      await _mapController?.addImage('blue-marker', listBlue);
    } catch (e) {
      debugPrint('Lỗi tải blue_marker: $e');
    }

    if (_places.isNotEmpty) {
      _showPlacesOnMap(_places);
    }
  }

  void _onMapClick(Point<double> point, LatLng coordinates) async {
    if (_mapController == null || _places.isEmpty) return;

    int closestIndex = -1;
    double minDistance = double.infinity;

    final futures = _places.map((p) {
      final lat = p['geometry']['location']['lat'] as double;
      final lng = p['geometry']['location']['lng'] as double;
      return _mapController!.toScreenLocation(LatLng(lat, lng));
    }).toList();

    final points = await Future.wait(futures);

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final dx = p.x - point.x;
      final dy = p.y - point.y;
      final distance = sqrt(dx * dx + dy * dy);

      if (distance < 100 && distance < minDistance) {
        closestIndex = i;
        minDistance = distance;
      }
    }

    if (closestIndex != -1) {
      _onMarkerTapped(closestIndex);
    }
  }

  void _onMarkerTapped(int index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    if (index != _selectedPlaceIndex) {
      _onCardChanged(index);
    } else {
      final lat = _places[index]['geometry']['location']['lat'];
      final lng = _places[index]['geometry']['location']['lng'];
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15.0),
        ),
      );
    }

    if (_places[index]['is_search_result'] == true) {
      final lat = _places[index]['geometry']['location']['lat'];
      final lng = _places[index]['geometry']['location']['lng'];
      _places[index]['is_search_result'] = false;
      _fetchNearbyPlaces(lat, lng, searchResult: _places[index]);
    }
  }

  void _onSymbolTapped(Symbol symbol) {
    final index = _places.indexWhere((place) {
      final lat = (place['geometry']['location']['lat'] as num).toDouble();
      final lng = (place['geometry']['location']['lng'] as num).toDouble();
      final symLat = symbol.options.geometry?.latitude;
      final symLng = symbol.options.geometry?.longitude;
      if (symLat == null || symLng == null) return false;
      return (symLat - lat).abs() < 0.0001 && (symLng - lng).abs() < 0.0001;
    });

    if (index != -1) {
      _onMarkerTapped(index);
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

        if (targetLat < 8.0 ||
            targetLat > 23.5 ||
            targetLng < 102.0 ||
            targetLng > 109.5) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Vị trí giả lập nằm ngoài Việt Nam, đang dùng vị trí mặc định tại TP.HCM.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          targetLat = 10.7769;
          targetLng = 106.7009;
        }

        _currentLat = targetLat;
        _currentLng = targetLng;

        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(_currentLat, _currentLng), zoom: 14.0),
          ),
        );

        await _fetchNearbyPlaces(_currentLat, _currentLng);
      } catch (e) {
        debugPrint('Lỗi khi lấy vị trí: $e');
        _fetchNearbyPlaces(_currentLat, _currentLng);
      }
    } else {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(_currentLat, _currentLng), zoom: 14.0),
        ),
      );
      _fetchNearbyPlaces(_currentLat, _currentLng);
    }
  }

  Future<void> _fetchNearbyPlaces(double lat, double lng, {Map<String, dynamic>? searchResult}) async {
    setState(() {
      _isLoading = true;
      _routeDistance = null;
      _routeDuration = null;
      _isShowingRoute = false;
    });
    
    _removeRoute();

    final url =
        Uri.parse('https://maps.track-asia.com/api/v2/place/nearbysearch/json'
            '?location=$lat,$lng'
            '&radius=5000'
            '&key=${ApiKeys.trackAsiaKey}'
            '&type=veterinary_care|pet_store'
            '&new_admin=true');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
          List<dynamic> results = data['results'] as List<dynamic>? ?? [];
          
          if (searchResult != null) {
            final searchLat = searchResult['geometry']['location']['lat'];
            final searchLng = searchResult['geometry']['location']['lng'];
            results.removeWhere((p) => 
              p['geometry']['location']['lat'] == searchLat && 
              p['geometry']['location']['lng'] == searchLng
            );
            results.insert(0, searchResult);
          }
          
          setState(() {
            _places = results;
            _isLoading = false;
            if (searchResult != null) {
              _selectedPlaceIndex = 0;
            } else if (_places.isNotEmpty) {
              _selectedPlaceIndex = -1;
            }
          });
          
          if (results.isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Không tìm thấy địa điểm xung quanh')),
              );
            }
          } else {
            await _showPlacesOnMap(results);
            if (searchResult != null) {
              _mapController?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: LatLng(lat, lng), zoom: 15.0),
                ),
              );
            }
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi từ API: ${data['status']}')),
            );
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể kết nối đến server')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Lỗi API Nearby: $e');
    }
  }

  Future<void> _showPlacesOnMap(List<dynamic> places) async {
    if (_mapController == null) return;

    try {
      await _mapController!.clearSymbols();
    } catch (e) {
      debugPrint('Không thể xoá marker cũ: $e');
    }

    for (int i = 0; i < places.length; i++) {
      final place = places[i];
      final geometry = place['geometry']['location'];
      final placeLat = geometry['lat'] as double;
      final placeLng = geometry['lng'] as double;
      final name = place['name'] as String;

      try {
        await _mapController!.addSymbol(
          SymbolOptions(
            geometry: LatLng(placeLat, placeLng),
            iconImage: place['is_search_result'] == true ? "custom-marker" : "blue-marker",
            iconSize: i == _selectedPlaceIndex 
                      ? (place['is_search_result'] == true ? 0.6 : 1.5) 
                      : (place['is_search_result'] == true ? 0.4 : 1.0),
            textField: name,
            fontNames: const ['Noto Sans Regular'],
            textOffset: const Offset(0, 2.0),
            textSize: 14,
            textColor: '#1a1a1a',
            textHaloColor: '#FFFFFF',
            textHaloWidth: 2.0,
          ),
        );
      } catch (e) {
        debugPrint('Lỗi thêm marker mới: $e');
      }
    }
  }

  void _onCardChanged(int index) {
    if (index == _selectedPlaceIndex) return;

    setState(() {
      _selectedPlaceIndex = index;
    });

    final place = _places[index];
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 15.0,
        ),
      ),
    );

    // Update marker sizes
    _showPlacesOnMap(_places);
  }

  Future<void> _getDirections(double destLat, double destLng) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://maps.track-asia.com/route/v2/directions/json'
        '?origin=$_currentLat,$_currentLng'
        '&destination=$destLat,$destLng'
        '&mode=driving'
        '&key=${ApiKeys.trackAsiaKey}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final polylineString = route['overview_polyline']['points'];
          final distance = route['legs'][0]['distance']['text'];
          final duration = route['legs'][0]['duration']['text'];

          setState(() {
            _routeDistance = distance;
            _routeDuration = duration;
            _isShowingRoute = true;
            _isLoading = false;
          });

          _drawRoute(polylineString);
        } else {
          setState(() {
            _isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Không tìm thấy đường đi')),
            );
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lỗi gọi API Directions')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Lỗi Directions: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }
    return poly;
  }

  Future<void> _drawRoute(String encodedPolyline) async {
    if (_mapController == null) return;

    _removeRoute();

    List<LatLng> points = _decodePolyline(encodedPolyline);

    if (points.isNotEmpty) {
      _currentRouteLine = await _mapController!.addLine(
        LineOptions(
          geometry: points,
          lineColor: "#2196F3",
          lineWidth: 4.0,
          lineOpacity: 0.8,
        ),
      );

      double minLat = points.first.latitude;
      double maxLat = points.first.latitude;
      double minLng = points.first.longitude;
      double maxLng = points.first.longitude;

      for (var point in points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }

      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          left: 50,
          right: 50,
          top: 150,
          bottom: 250,
        ),
      );
    }
  }

  void _removeRoute() {
    if (_mapController != null && _currentRouteLine != null) {
      _mapController!.removeLine(_currentRouteLine!);
      _currentRouteLine = null;
    }
    setState(() {
      _isShowingRoute = false;
      _routeDistance = null;
      _routeDuration = null;
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      setState(() {
        _autocompleteResults = [];
        _isSearching = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _fetchAutocomplete(query);
    });
  }

  Future<void> _fetchAutocomplete(String query) async {
    setState(() {
      _isSearching = true;
    });

    final url = Uri.parse('https://maps.track-asia.com/api/v2/place/autocomplete/json'
        '?input=$query'
        '&location=$_currentLat,$_currentLng'
        '&size=5'
        '&new_admin=true'
        '&key=${ApiKeys.trackAsiaKey}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
          setState(() {
            _autocompleteResults = data['predictions'] as List<dynamic>? ?? [];
            _isSearching = false;
          });
        } else {
          setState(() {
            _isSearching = false;
            _autocompleteResults = [];
          });
        }
      } else {
        setState(() {
          _isSearching = false;
          _autocompleteResults = [];
        });
      }
    } catch (e) {
      debugPrint('Lỗi Autocomplete API: $e');
      setState(() {
        _isSearching = false;
        _autocompleteResults = [];
      });
    }
  }

  Future<void> _onSuggestionSelected(dynamic suggestion) async {
    _searchFocusNode.unfocus();
    setState(() {
      _autocompleteResults = [];
      _searchController.text = suggestion['name'] ?? '';
      _isLoading = true;
    });

    final placeId = suggestion['place_id'];
    if (placeId == null) {
      setState(() { _isLoading = false; });
      return;
    }

    final url = Uri.parse('https://maps.track-asia.com/api/v2/place/details/json'
        '?place_id=$placeId'
        '&key=${ApiKeys.trackAsiaKey}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          final result = data['result'];
          final lat = result['geometry']['location']['lat'] as double;
          final lng = result['geometry']['location']['lng'] as double;
          final name = result['name'] as String;

          final place = {
            'geometry': {
              'location': {'lat': lat, 'lng': lng}
            },
            'name': name,
            'vicinity': result['formatted_address'] ?? result['vicinity'] ?? '',
            'rating': result['rating'] ?? 4.5,
            'is_search_result': true,
          };

          _fetchNearbyPlaces(lat, lng, searchResult: place);
        }
      }
    } catch (e) {
      debugPrint('Lỗi Place Details API: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (value) {
                      setState(() {});
                      _onSearchChanged(value);
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) _fetchAutocomplete(value);
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Tìm quán quen bạn nhé...',
                      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                      setState(() {
                        _autocompleteResults = [];
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: _isSearching
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      final text = _searchController.text;
                      if (text.isNotEmpty) {
                        _searchFocusNode.unfocus();
                        _fetchAutocomplete(text);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_autocompleteResults.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                itemCount: _autocompleteResults.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final suggestion = _autocompleteResults[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.grey),
                    title: Text(suggestion['name'] ?? ''),
                    subtitle: Text(
                      suggestion['description'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _onSuggestionSelected(suggestion),
                  );
                },
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    if (_places.isEmpty) return const SizedBox.shrink();

    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onCardChanged,
        itemCount: _places.length,
        itemBuilder: (context, index) {
          final place = _places[index];
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];

          final distance = Geolocator.distanceBetween(
              _currentLat, _currentLng, lat, lng);
          final distanceText = distance > 1000
              ? '${(distance / 1000).toStringAsFixed(2)} Km'
              : '${distance.toStringAsFixed(0)} m';

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 110,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(12)),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://picsum.photos/seed/picsum/200/300'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              place['rating']?.toString() ?? '4.5',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          place['name'] ?? 'Không có tên',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '📍 $distanceText  🕐 Đang mở',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.blue),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          place['formatted_address'] ??
                              place['vicinity'] ??
                              '',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _getDirections(lat, lng);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 0),
                                  minimumSize: const Size(0, 30),
                                ),
                                child: const Text('Chỉ đường',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 0),
                                  minimumSize: const Size(0, 30),
                                ),
                                child: const Text('Chi tiết',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRouteInfo() {
    if (!_isShowingRoute) return const SizedBox.shrink();

    return Positioned(
      bottom: 210,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.directions_car, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$_routeDistance • $_routeDuration',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: _removeRoute,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return Positioned(
      bottom: _isShowingRoute ? 270 : 210,
      right: 16,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _moveToCurrentLocation,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (!_isLoading) return const SizedBox.shrink();
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TrackAsiaMap(
            styleString: _styleUrl,
            initialCameraPosition: CameraPosition(
              target: LatLng(_currentLat, _currentLng),
              zoom: 14.0,
            ),
            onMapCreated: _onMapCreated,
            onMapClick: _onMapClick,
            onStyleLoadedCallback: _onStyleLoaded,
            myLocationEnabled: _locationGranted,
            myLocationTrackingMode: _locationGranted
                ? MyLocationTrackingMode.tracking
                : MyLocationTrackingMode.none,
            minMaxZoomPreference: const MinMaxZoomPreference(5, 18),
            compassEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
          ),
          _buildSearchBar(),
          _buildRouteInfo(),
          _buildFAB(),
          _buildBottomSheet(),
          _buildLoadingIndicator(),
        ],
      ),
    );
  }
}
