import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Theme Controller using GetX for managing app theme state
/// Handles theme switching between light and dark modes with persistence
class ThemeController extends GetxController {
  // Observable theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode.value;

  /// Check if current theme is dark
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return Get.isDarkMode;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  /// Check if current theme is light
  bool get isLightMode {
    if (_themeMode.value == ThemeMode.system) {
      return !Get.isDarkMode;
    }
    return _themeMode.value == ThemeMode.light;
  }

  /// Check if using system theme
  bool get isSystemMode => _themeMode.value == ThemeMode.system;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  /// Load theme mode from storage (can be enhanced with shared_preferences)
  void _loadThemeMode() {
    // For now, default to system theme
    // In a real app, you would load this from SharedPreferences
    _themeMode.value = ThemeMode.system;
  }

  /// Save theme mode to storage (can be enhanced with shared_preferences)
  Future<void> _saveThemeMode(ThemeMode mode) async {
    // In a real app, you would save this to SharedPreferences
    // Example:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('theme_mode', mode.toString());
  }

  /// Set theme mode to light
  Future<void> setLightMode() async {
    _themeMode.value = ThemeMode.light;
    Get.changeThemeMode(ThemeMode.light);
    await _saveThemeMode(ThemeMode.light);
  }

  /// Set theme mode to dark
  Future<void> setDarkMode() async {
    _themeMode.value = ThemeMode.dark;
    Get.changeThemeMode(ThemeMode.dark);
    await _saveThemeMode(ThemeMode.dark);
  }

  /// Set theme mode to system default
  Future<void> setSystemMode() async {
    _themeMode.value = ThemeMode.system;
    Get.changeThemeMode(ThemeMode.system);
    await _saveThemeMode(ThemeMode.system);
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (isDarkMode) {
      await setLightMode();
    } else {
      await setDarkMode();
    }
  }

  /// Set theme mode directly
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _saveThemeMode(mode);
  }
}
