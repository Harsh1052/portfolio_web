import 'package:flutter/widgets.dart';

/// Centralized spacing tokens used across the portfolio.
///
/// Using named constants instead of magic numbers makes the design system
/// consistent and easily tuneable from one place. Section padding, card
/// spacing, and gaps all reference these values.
abstract final class AppSpacing {
  // ── Section-level spacing ──────────────────────────────────────────────────
  /// Vertical padding for major page sections (Hero, About, Skills, etc.)
  static const double sectionVertical = 80;

  /// Vertical padding for minor subsections / dividers
  static const double sectionVerticalSmall = 40;

  // ── Card / component spacing ──────────────────────────────────────────────
  /// Standard card internal padding
  static const double cardPadding = 24;

  /// Small internal padding (chips, tags, badges)
  static const double chipPadding = 10;

  /// Gap between cards in a grid or list
  static const double cardGap = 16;

  // ── General spacing scale ──────────────────────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // ── Button padding ────────────────────────────────────────────────────────
  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 14);

  static const EdgeInsets buttonPaddingCompact =
      EdgeInsets.symmetric(horizontal: 12, vertical: 6);
}

/// Centralized animation duration tokens.
///
/// Keeps animation timing consistent across the app and provides a single
/// place to adjust if the overall motion language changes.
abstract final class AppDurations {
  // ── Micro-interactions ────────────────────────────────────────────────────
  /// Hover effects, button state changes
  static const Duration instant = Duration(milliseconds: 100);

  /// Toggles, icon swaps, color transitions
  static const Duration fast = Duration(milliseconds: 200);

  /// Fade-ins, slide-ins, card reveals
  static const Duration medium = Duration(milliseconds: 350);

  /// Section reveals, page transitions
  static const Duration slow = Duration(milliseconds: 480);

  /// Welcome toast entrance
  static const Duration entrance = Duration(milliseconds: 550);

  /// Greeting / toast display animation
  static const Duration greeting = Duration(milliseconds: 700);

  // ── Long-running ──────────────────────────────────────────────────────────
  /// Toast auto-dismiss delay
  static const Duration toastDismiss = Duration(seconds: 8);

  /// Analytics flush interval
  static const Duration analyticsFlush = Duration(seconds: 8);

  /// Network request timeout
  static const Duration networkTimeout = Duration(milliseconds: 3000);

  /// Ambient animation cycle (particles, weather)
  static const Duration ambientCycle = Duration(seconds: 10);

  /// Clock refresh interval
  static const Duration clockRefresh = Duration(minutes: 1);
}

/// Centralized border radius tokens.
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double round = 999;
}
