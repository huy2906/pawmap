import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const clinicSvg =
    '''<svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M42 26H58C60.2091 26 62 27.7909 62 30V42H74C76.2091 42 78 43.7909 78 46V54C78 56.2091 76.2091 58 74 58H62V70C62 72.2091 60.2091 74 58 74H42C39.7909 74 38 72.2091 38 70V58H26C23.7909 58 22 56.2091 22 54V46C22 43.7909 23.7909 42 26 42H38V30C38 27.7909 39.7909 26 42 26Z" stroke="white" stroke-width="4" stroke-linejoin="round" fill="none"/>
  <path d="M50 56C50 56 42 49 42 44C42 40.5 45.5 38 48 40.5L50 43L52 40.5C54.5 38 58 40.5 58 44C58 49 50 56 50 56Z" fill="#E87A3D"/>
</svg>''';

const spaSvg =
    '''<svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 72C40 72 36 66 36 60C36 55 42 53 42 53C42 53 46 56 50 56C54 56 58 53 58 53C58 53 64 55 64 60C64 66 60 72 50 72Z" stroke="white" stroke-width="3" stroke-linejoin="round" fill="none"/>
  <circle cx="36" cy="48" r="4.5" stroke="white" stroke-width="3" fill="none"/>
  <circle cx="44" cy="40" r="5" stroke="white" stroke-width="3" fill="none"/>
  <circle cx="56" cy="40" r="5" stroke="white" stroke-width="3" fill="none"/>
  <circle cx="64" cy="48" r="4.5" stroke="white" stroke-width="3" fill="none"/>
  <circle cx="36" cy="30" r="3" stroke="white" stroke-width="2.5" fill="none"/>
  <circle cx="46" cy="24" r="4" stroke="white" stroke-width="2.5" fill="none"/>
  <circle cx="60" cy="30" r="5" stroke="white" stroke-width="2.5" fill="none"/>
  <circle cx="28" cy="40" r="4" stroke="white" stroke-width="2.5" fill="none"/>
</svg>''';

const hotelSvg =
    '''<svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M22 55L50 32L78 55" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
  <path d="M28 50V74C28 76.2 29.8 78 32 78H68C70.2 78 72 76.2 72 74V50" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
  <path d="M42 78V66C42 61.6 45.6 58 50 58C54.4 58 58 61.6 58 66V78" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
  <path d="M35 32C35 25 41 20 41 20C36 22 32 27 32 34C32 41 39 46 39 46C34 41 35 32 35 32Z" fill="white"/>
  <circle cx="50" cy="48" r="2.5" fill="white"/>
  <circle cx="45" cy="43" r="2" fill="white"/>
  <circle cx="50" cy="41" r="2" fill="white"/>
  <circle cx="55" cy="43" r="2" fill="white"/>
  <circle cx="55" cy="22" r="1.5" fill="white"/>
  <path d="M68 28 L69.5 32 L73.5 33 L69.5 34 L68 38 L66.5 34 L62.5 33 L66.5 32 Z" fill="white"/>
</svg>''';

const petShopSvg =
    '''<svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M28 42H72L68 76C67.5 79.5 64 82 60 82H40C36 82 32.5 79.5 32 76L28 42Z" stroke="#D29A46" stroke-width="3" stroke-linejoin="round" fill="none"/>
  <path d="M38 42V32C38 26 43 22 50 22C57 22 62 26 62 32V42" stroke="#D29A46" stroke-width="3" stroke-linecap="round" fill="none"/>
  <path d="M40 60C37 57 37 63 40 64C41 64.5 42 63 42 63H58C58 63 59 64.5 60 64C63 63 63 57 60 60C62 58 60 55 58 57C58 57 57 58 57 58H43C43 58 42 57 42 57C40 55 38 58 40 60Z" stroke="#D29A46" stroke-width="3" stroke-linejoin="round" fill="none"/>
</svg>''';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F2),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildCategorySection(),
                  const SizedBox(height: 24),
                  _buildNearbySection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    const pawSvg =
        '''<svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg">
  <ellipse cx="10"  cy="5.5" rx="3.5" ry="5"   fill="white"/>
  <ellipse cx="22"  cy="5.5" rx="3.5" ry="5"   fill="white"/>
  <ellipse cx="4.5" cy="15"  rx="3"   ry="4.5" fill="white" transform="rotate(-15 4.5 15)"/>
  <ellipse cx="27.5" cy="15" rx="3"   ry="4.5" fill="white" transform="rotate(15 27.5 15)"/>
  <path d="M16 13 C9 13 6 18.5 8 23 C10 27 12.5 26.5 16 26.5 C19.5 26.5 22 27 24 23 C26 18.5 23 13 16 13Z" fill="white"/>
</svg>''';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF8C42),
            Color(0xFFF4A261),
            Color(0xFFFDDCB5),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Bàn chân trang trí — vị trí tuyệt đối, không ảnh hưởng đến size của header
            Positioned(
              bottom: 8,
              right: 64,
              child: Opacity(
                opacity: 0.25,
                child: SvgPicture.string(
                  pawSvg,
                  width: 38,
                  height: 38,
                ),
              ),
            ),
            // Header nội dung — child này quyết định chiều cao của toàn bộ Stack
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "PawMap Vietnam",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Tìm cơ sở thú y gần bạn",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5DDD5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Row(
        children: [
          SizedBox(width: 12),
          Icon(Icons.search, color: Color(0xFFAAAAAA), size: 18),
          SizedBox(width: 8),
          Text(
            "Tìm kiếm cơ sở thú y, dịch vụ...",
            style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCategoryItem("Phòng khám", clinicSvg, const Color(0xFFFFD1B3)),
        _buildCategoryItem("Grooming", spaSvg, const Color(0xFFC3E8C3)),
        _buildCategoryItem("Hotel", hotelSvg, const Color(0xFFCFAEEA)),
        _buildCategoryItem("Pet Shop", petShopSvg, const Color(0xFFFFEDAC)),
      ],
    );
  }

  Widget _buildCategoryItem(String label, String svgString, Color bgColor) {
    return CategoryItem(label: label, svgString: svgString, bgColor: bgColor);
  }

  Widget _buildNearbySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Gần bạn",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ),
        const NearbyItemCard(),
      ],
    );
  }
}

class CategoryItem extends StatefulWidget {
  final String label;
  final String svgString;
  final Color bgColor;

  const CategoryItem({
    super.key,
    required this.label,
    required this.svgString,
    required this.bgColor,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: SvgPicture.string(widget.svgString, width: 52, height: 52),
            ),
            const SizedBox(height: 7),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NearbyItemCard extends StatefulWidget {
  const NearbyItemCard({super.key});

  @override
  State<NearbyItemCard> createState() => _NearbyItemCardState();
}

class _NearbyItemCardState extends State<NearbyItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEDE6DC)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E5),
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: SvgPicture.string(clinicSvg, width: 22, height: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phòng khám thú y PetCare",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3E2F),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Cách bạn 2.5 km",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFCCCCCC),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
