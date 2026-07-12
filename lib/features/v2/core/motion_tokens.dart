import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Motion design tokens for the City of Code — one vocabulary for every
/// scene, mirroring Wonderous's `$styles.times` approach.
abstract final class V2Motion {
  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration med = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration entrance = Duration(milliseconds: 900);

  // Curves
  static const Curve reveal = Curves.easeOutCubic;
  static const Curve parallax = Curves.easeInOutSine;
  static const Curve settle = Curves.easeOutBack;

  // Entrance stagger intervals (bg → mg → fg), Wonderous-style
  static const Interval bgInterval = Interval(0.0, 0.5, curve: reveal);
  static const Interval mgInterval = Interval(0.2, 0.8, curve: reveal);
  static const Interval fgInterval = Interval(0.4, 1.0, curve: reveal);
}

/// Reduced-motion switch — respects the OS preference and lets the visitor
/// override it. Persisted in localStorage.
class V2MotionSettings {
  V2MotionSettings._();
  static final V2MotionSettings instance = V2MotionSettings._();

  static const _storageKey = 'v2_reduced_motion';

  late final ValueNotifier<bool> reduced = ValueNotifier(_initialValue());

  bool _initialValue() {
    if (!kIsWeb) return false;
    try {
      final saved = web.window.localStorage.getItem(_storageKey);
      if (saved != null) return saved == 'true';
      return web.window
          .matchMedia('(prefers-reduced-motion: reduce)')
          .matches;
    } catch (_) {
      return false;
    }
  }

  void toggle() {
    reduced.value = !reduced.value;
    if (!kIsWeb) return;
    try {
      web.window.localStorage.setItem(_storageKey, reduced.value.toString());
    } catch (_) {
      // Safari private mode — non-fatal.
    }
  }
}
