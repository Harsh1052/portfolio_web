import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;
import 'package:portfolio_web/core/theme/app_theme.dart';

/// Persists and applies the user's dark/light preference via GetX + localStorage.
///
/// **System theme detection:** On first visit (no saved preference), the
/// controller reads `prefers-color-scheme: dark` from the browser / OS.
/// Once the user explicitly toggles, their choice is persisted and takes
/// priority over the system preference on future visits.
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

    late final bool prefersDark;
    if (saved != null) {
      // User has explicitly toggled before — honour their choice.
      prefersDark = saved == 'dark';
    } else {
      // First visit — detect OS / browser preference.
      prefersDark = _detectSystemDarkMode();
      if (kDebugMode) {
        debugPrint(
          '[ThemeController] No saved preference — '
          'system prefers ${prefersDark ? "dark" : "light"} mode',
        );
      }
    }

    _isDark.value = prefersDark;
    // Apply both theme data AND theme mode — Get.changeTheme alone does NOT
    // update the themeMode on GetMaterialApp, causing the switch to silently
    // fail on Flutter Web.
    Get.changeThemeMode(prefersDark ? ThemeMode.dark : ThemeMode.light);
    Get.changeTheme(prefersDark ? AppTheme.dark : AppTheme.light);
  }

  void toggle() {
    _isDark.value = !_isDark.value;
    final nextMode = _isDark.value ? ThemeMode.dark : ThemeMode.light;
    final nextTheme = _isDark.value ? AppTheme.dark : AppTheme.light;
    Get.changeThemeMode(nextMode);
    Get.changeTheme(nextTheme);
    web.window.localStorage.setItem(
      _storageKey,
      _isDark.value ? 'dark' : 'light',
    );
  }

  /// Reads the browser's `prefers-color-scheme` media query.
  /// Returns `true` if the OS / browser is in dark mode.
  bool _detectSystemDarkMode() {
    try {
      return web.window
          .matchMedia('(prefers-color-scheme: dark)')
          .matches;
    } catch (_) {
      // Fallback for environments where matchMedia is unavailable.
      return false;
    }
  }
}

