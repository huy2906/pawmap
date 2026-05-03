import 'package:flutter/material.dart';
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
  // Lazy loading: chỉ khởi tạo màn hình khi người dùng lần đầu bấm vào tab
  final Set<int> _visitedTabs = {0};

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF8C42),
        unselectedItemColor: const Color(0xFFAAAAAA),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _visitedTabs.add(index);
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Bản đồ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Lịch hẹn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}
