import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static const double globalCircularRadius = 24.0;

  static ThemeData customTheme(Color seedColor, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
        surface: brightness == Brightness.light ? AppColors.background : const Color(0xFF0F172A),
      ),
      scaffoldBackgroundColor: brightness == Brightness.light ? AppColors.background : const Color(0xFF0F172A),
      cardTheme: CardThemeData(
        elevation: 6,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(globalCircularRadius)),
        color: brightness == Brightness.light ? Colors.white : const Color(0xFF1E293B),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(globalCircularRadius)),
        ),
      ),
    );
  }
}
