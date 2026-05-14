import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const PawMapApp());
}

class PawMapApp extends StatelessWidget {
  const PawMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawMap Vietnam',
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const MainNavigation(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
