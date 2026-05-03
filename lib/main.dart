import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Add real Firebase initialization configuration here when available.
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
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
