import 'package:flutter/material.dart';

class AppTheme {
  // New Color Palette
  static const Color primaryMint = Color(0xFFA8E6CF);
  static const Color primaryMintDark = Color(0xFF81C784); // A bit darker for text/icons
  static const Color secondaryCoral = Color(0xFFFF8A65);
  static const Color backgroundCream = Color(0xFFFDFAF6);
  static const Color surfaceCream = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF4A4A4A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundCream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryMint,
        primary: primaryMintDark,
        secondary: secondaryCoral,
        surface: surfaceCream,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundCream,
        foregroundColor: textDark,
        iconTheme: IconThemeData(color: textDark),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryCoral,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryMintDark,
        unselectedItemColor: Colors.grey,
        backgroundColor: surfaceCream,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      cardTheme: CardThemeData(
        elevation: 0, // Using custom shadows in soft-UI
        color: surfaceCream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMintDark,
          foregroundColor: Colors.white,
          elevation: 0, // Soft UI usually relies on subtle shadows
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textDark),
        bodyMedium: TextStyle(color: textDark),
        titleLarge: TextStyle(color: textDark, fontWeight: FontWeight.bold),
      ),
    );
  }
}
