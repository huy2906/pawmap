import 'package:flutter/material.dart';
import 'package:trackasia_gl/trackasia_gl.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cấu hình custom header cho TrackAsia Map SDK
  await setHttpHeaders({"T-BUNDLE-ID": "com.example.pawmap_vietnam"});
  
  runApp(const PawMapApp());
}

class PawMapApp extends StatelessWidget {
  const PawMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawMap Vietnam',
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
