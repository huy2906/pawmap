import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../config/api_keys.dart';
import '../utils/app_icons.dart';

// Missing SVGs added locally for Map Screen
const String _pawGlyphGreen = '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><ellipse cx="6.2" cy="9.5" rx="2.1" ry="2.7" fill="#8DC63F"/><ellipse cx="17.8" cy="9.5" rx="2.1" ry="2.7" fill="#8DC63F"/><ellipse cx="9.5" cy="5.5" rx="1.7" ry="2.3" fill="#8DC63F"/><ellipse cx="14.5" cy="5.5" rx="1.7" ry="2.3" fill="#8DC63F"/><path d="M12 11.5c-3.2 0-5.6 2.3-5.6 4.9 0 2 1.6 3.4 3.5 3.4 1 0 1.4-.4 2.1-.4s1.1.4 2.1.4c1.9 0 3.5-1.4 3.5-3.4 0-2.6-2.4-4.9-5.6-4.9Z" fill="#8DC63F"/></svg>''';
const String _recenterIcon = '''<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 2v3M12 19v3M2 12h3M19 12h3" stroke="#0F2740" stroke-width="2" stroke-linecap="round"/><circle cx="12" cy="12" r="6" stroke="#0F2740" stroke-width="2"/><circle cx="12" cy="12" r="2" fill="#1B6FB5"/></svg>''';
const String _filterLinesIcon = '''<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4 6h16M7 12h10M10 18h4" stroke="#0F2740" stroke-width="2" stroke-linecap="round"/></svg>''';

class MapScreen extends StatefulWidget {
  final bool autoFocusSearch;
  final String? searchType;
  final String? searchKeyword;

  const MapScreen({
    super.key,
    this.autoFocusSearch = false,
    this.searchType,
    this.searchKeyword,
  });
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  bool _locationGranted = false;
  double _currentLat = 10.7769;
  double _currentLng = 106.7009;
  String _locationText = "Đang tải vị trí...";

  List<dynamic> _places = [];
  bool _isLoading = false;
  int _selectedPlaceIndex = -1;

  Set<Marker> _markers = {};
  BitmapDescriptor? _customMarkerIcon;
  BitmapDescriptor? _selectedMarkerIcon;

  Timer? _debounce;
  List<dynamic> _autocompleteResults = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _filter = 'all';

