import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/app_icons.dart';
import '../config/api_keys.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToMap;
  
  const HomeScreen({super.key, this.onNavigateToMap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String _locationText = 'Đang tải vị trí...';
  List<dynamic> _places = [];
  double _currentLat = 10.7769; // Default HCM
  double _currentLng = 106.7009;

  @override
  void initState() {
    super.initState();
    _initLocationAndData();
  }

  Future<void> _initLocationAndData() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _handleLocationDenied();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _handleLocationDenied();
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _handleLocationDenied();
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      _currentLat = position.latitude;
      _currentLng = position.longitude;
      await _fetchCurrentDistrict(_currentLat, _currentLng);
      await _fetchNearbyPlaces(_currentLat, _currentLng);
    } catch (e) {
      _handleLocationDenied();
    }
  }

  void _handleLocationDenied() {
    if (mounted) {
      setState(() {
        _locationText = 'Bật định vị để xem';
        _isLoading = false;
      });
      _fetchNearbyPlaces(_currentLat, _currentLng);
    }
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
                setState(() => _locationText = 'Không rõ địa điểm');
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Geocode Error: $e');
      if (mounted) {
        setState(() => _locationText = 'Lỗi tải địa điểm');
      }
    }
  }

  Future<void> _fetchNearbyPlaces(double lat, double lng) async {
    if (mounted) setState(() => _isLoading = true);

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=$lat,$lng&radius=5000&type=veterinary_care&language=vi&key=${ApiKeys.googlePlacesKey}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
          List<dynamic> results = data['results'] as List<dynamic>? ?? [];
          if (results.length > 5) {
            results = results.sublist(0, 5);
          }
          if (mounted) {
            setState(() {
              _places = results;
              _isLoading = false;
            });
          }
        } else {
          if (mounted) setState(() => _isLoading = false);
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Nearby Error: $e');
      if (mounted) setState(() => _isLoading = false);
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

  String _getPhotoUrl(String? photoRef) {
    if (photoRef == null || photoRef.isEmpty) return '';
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=400&photo_reference=$photoRef&key=${ApiKeys.googlePlacesKey}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Gradient Hero
            Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B6FB5),
                    Color(0xFF2E86CC),
                    Color(0xFF4FA3DC),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: 4,
                    child: Transform.rotate(
                      angle: -12 * pi / 180,
                      child: Opacity(
                        opacity: 0.13,
                        child: SvgPicture.string(
                          AppIcons.pawGlyphWhite,
                          width: 180,
                          height: 180,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 70,
                    top: 64,
                    child: Transform.rotate(
                      angle: 18 * pi / 180,
                      child: Opacity(
                        opacity: 0.09,
                        child: SvgPicture.string(
                          AppIcons.pawGlyphWhite,
                          width: 70,
                          height: 70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Foreground Content
            Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 70),
                    child: Column(
                      children: [
                        _buildTopRow(),
                        const SizedBox(height: 18),
                        _buildSearchBar(),
                      ],
                    ),
                  ),
                ),
                
                // Body Container
                Container(
                  transform: Matrix4.translationValues(0, -36, 0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F8FB),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildServicesSection(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildNearbySectionHeader(),
                        ),
                        _buildSpotlightContent(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.12),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: SvgPicture.string(
            AppIcons.pinGlyph,
            width: 28,
            height: 28,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'XIN CHÀO MINH',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(255, 255, 255, 0.78),
                  letterSpacing: 0.4,
                ),
              ),
              Text(
                'PawMap Vietnam',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.18),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.25),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: SvgPicture.string(
            AppIcons.bellIconDot,
            width: 20,
            height: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MapScreen(autoFocusSearch: true)),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(15, 39, 64, 0.12),
              blurRadius: 22,
              offset: Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.only(left: 14, right: 6),
        child: Row(
          children: [
            SvgPicture.string(
              AppIcons.searchIcon,
              width: 18,
              height: 18,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Tìm phòng khám, spa, pet shop…',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF0F2740),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF1B6FB5),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: SvgPicture.string(
                AppIcons.filterIcon,
                width: 14,
                height: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(String type, String keyword) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(
          searchType: type,
          searchKeyword: keyword,
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(4, 4, 4, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dịch vụ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F2740),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B6FB5),
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: CategoryCell(id: 'vet', label: 'Phòng khám', iconSvg: AppIcons.vetIcon, bgColor: const Color(0xFFE6F0F9), shadowColor: const Color.fromRGBO(27, 111, 181, 0.18), onTap: () => _navigateToCategory('veterinary_care', 'phòng khám thú y'))),
            const SizedBox(width: 10),
            Expanded(child: CategoryCell(id: 'groom', label: 'Spa & Tắm', iconSvg: AppIcons.groomingIcon, bgColor: const Color(0xFFEAF6D9), shadowColor: const Color.fromRGBO(141, 198, 63, 0.22), onTap: () => _navigateToCategory('pet_store', 'spa thú cưng|grooming thú cưng|tắm thú cưng'))),
            const SizedBox(width: 10),
            Expanded(child: CategoryCell(id: 'hotel', label: 'Khách sạn', iconSvg: AppIcons.hotelIcon, bgColor: const Color(0xFFE6F0F9), shadowColor: const Color.fromRGBO(27, 111, 181, 0.18), onTap: () => _navigateToCategory('lodging', 'khách sạn thú cưng|boarding thú cưng|nhà trọ thú cưng'))),
            const SizedBox(width: 10),
            Expanded(child: CategoryCell(id: 'shop', label: 'Pet Shop', iconSvg: AppIcons.shopIcon, bgColor: const Color(0xFFEAF6D9), shadowColor: const Color.fromRGBO(141, 198, 63, 0.22), onTap: () => _navigateToCategory('pet_store', 'pet shop|cửa hàng thú cưng'))),
          ],
        ),
      ],
    );
  }

  Widget _buildNearbySectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gần bạn',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F2740),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  SvgPicture.string(
                    AppIcons.locationDotIcon,
                    width: 11,
                    height: 11,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _locationText,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF5A6B7C),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              if (widget.onNavigateToMap != null) {
                widget.onNavigateToMap!();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: const Text(
              'Xem bản đồ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B6FB5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotlightContent() {
    if (_isLoading) {
      return const SizedBox(
        height: 280,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF1B6FB5)),
        ),
      );
    }

    if (_places.isEmpty) {
      return Container(
        height: 280,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(15, 39, 64, 0.06),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Không tìm thấy địa điểm xung quanh',
            style: TextStyle(color: Color(0xFF5A6B7C), fontSize: 14),
          ),
        ),
      );
    }

    return SizedBox(
      height: 330, // Increased height to accommodate photo and content
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: _places.length,
        itemBuilder: (context, index) {
          final place = _places[index];
          return _buildSpotlightCard(place, index);
        },
      ),
    );
  }

  Widget _buildSpotlightCard(dynamic place, int index) {
    final lat = (place['geometry']['location']['lat'] as num).toDouble();
    final lng = (place['geometry']['location']['lng'] as num).toDouble();
    final distance = Geolocator.distanceBetween(_currentLat, _currentLng, lat, lng);
    final distanceText = (distance / 1000).toStringAsFixed(1);
    
    final photoRef = (place['photos'] as List?)?.isNotEmpty == true 
        ? place['photos'][0]['photo_reference'] as String? 
        : null;
    final photoUrl = _getPhotoUrl(photoRef);
    
    final isOpen = place['opening_hours']?['open_now'];
    final openText = isOpen == true ? 'ĐANG MỞ CỬA' : (isOpen == false ? 'ĐÃ ĐÓNG CỬA' : 'KHÔNG RÕ');
    final openColor = isOpen == true ? const Color(0xFF6FA82C) : (isOpen == false ? Colors.red : Colors.grey);
    final dotColor = isOpen == true ? const Color(0xFF8DC63F) : (isOpen == false ? Colors.red : Colors.grey);

    final rating = place['rating']?.toString() ?? '—';
    final userRatingsTotal = place['user_ratings_total']?.toString() ?? '0';

    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(15, 39, 64, 0.06),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Top
            SizedBox(
              height: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (photoRef != null && photoUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: photoUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFFEAF1F7),
                        child: const Center(child: CircularProgressIndicator(color: Color(0xFF1B6FB5))),
                      ),
                      errorWidget: (context, url, error) => _buildPlaceholderMap(),
                    )
                  else
                    _buildPlaceholderMap(),
                  
                  // Badge
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '#${index + 1} Gần bạn',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F2740),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: dotColor,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          openText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: openColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      place['name'] ?? 'Không có tên',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F2740),
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${place['vicinity']} · Cách bạn $distanceText km',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF5A6B7C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        _buildTag(AppIcons.starIcon, '$rating · $userRatingsTotal đánh giá'),
                        const SizedBox(width: 8),
                        _buildTag(AppIcons.locationDotIcon, '$distanceText km'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {}, // Chi tiết
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B6FB5),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(27, 111, 181, 0.25),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Xem chi tiết',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _openGoogleMapsDirections(lat, lng),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF1B6FB5),
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Chỉ đường',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1B6FB5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderMap() {
    return Container(
      color: const Color(0xFFEAF1F7),
      child: Center(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: SvgPicture.string(
            AppIcons.vetIcon,
            width: 32,
            height: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String iconSvg, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.string(
            iconSvg,
            width: 11,
            height: 11,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F2740),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCell extends StatefulWidget {
  final String id;
  final String label;
  final String iconSvg;
  final Color bgColor;
  final Color shadowColor;
  final VoidCallback? onTap;

  const CategoryCell({
    super.key,
    required this.id,
    required this.label,
    required this.iconSvg,
    required this.bgColor,
    required this.shadowColor,
    this.onTap,
  });

  @override
  State<CategoryCell> createState() => _CategoryCellState();
}

class _CategoryCellState extends State<CategoryCell> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isActive = true),
      onTapUp: (_) => setState(() => _isActive = false),
      onTapCancel: () => setState(() => _isActive = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        transform: Matrix4.translationValues(0, _isActive ? -2 : 0, 0),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  if (_isActive)
                    BoxShadow(
                      color: widget.shadowColor,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  else
                    const BoxShadow(
                      color: Color.fromRGBO(15, 39, 64, 0.05),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                ],
              ),
              alignment: Alignment.center,
              child: SvgPicture.string(
                widget.iconSvg,
                width: 30,
                height: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F2740),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
