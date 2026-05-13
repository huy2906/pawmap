import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../config/api_keys.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  bool _locationGranted = false;
  double _currentLat = 10.7769;
  double _currentLng = 106.7009;

  List<dynamic> _places = [];
  bool _isLoading = false;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _selectedPlaceIndex = -1;

  Set<Marker> _markers = {};

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
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) { _fetchNearbyPlaces(_currentLat, _currentLng); return; }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) { _fetchNearbyPlaces(_currentLat, _currentLng); return; }
    }
    if (permission == LocationPermission.deniedForever) { _fetchNearbyPlaces(_currentLat, _currentLng); return; }

    if (mounted) setState(() => _locationGranted = true);
    _moveToCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng position) {}

  Future<void> _moveToCurrentLocation() async {
    if (_locationGranted) {
      try {
        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        double lat = position.latitude;
        double lng = position.longitude;
        if (lat < 8.0 || lat > 23.5 || lng < 102.0 || lng > 109.5) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vị trí nằm ngoài Việt Nam, dùng mặc định TP.HCM.'), duration: Duration(seconds: 3)));
          lat = 10.7769; lng = 106.7009;
        }
        _currentLat = lat; _currentLng = lng;
        _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 14.0)));
        await _fetchNearbyPlaces(lat, lng);
      } catch (e) {
        debugPrint('Lỗi vị trí: $e');
        _fetchNearbyPlaces(_currentLat, _currentLng);
      }
    } else {
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_currentLat, _currentLng), zoom: 14.0)));
      _fetchNearbyPlaces(_currentLat, _currentLng);
    }
  }

  Future<void> _fetchNearbyPlaces(double lat, double lng, {Map<String, dynamic>? searchResult}) async {
    setState(() { _isLoading = true; });

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=$lat,$lng&radius=5000&type=veterinary_care&key=${ApiKeys.googlePlacesKey}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
          List<dynamic> results = data['results'] as List<dynamic>? ?? [];
          if (searchResult != null) {
            final sLat = searchResult['geometry']['location']['lat'];
            final sLng = searchResult['geometry']['location']['lng'];
            results.removeWhere((p) => p['geometry']['location']['lat'] == sLat && p['geometry']['location']['lng'] == sLng);
            results.insert(0, searchResult);
          }
          setState(() { _places = results; _isLoading = false; _selectedPlaceIndex = searchResult != null ? 0 : -1; });
          if (results.isEmpty) {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không tìm thấy địa điểm xung quanh')));
          } else {
            _buildMarkers(results);
            if (searchResult != null) {
              _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 15.0)));
            }
          }
        } else {
          setState(() => _isLoading = false);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không tìm thấy kết quả: ${data['status']}')));
        }
      } else {
        setState(() => _isLoading = false);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể kết nối server')));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Lỗi Nearby API: $e');
    }
  }

  void _buildMarkers(List<dynamic> places) {
    final Set<Marker> markers = {};
    for (int i = 0; i < places.length; i++) {
      final place = places[i];
      final lat = (place['geometry']['location']['lat'] as num).toDouble();
      final lng = (place['geometry']['location']['lng'] as num).toDouble();
      final isSearch = place['is_search_result'] == true;
      markers.add(Marker(
        markerId: MarkerId(place['place_id'] ?? 'place_$i'),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(isSearch ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen),
        onTap: () => _onMarkerTap(i),
      ));
    }
    setState(() => _markers = markers);
  }

  void _onMarkerTap(int index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    if (index != _selectedPlaceIndex) {
      _onCardChanged(index);
    } else {
      final lat = (_places[index]['geometry']['location']['lat'] as num).toDouble();
      final lng = (_places[index]['geometry']['location']['lng'] as num).toDouble();
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 15.0)));
    }
    if (_places[index]['is_search_result'] == true) {
      final lat = (_places[index]['geometry']['location']['lat'] as num).toDouble();
      final lng = (_places[index]['geometry']['location']['lng'] as num).toDouble();
      _places[index]['is_search_result'] = false;
      _fetchNearbyPlaces(lat, lng, searchResult: _places[index]);
    }
  }

  void _onCardChanged(int index) {
    if (index == _selectedPlaceIndex) return;
    setState(() => _selectedPlaceIndex = index);
    final lat = (_places[index]['geometry']['location']['lat'] as num).toDouble();
    final lng = (_places[index]['geometry']['location']['lng'] as num).toDouble();
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 15.0)));
    _buildMarkers(_places);
  }

  Future<void> _openGoogleMapsDirections(double destLat, double destLng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng';
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể mở Google Maps')),
        );
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.isEmpty) { setState(() { _autocompleteResults = []; _isSearching = false; }); return; }
    _debounce = Timer(const Duration(milliseconds: 300), () => _fetchAutocomplete(query));
  }

  Future<void> _fetchAutocomplete(String query) async {
    setState(() => _isSearching = true);
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=${Uri.encodeComponent(query)}&location=$_currentLat,$_currentLng'
      '&radius=50000&language=vi&key=${ApiKeys.googlePlacesKey}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
          setState(() { _autocompleteResults = data['predictions'] as List<dynamic>? ?? []; _isSearching = false; });
        } else {
          setState(() { _isSearching = false; _autocompleteResults = []; });
        }
      } else {
        setState(() { _isSearching = false; _autocompleteResults = []; });
      }
    } catch (e) {
      debugPrint('Lỗi Autocomplete: $e');
      setState(() { _isSearching = false; _autocompleteResults = []; });
    }
  }

  Future<void> _onSuggestionSelected(dynamic suggestion) async {
    _searchFocusNode.unfocus();
    final desc = suggestion['description'] ?? suggestion['structured_formatting']?['main_text'] ?? '';
    setState(() { _autocompleteResults = []; _searchController.text = desc; _isLoading = true; });

    final placeId = suggestion['place_id'];
    if (placeId == null) { setState(() => _isLoading = false); return; }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json'
      '?place_id=$placeId&fields=geometry,name,formatted_address&key=${ApiKeys.googlePlacesKey}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          final result = data['result'];
          final lat = (result['geometry']['location']['lat'] as num).toDouble();
          final lng = (result['geometry']['location']['lng'] as num).toDouble();
          final name = result['name'] as String? ?? desc;
          final place = {
            'geometry': {'location': {'lat': lat, 'lng': lng}},
            'name': name,
            'vicinity': result['formatted_address'] ?? '',
            'rating': 4.5,
            'is_search_result': true,
          };
          _fetchNearbyPlaces(lat, lng, searchResult: place);
        }
      }
    } catch (e) {
      debugPrint('Lỗi Place Details: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _photoUrl(String? ref) {
    if (ref == null || ref.isEmpty) return '';
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$ref&key=${ApiKeys.googlePlacesKey}';
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 50, left: 16, right: 16,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Row(children: [
            Expanded(child: TextField(
              controller: _searchController, focusNode: _searchFocusNode,
              onChanged: (v) { setState(() {}); _onSearchChanged(v); },
              onSubmitted: (v) { if (v.isNotEmpty) _fetchAutocomplete(v); },
              decoration: InputDecoration.collapsed(
                hintText: 'Tìm quán quen bạn nhé...',
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              style: const TextStyle(fontSize: 16),
            )),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                onPressed: () { _searchController.clear(); _searchFocusNode.unfocus(); setState(() => _autocompleteResults = []); },
                padding: EdgeInsets.zero, constraints: const BoxConstraints(),
              ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
              child: IconButton(
                icon: _isSearching
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.search, color: Colors.white),
                onPressed: () { final t = _searchController.text; if (t.isNotEmpty) { _searchFocusNode.unfocus(); _fetchAutocomplete(t); } },
              ),
            ),
          ]),
        ),
        if (_autocompleteResults.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8), shrinkWrap: true,
              itemCount: _autocompleteResults.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final s = _autocompleteResults[index];
                final main = s['structured_formatting']?['main_text'] ?? s['description'] ?? '';
                final secondary = s['structured_formatting']?['secondary_text'] ?? '';
                return ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.grey),
                  title: Text(main),
                  subtitle: secondary.isNotEmpty ? Text(secondary, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
                  onTap: () => _onSuggestionSelected(s),
                );
              },
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildBottomSheet() {
    if (_places.isEmpty) return const SizedBox.shrink();
    return Positioned(
      bottom: 20, left: 0, right: 0, height: 180,
      child: PageView.builder(
        controller: _pageController, onPageChanged: _onCardChanged,
        itemCount: _places.length,
        itemBuilder: (context, index) {
          final place = _places[index];
          final lat = (place['geometry']['location']['lat'] as num).toDouble();
          final lng = (place['geometry']['location']['lng'] as num).toDouble();
          final distance = Geolocator.distanceBetween(_currentLat, _currentLng, lat, lng);
          final distanceText = distance > 1000 ? '${(distance / 1000).toStringAsFixed(2)} Km' : '${distance.toStringAsFixed(0)} m';
          final photoRef = (place['photos'] as List?)?.isNotEmpty == true ? place['photos'][0]['photo_reference'] as String? : null;
          final photoUrl = _photoUrl(photoRef);
          final isOpen = place['opening_hours']?['open_now'];
          final openText = isOpen == true ? '🟢 Đang mở' : isOpen == false ? '🔴 Đã đóng' : '🕐 Không rõ';

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Row(children: [
              Container(
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                ),
                clipBehavior: Clip.hardEdge,
                child: photoUrl.isNotEmpty
                    ? Image.network(photoUrl, fit: BoxFit.cover, width: 110,
                        errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 40, color: Colors.grey))
                    : const Center(child: Icon(Icons.pets, size: 40, color: Colors.grey)),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(place['rating']?.toString() ?? '—', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ]),
                  const SizedBox(height: 4),
                  Text(place['name'] ?? 'Không có tên', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('📍 $distanceText  $openText', style: const TextStyle(fontSize: 12, color: Colors.blue)),
                  const SizedBox(height: 4),
                  Text(place['vicinity'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Row(children: [
                    Expanded(child: ElevatedButton(
                      onPressed: () => _openGoogleMapsDirections(lat, lng),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0), minimumSize: const Size(0, 30)),
                      child: const Text('Chỉ đường', style: TextStyle(color: Colors.white, fontSize: 12)),
                    )),
                    const SizedBox(width: 4),
                    Expanded(child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0), minimumSize: const Size(0, 30)),
                      child: const Text('Chi tiết', style: TextStyle(fontSize: 12)),
                    )),
                  ]),
                ]),
              )),
            ]),
          );
        },
      ),
    );
  }


  Widget _buildFAB() {
    return Positioned(
      bottom: 210, right: 16,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _moveToCurrentLocation,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (!_isLoading) return const SizedBox.shrink();
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(_currentLat, _currentLng), zoom: 12.0),
          onMapCreated: _onMapCreated,
          myLocationEnabled: _locationGranted,
          myLocationButtonEnabled: false,
          markers: _markers,
          onTap: _onMapTap,
        ),
        _buildSearchBar(),
        _buildFAB(),
        _buildBottomSheet(),
        _buildLoadingIndicator(),
      ]),
    );
  }
}
