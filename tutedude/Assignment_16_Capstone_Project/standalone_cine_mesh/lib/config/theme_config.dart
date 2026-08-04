// D:\standalone_cine_mesh\lib\config\theme_config.dart
import 'package:flutter/material.dart';

class CinemaMeshTheme {
  static const Color primaryNeonRed   = Color(0xFFFF2E93);
  static const Color deepSpaceBlack   = Color(0xFF0A0E17);
  static const Color surfaceSlate     = Color(0xFF1E2638);
  static const Color crispPureWhite   = Color(0xFFFFFFFF);
  static const Color darkTextGrey     = Color(0xFF1C1B1F);
  static const Color amberGold        = Color(0xFFFFB300);
  static const Color electricBlue     = Color(0xFF2979FF);
  static const Color emeraldGreen     = Color(0xFF00E676);
  static const Color warningOrange    = Color(0xFFFF9100);
  static const Color errorCrimson     = Color(0xFFFF1744);
  static const Color mutedSubtleGrey  = Color(0xFF90A4AE);
  static const Color fluidPurple      = Color(0xFF7C4DFF);

  static const Map<String, Color> colorPaletteMap = {
    "Neon Red": primaryNeonRed,
    "Deep Space": deepSpaceBlack,
    "Slate Panel": surfaceSlate,
    "Pure White": crispPureWhite,
    "Charcoal": darkTextGrey,
    "Amber Gold": amberGold,
    "Electric Blue": electricBlue,
    "Emerald": emeraldGreen,
    "Orange": warningOrange,
    "Crimson": errorCrimson,
    "Muted Grey": mutedSubtleGrey,
    "Fluid Purple": fluidPurple,
  };

  static ThemeData generateTheme(Brightness brightness, Color accentColor) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      brightness: brightness,
      primaryColor: accentColor,
      scaffoldBackgroundColor: isDark ? deepSpaceBlack : const Color(0xFFF4F6F9),
      cardColor: isDark ? surfaceSlate : crispPureWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? surfaceSlate : accentColor,
        foregroundColor: crispPureWhite,
      ),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: accentColor,
        onPrimary: crispPureWhite,
        secondary: accentColor, // Binds accent color to floating items/buttons
        onSecondary: crispPureWhite,
        error: errorCrimson,
        onError: crispPureWhite,
        surface: isDark ? surfaceSlate : crispPureWhite,
        onSurface: isDark ? crispPureWhite : darkTextGrey,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: accentColor, width: 2)),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
