import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_icons.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'appointments_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final Set<int> _visitedTabs = {0};

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen(
          onNavigateToMap: () {
            setState(() {
              _currentIndex = 1;
              _visitedTabs.add(1);
            });
          },
        );
      case 1:
        return const MapScreen();
      case 2:
        return const AppointmentsScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(4, (index) {
          final bool isVisited = _visitedTabs.contains(index);
          final bool isActive = _currentIndex == index;
          return Offstage(
            offstage: !isActive,
            child: isVisited ? _buildScreen(index) : const SizedBox.shrink(),
          );
        }),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      height: 76 + bottomPadding,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(15, 39, 64, 0.06),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(15, 39, 64, 0.05),
            blurRadius: 18,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(4, 8, 4, 14 + bottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'Trang chủ', AppIcons.homeLineIconOutline, AppIcons.homeLineIconFilled),
          _buildNavItem(1, 'Bản đồ', AppIcons.mapLineIconOutline, AppIcons.mapLineIconFilled),
          _buildNavItem(2, 'Lịch hẹn', AppIcons.calendarLineIconOutline, AppIcons.calendarLineIconFilled),
          _buildNavItem(3, 'Hồ sơ', AppIcons.profileLineIconOutline, AppIcons.profileLineIconFilled),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String outlineIcon, String filledIcon) {
    final isActive = _currentIndex == index;
    final color = isActive ? const Color(0xFF1B6FB5) : const Color(0xFF9AA7B4);
    
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _visitedTabs.add(index);
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                SvgPicture.string(
                  isActive ? filledIcon : outlineIcon,
                  width: 24,
                  height: 24,
                ),
                if (isActive)
                  Positioned(
                    top: -8,
                    child: Container(
                      width: 24,
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B6FB5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: color,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
