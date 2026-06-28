import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;
import 'app_theme.dart';

/// Persists and applies the user's dark/light preference via GetX + localStorage.
class ThemeController extends GetxController {
  static const _storageKey = 'theme_mode';

  final _isDark = false.obs;

  bool get isDark => _isDark.value;

  ThemeMode get currentThemeMode =>
      _isDark.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadSavedPreference();
  }

  void _loadSavedPreference() {
    final saved = web.window.localStorage.getItem(_storageKey);
    final prefersDark = saved == 'dark';
    _isDark.value = prefersDark;
    // Apply immediately — GetMaterialApp is already built with the initial theme;
    // this ensures the controller state stays in sync.
    Get.changeTheme(prefersDark ? AppTheme.dark : AppTheme.light);
  }

  void toggle() {
    _isDark.value = !_isDark.value;
    final nextTheme = _isDark.value ? AppTheme.dark : AppTheme.light;
    Get.changeTheme(nextTheme);
    web.window.localStorage.setItem(
      _storageKey,
      _isDark.value ? 'dark' : 'light',
    );
  }
}
