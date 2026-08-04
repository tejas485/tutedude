import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/constants/app_colors.dart';

class ThemeController extends ChangeNotifier {
  static const String _themeModeKey = 'secure_app_theme_mode';
  static const String _colorIndexKey = 'secure_app_color_index';

  ThemeMode _themeMode = ThemeMode.system;
  int _colorIndex = 0;
  SharedPreferences? _prefs;

  ThemeMode get themeMode => _themeMode;
  Color get currentSeedColor => AppColors.palette[_colorIndex];
  int get activeColorIndex => _colorIndex;

  ThemeController() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final savedMode = _prefs?.getString(_themeModeKey);
      if (savedMode == 'light') _themeMode = ThemeMode.light;
      if (savedMode == 'dark') _themeMode = ThemeMode.dark;
      _colorIndex = _prefs?.getInt(_colorIndexKey) ?? 0;
      notifyListeners();
    } catch (_) {}
  }

  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // FIXED: Optional parameter allows legacy calling syntax to compile flawlessly
  List<BoxShadow> getNeumorphicShadow(BuildContext context, [Color? customColor]) {
    final isDark = isDarkMode(context);
    final activeColor = customColor ?? currentSeedColor;
    return [
      BoxShadow(
        color: activeColor.withValues(alpha: isDark ? 0.15 : 0.25),
        blurRadius: 16,
        offset: const Offset(4, 8),
      ),
      BoxShadow(
        color: isDark ? Colors.black38 : Colors.white.withValues(alpha: 0.6),
        blurRadius: 12,
        offset: const Offset(-2, -4),
      ),
    ];
  }

  // FIXED: Optional parameter allows legacy calling syntax to compile flawlessly
  Color getTintedSurface(BuildContext context, {double strength = 0.1, Color? customColor}) {
    final isDark = isDarkMode(context);
    final baseSurface = isDark ? const Color(0xFF1E293B) : Colors.white;
    final activeColor = customColor ?? currentSeedColor;
    return Color.alphaBlend(
      activeColor.withValues(alpha: strength),
      baseSurface,
    );
  }

  void toggleThemeMode(BuildContext context) {
    if (isDarkMode(context)) {
      _themeMode = ThemeMode.light;
      _prefs?.setString(_themeModeKey, 'light');
    } else {
      _themeMode = ThemeMode.dark;
      _prefs?.setString(_themeModeKey, 'dark');
    }
    notifyListeners();
  }

  void updateSeedColor(int index) {
    _colorIndex = index;
    _prefs?.setInt(_colorIndexKey, index);
    notifyListeners();
  }
}