  late AnimationController _pulseController;
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    
    _loadCustomMarker();
    _checkLocationPermission();
    if (widget.autoFocusSearch) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _searchFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _mapController?.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomMarker() async {
    final icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(80, 80)),
      'assets/images/paw_marker.png',
    );
    final selectedIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(110, 110)),
      'assets/images/paw_marker.png',
    );
    
    if (mounted) {
      setState(() {
        _customMarkerIcon = icon;
        _selectedMarkerIcon = selectedIcon;
      });
    }
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

  void _onMapTap(LatLng position) {
    setState(() => _selectedPlaceIndex = -1);
    _buildMarkers(_places);
  }

  Future<void> _fetchCurrentDistrict(double lat, double lng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?latlng=$lat,$lng&language=vi&key=${ApiKeys.googlePlacesKey}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final results = data['results'] as List<dynamic>;
          if (results.isNotEmpty) {
            final addressComponents = results[0]['address_components'] as List<dynamic>;
            String? districtName;
            String? cityName;
            for (var component in addressComponents) {
              final types = component['types'] as List<dynamic>;
              if (types.contains('administrative_area_level_2')) {
                districtName = component['long_name'];
              }
              if (types.contains('administrative_area_level_1')) {
                cityName = component['long_name'];
              }
            }
            if (mounted) {
              if (districtName != null && cityName != null) {
                setState(() => _locationText = '$districtName, $cityName');
              } else if (districtName != null) {
                setState(() => _locationText = districtName!);
              } else {
                setState(() => _locationText = 'Vị trí hiện tại');
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Geocode Error: $e');
    }
  }

  Future<void> _moveToCurrentLocation() async {
    if (_locationGranted) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        double lat = position.latitude;
        double lng = position.longitude;
        if (lat < 8.0 || lat > 23.5 || lng < 102.0 || lng > 109.5) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vị trí nằm ngoài Việt Nam, dùng mặc định TP.HCM.'), duration: Duration(seconds: 3)));
          lat = 10.7769; lng = 106.7009;
        }
        _currentLat = lat; _currentLng = lng;
        _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 14.0)));
        await _fetchCurrentDistrict(lat, lng);
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

    String type = widget.searchType ?? 'veterinary_care|pet_store';
    String keyword = widget.searchKeyword != null ? '&keyword=${Uri.encodeComponent(widget.searchKeyword!)}' : '';

    if (_filter == 'vet') {
      type = 'veterinary_care';
      keyword = '';
    } else if (_filter == 'groom') {
      type = 'pet_store';
      keyword = '&keyword=spa|grooming';
    } else if (_filter == 'hotel') {
      type = 'lodging';
      keyword = '&keyword=pet|khách sạn thú cưng';
    } else if (_filter == 'shop') {
      type = 'pet_store';
      keyword = '';
    }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=$lat,$lng&radius=5000&type=$type$keyword&language=vi&key=${ApiKeys.googlePlacesKey}',
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
        }
      } else {
        setState(() => _isLoading = false);
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
      final isSelected = i == _selectedPlaceIndex;
      
      markers.add(Marker(
        markerId: MarkerId(place['place_id'] ?? 'place_$i'),
        position: LatLng(lat, lng),
        icon: isSelected ? (_selectedMarkerIcon ?? BitmapDescriptor.defaultMarker) : (_customMarkerIcon ?? BitmapDescriptor.defaultMarker),
        zIndexInt: isSelected ? 2 : 1,
        onTap: () => _onMarkerTap(i),
      ));
    }
    setState(() => _markers = markers);
  }

  void _onMarkerTap(int index) {
    setState(() => _selectedPlaceIndex = index);
    final lat = (_places[index]['geometry']['location']['lat'] as num).toDouble();
    final lng = (_places[index]['geometry']['location']['lng'] as num).toDouble();
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 16.0)));
    _buildMarkers(_places);
    
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        0.5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
    if (query.isEmpty) { setState(() { _autocompleteResults = []; }); return; }
    _debounce = Timer(const Duration(milliseconds: 300), () => _fetchAutocomplete(query));
  }

  Future<void> _fetchAutocomplete(String query) async {
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
          setState(() { _autocompleteResults = data['predictions'] as List<dynamic>? ?? []; });
        } else {
          setState(() { _autocompleteResults = []; });
        }
      } else {
        setState(() { _autocompleteResults = []; });
      }
    } catch (e) {
      debugPrint('Lỗi Autocomplete: $e');
      setState(() { _autocompleteResults = []; });
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

  Widget _buildTopBar() {
    return Positioned(
      top: 58,
      left: 14,
      right: 14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(15, 39, 64, 0.12),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: SvgPicture.string(
                  AppIcons.pawGlyphWhite.replaceAll('#ffffff', '#8DC63F'),
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vị trí hiện tại',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF5A6B7C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.string(AppIcons.locationDotIcon, width: 12, height: 12),
                      const SizedBox(width: 4),
                      Text(
                        _locationText,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F2740),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF0F2740)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(15, 39, 64, 0.12),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: SvgPicture.string(AppIcons.bellIconDot.replaceAll('#ffffff', '#0F2740'), width: 18, height: 18),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 108,
      left: 14,
      right: 14,
      child: Column(
        children: [
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(15, 39, 64, 0.13),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                SvgPicture.string(AppIcons.searchIcon, width: 18, height: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (v) {
                      setState(() {});
                      _onSearchChanged(v);
                    },
                    onSubmitted: (v) {
                      if (v.isNotEmpty) _fetchAutocomplete(v);
                    },
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Tìm trên bản đồ…',
                      hintStyle: TextStyle(color: Color(0xFF0F2740), fontSize: 13.5),
                    ),
                    style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F2740)),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                      setState(() => _autocompleteResults = []);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.clear, color: Colors.grey, size: 18),
                    ),
                  ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4FAE5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      final t = _searchController.text;
                      if (t.isNotEmpty) {
                        _searchFocusNode.unfocus();
                        _fetchAutocomplete(t);
                      }
                    },
                    child: SvgPicture.string(_pawGlyphGreen, width: 18, height: 18),
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
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Color.fromRGBO(15, 39, 64, 0.13), blurRadius: 22, offset: Offset(0, 10)),
                ],
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                itemCount: _autocompleteResults.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final s = _autocompleteResults[index];
                  final main = s['structured_formatting']?['main_text'] ?? s['description'] ?? '';
                  final secondary = s['structured_formatting']?['secondary_text'] ?? '';
                  return ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.grey),
                    title: Text(main, style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F2740))),
                    subtitle: secondary.isNotEmpty ? Text(secondary, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)) : null,
                    onTap: () => _onSuggestionSelected(s),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      right: 14,
      bottom: 24,
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Color.fromRGBO(15, 39, 64, 0.18), blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: IconButton(
              icon: SvgPicture.string(_recenterIcon, width: 20, height: 20),
              onPressed: _moveToCurrentLocation,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Color.fromRGBO(15, 39, 64, 0.18), blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: IconButton(
              icon: SvgPicture.string(_filterLinesIcon, width: 20, height: 20),
              onPressed: () {
                if (_sheetController.isAttached) {
                  _sheetController.animateTo(0.6, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                }
              },
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.28,
      minChildSize: 0.15,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(15, 39, 64, 0.08), blurRadius: 20, offset: Offset(0, -6)),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8E0E8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip('all', 'Tất cả', null),
                    _buildChip('vet', 'Phòng khám', AppIcons.vetIcon),
                    _buildChip('groom', 'Grooming', AppIcons.groomingIcon),
                    _buildChip('hotel', 'Khách sạn', AppIcons.hotelIcon),
                    _buildChip('shop', 'Pet Shop', AppIcons.shopIcon),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                '${_places.length} địa điểm gần bạn',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F2740)),
              ),
              const SizedBox(height: 2),
              const Text(
                'Sắp xếp theo khoảng cách',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF5A6B7C)),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B6FB5)))
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 24, top: 4),
                      itemCount: _places.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _buildPlaceCard(index);
                      },
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String id, String label, String? iconSvg) {
    final isActive = _filter == id;
    return GestureDetector(
      onTap: () {
        setState(() => _filter = id);
        _fetchNearbyPlaces(_currentLat, _currentLng);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE6F0F9) : const Color(0xFFF2F5F8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: isActive ? const Color(0xFF1B6FB5) : Colors.transparent),
        ),
        child: Row(
          children: [
            if (iconSvg != null) ...[
              SvgPicture.string(iconSvg, width: 14, height: 14),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isActive ? const Color(0xFF1B6FB5) : const Color(0xFF0F2740),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceCard(int index) {
    final place = _places[index];
    final isSelected = index == _selectedPlaceIndex;
    
    final lat = (place['geometry']['location']['lat'] as num).toDouble();
    final lng = (place['geometry']['location']['lng'] as num).toDouble();
    final distance = Geolocator.distanceBetween(_currentLat, _currentLng, lat, lng);
    final distanceText = distance > 1000 ? '${(distance / 1000).toStringAsFixed(1)} km' : '${distance.toStringAsFixed(0)} m';
    
    final isOpen = place['opening_hours']?['open_now'];
    String tag = 'Dịch vụ thú cưng';
    Color hue = const Color(0xFFE6F0F9);
    String iconSvg = AppIcons.vetIcon;

    if (place['types'] != null) {
      final types = place['types'] as List;
      if (types.contains('veterinary_care')) { tag = 'Phòng khám'; hue = const Color(0xFFE6F0F9); iconSvg = AppIcons.vetIcon; }
      else if (types.contains('pet_store')) { tag = 'Pet Shop'; hue = const Color(0xFFEAF6D9); iconSvg = AppIcons.shopIcon; }
      else if (types.contains('lodging')) { tag = 'Khách sạn'; hue = const Color(0xFFE6F0F9); iconSvg = AppIcons.hotelIcon; }
    }

    if (isOpen == true) {
      tag += ' · Đang mở cửa';
    } else if (isOpen == false) {
      tag += ' · Đã đóng cửa';
    }

    return GestureDetector(
      onTap: () {
        _onMarkerTap(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromRGBO(230, 240, 249, 0.6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B6FB5) : const Color.fromRGBO(15, 39, 64, 0.08),
          ),
          boxShadow: isSelected ? const [
            BoxShadow(color: Color.fromRGBO(27, 111, 181, 0.15), blurRadius: 14, offset: Offset(0, 4))
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: hue,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: SvgPicture.string(iconSvg, width: 28, height: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place['name'] ?? 'Không có tên',
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFF0F2740)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 7, height: 7,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: BoxDecoration(color: const Color(0xFF8DC63F), borderRadius: BorderRadius.circular(99)),
                        )
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(tag, style: const TextStyle(fontSize: 12, color: Color(0xFF5A6B7C))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SvgPicture.string(AppIcons.starIcon, width: 11, height: 11),
                      const SizedBox(width: 3),
                      Text(place['rating']?.toString() ?? '—', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF0F2740))),
                      const SizedBox(width: 10),
                      Container(width: 3, height: 3, decoration: BoxDecoration(color: const Color(0xFFC8D1DA), borderRadius: BorderRadius.circular(99))),
                      const SizedBox(width: 10),
                      Text(distanceText, style: const TextStyle(fontSize: 11.5, color: Color(0xFF5A6B7C))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => _openGoogleMapsDirections(lat, lng),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B6FB5),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                minimumSize: const Size(0, 32),
              ),
              child: const Text('Đặt', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(_currentLat, _currentLng), zoom: 12.0),
              onMapCreated: _onMapCreated,
              myLocationEnabled: _locationGranted,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: _markers,
              onTap: _onMapTap,
            ),
          ),
          
          _buildTopBar(),
          _buildSearchBar(),
          _buildBottomSheet(),
          _buildMapControls(),
        ],
      ),
    );
  }
}
