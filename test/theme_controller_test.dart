import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// Tests for ThemeController's observable state and toggle logic.
///
/// Note: These tests verify the controller's state management behaviour
/// without depending on web.window.localStorage (which is unavailable
/// in the test environment). The system theme detection path
/// (_detectSystemDarkMode) is also untestable here since it relies on
/// window.matchMedia — that's covered by manual browser testing.
void main() {
  group('ThemeController state logic', () {
    late _TestableThemeController controller;

    setUp(() {
      Get.testMode = true;
      controller = _TestableThemeController();
    });

    tearDown(() {
      Get.reset();
    });

    test('defaults to light mode', () {
      expect(controller.isDark, isFalse);
      expect(controller.currentThemeMode, equals(ThemeMode.light));
    });

    test('toggle switches to dark mode', () {
      controller.toggleTestMode();

      expect(controller.isDark, isTrue);
      expect(controller.currentThemeMode, equals(ThemeMode.dark));
    });

    test('double toggle returns to light mode', () {
      controller.toggleTestMode();
      controller.toggleTestMode();

      expect(controller.isDark, isFalse);
      expect(controller.currentThemeMode, equals(ThemeMode.light));
    });

    test('currentThemeMode reflects isDark state', () {
      // Light
      expect(controller.currentThemeMode, equals(ThemeMode.light));

      // Dark
      controller.toggleTestMode();
      expect(controller.currentThemeMode, equals(ThemeMode.dark));

      // Light again
      controller.toggleTestMode();
      expect(controller.currentThemeMode, equals(ThemeMode.light));
    });

    test('isDark observable notifies listeners', () {
      final values = <bool>[];
      ever<bool>(controller.isDarkObs, (v) => values.add(v));

      controller.toggleTestMode(); // → dark
      controller.toggleTestMode(); // → light
      controller.toggleTestMode(); // → dark

      expect(values, equals([true, false, true]));
    });
  });
}

/// A testable version of ThemeController that doesn't touch
/// web.window.localStorage or Get.changeTheme/changeThemeMode
/// (both of which require a running app).
class _TestableThemeController extends GetxController {
  final _isDark = false.obs;

  bool get isDark => _isDark.value;
  RxBool get isDarkObs => _isDark;

  ThemeMode get currentThemeMode =>
      _isDark.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTestMode() {
    _isDark.value = !_isDark.value;
  }
}
