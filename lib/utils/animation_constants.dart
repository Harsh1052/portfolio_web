import 'dart:ui';

import 'package:flutter/material.dart';

/// Animation Constants and Utilities for Performance-Optimized Animations
/// This file contains constants, curves, and helper methods for animations
class AnimationConstants {
  // Prevent instantiation
  AnimationConstants._();

  // ==================== DURATIONS ====================

  /// Ultra fast: 100ms - for instant feedback
  static const Duration ultraFast = Duration(milliseconds: 100);

  /// Fast: 200ms - for micro-interactions
  static const Duration fast = Duration(milliseconds: 200);

  /// Normal: 300ms - default for most animations
  static const Duration normal = Duration(milliseconds: 300);

  /// Medium: 500ms - for complex transitions
  static const Duration medium = Duration(milliseconds: 500);

  /// Slow: 800ms - for elaborate animations
  static const Duration slow = Duration(milliseconds: 800);

  /// Very slow: 1200ms - for page transitions
  static const Duration verySlow = Duration(milliseconds: 1200);

  /// Shimmer effect duration
  static const Duration shimmer = Duration(milliseconds: 1500);

  /// Pulse effect duration
  static const Duration pulse = Duration(milliseconds: 1000);

  /// Float effect duration
  static const Duration float = Duration(milliseconds: 3000);

  // ==================== STAGGER DELAYS ====================

  /// Tiny delay: 50ms - for closely spaced items
  static const Duration staggerTiny = Duration(milliseconds: 50);

  /// Small delay: 80ms - for grid items
  static const Duration staggerSmall = Duration(milliseconds: 80);

  /// Medium delay: 100ms - for list items
  static const Duration staggerMedium = Duration(milliseconds: 100);

  /// Large delay: 150ms - for sections
  static const Duration staggerLarge = Duration(milliseconds: 150);

  // ==================== VISIBILITY THRESHOLDS ====================

  /// Minimal visibility before triggering animation
  static const double visibilityMinimal = 0.05;

  /// Low visibility threshold
  static const double visibilityLow = 0.1;

  /// Medium visibility threshold (default)
  static const double visibilityMedium = 0.2;

  /// High visibility threshold
  static const double visibilityHigh = 0.4;

  /// Full visibility required
  static const double visibilityFull = 0.8;

  // ==================== ANIMATION CURVES ====================

  /// Standard easing - balanced acceleration and deceleration
  static const Curve easeInOut = Curves.easeInOut;

  /// Emphasized easing - smooth and natural
  static const Curve easeOutCubic = Curves.easeOutCubic;

  /// Emphasized deceleration - elements entering
  static const Curve easeOut = Curves.easeOut;

  /// Emphasized acceleration - elements leaving
  static const Curve easeIn = Curves.easeIn;

  /// Bouncy effect - playful animations
  static const Curve easeOutBack = Curves.easeOutBack;

  /// Elastic effect - spring-like animations
  static const Curve elasticOut = Curves.elasticOut;

  /// Fast out, slow in - material design standard
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  /// Linear - constant speed
  static const Curve linear = Curves.linear;

  // ==================== SCALE VALUES ====================

  /// Minimal scale change
  static const double scaleMinimal = 0.95;

  /// Small scale effect
  static const double scaleSmall = 0.9;

  /// Medium scale effect (default for scale-in)
  static const double scaleMedium = 0.8;

  /// Large scale effect
  static const double scaleLarge = 0.7;

  /// Hover scale up - subtle
  static const double hoverScaleSubtle = 1.02;

  /// Hover scale up - normal
  static const double hoverScaleNormal = 1.05;

  /// Hover scale up - emphasized
  static const double hoverScaleEmphasized = 1.08;

  // ==================== SLIDE OFFSETS ====================

  /// Minimal slide distance
  static const Offset slideMinimal = Offset(0, 0.1);

  /// Small slide distance
  static const Offset slideSmall = Offset(0, 0.2);

  /// Medium slide distance (default)
  static const Offset slideMedium = Offset(0, 0.3);

  /// Large slide distance
  static const Offset slideLarge = Offset(0, 0.5);

  /// Slide from left
  static const Offset slideFromLeft = Offset(-0.3, 0);

  /// Slide from right
  static const Offset slideFromRight = Offset(0.3, 0);

  // ==================== ROTATION VALUES ====================

  /// Minimal rotation (radians)
  static const double rotationMinimal = 0.05;

  /// Small rotation (radians)
  static const double rotationSmall = 0.1;

  /// Medium rotation (radians)
  static const double rotationMedium = 0.2;

  // ==================== PARALLAX SPEEDS ====================

  /// Very slow parallax effect
  static const double parallaxVerySlow = 0.1;

  /// Slow parallax effect
  static const double parallaxSlow = 0.2;

  /// Medium parallax effect (default)
  static const double parallaxMedium = 0.3;

  /// Fast parallax effect
  static const double parallaxFast = 0.5;

  /// Very fast parallax effect
  static const double parallaxVeryFast = 0.7;

  // ==================== BLUR VALUES ====================

  /// Minimal blur
  static const double blurMinimal = 2.0;

  /// Small blur
  static const double blurSmall = 4.0;

  /// Medium blur
  static const double blurMedium = 8.0;

  /// Large blur
  static const double blurLarge = 16.0;

  /// Extra large blur
  static const double blurXLarge = 24.0;
}

/// Custom Animation Curves
class CustomCurves {
  // Prevent instantiation
  CustomCurves._();

  /// Smooth curve for natural motion
  static const Curve smooth = Cubic(0.4, 0.0, 0.2, 1.0);

  /// Snappy curve for quick, responsive animations
  static const Curve snappy = Cubic(0.5, 0.0, 0.0, 1.0);

  /// Gentle curve for subtle animations
  static const Curve gentle = Cubic(0.25, 0.1, 0.25, 1.0);

  /// Bouncy entrance
  static const Curve bouncyEntrance = ElasticOutCurve(0.8);

  /// Overshoot curve - goes slightly beyond target
  static const Curve overshoot = Cubic(0.175, 0.885, 0.32, 1.275);
}

/// Preset animation configurations for common use cases
class AnimationPresets {
  // Prevent instantiation
  AnimationPresets._();

  // ==================== FADE ANIMATIONS ====================

  /// Quick fade in
  static const AnimationConfig fadeInQuick = AnimationConfig(
    duration: AnimationConstants.fast,
    curve: AnimationConstants.easeOut,
  );

  /// Standard fade in
  static const AnimationConfig fadeInStandard = AnimationConfig(
    duration: AnimationConstants.normal,
    curve: AnimationConstants.easeOutCubic,
  );

  /// Slow fade in
  static const AnimationConfig fadeInSlow = AnimationConfig(
    duration: AnimationConstants.medium,
    curve: AnimationConstants.easeOutCubic,
  );

  // ==================== SLIDE ANIMATIONS ====================

  /// Quick slide up
  static const AnimationConfig slideUpQuick = AnimationConfig(
    duration: AnimationConstants.fast,
    curve: AnimationConstants.easeOutCubic,
  );

  /// Standard slide up
  static const AnimationConfig slideUpStandard = AnimationConfig(
    duration: AnimationConstants.normal,
    curve: AnimationConstants.easeOutCubic,
  );

  /// Bouncy slide up
  static const AnimationConfig slideUpBouncy = AnimationConfig(
    duration: AnimationConstants.medium,
    curve: AnimationConstants.easeOutBack,
  );

  // ==================== SCALE ANIMATIONS ====================

  /// Quick scale in
  static const AnimationConfig scaleInQuick = AnimationConfig(
    duration: AnimationConstants.fast,
    curve: AnimationConstants.easeOutCubic,
  );

  /// Standard scale in
  static const AnimationConfig scaleInStandard = AnimationConfig(
    duration: AnimationConstants.normal,
    curve: AnimationConstants.easeOutBack,
  );

  /// Bouncy scale in
  static const AnimationConfig scaleInBouncy = AnimationConfig(
    duration: AnimationConstants.medium,
    curve: AnimationConstants.elasticOut,
  );

  // ==================== HOVER ANIMATIONS ====================

  /// Subtle hover effect
  static const AnimationConfig hoverSubtle = AnimationConfig(
    duration: AnimationConstants.fast,
    curve: AnimationConstants.easeOutCubic,
  );

  /// Standard hover effect
  static const AnimationConfig hoverStandard = AnimationConfig(
    duration: AnimationConstants.normal,
    curve: AnimationConstants.easeOutCubic,
  );

  // ==================== PAGE TRANSITIONS ====================

  /// Fade page transition
  static const AnimationConfig pageTransitionFade = AnimationConfig(
    duration: AnimationConstants.normal,
    curve: AnimationConstants.fastOutSlowIn,
  );

  /// Slide page transition
  static const AnimationConfig pageTransitionSlide = AnimationConfig(
    duration: AnimationConstants.medium,
    curve: AnimationConstants.easeOutCubic,
  );

  /// Scale page transition
  static const AnimationConfig pageTransitionScale = AnimationConfig(
    duration: AnimationConstants.medium,
    curve: AnimationConstants.easeOutCubic,
  );
}

/// Animation configuration class
class AnimationConfig {
  final Duration duration;
  final Curve curve;
  final Duration? delay;

  const AnimationConfig({
    required this.duration,
    required this.curve,
    this.delay,
  });

  /// Copy with modifications
  AnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    Duration? delay,
  }) {
    return AnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
    );
  }
}

/// Performance optimization utilities
class AnimationOptimization {
  // Prevent instantiation
  AnimationOptimization._();

  /// Wrap a widget with RepaintBoundary for isolation
  static Widget isolateRepaints(Widget child) {
    return RepaintBoundary(child: child);
  }

  /// Create an optimized AnimatedBuilder
  static Widget optimizedBuilder({
    required Animation<double> animation,
    required Widget Function(BuildContext, Animation<double>) builder,
    Widget? child,
  }) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) => builder(context, animation),
        child: child,
      ),
    );
  }

  /// Check if reduced motion is preferred (accessibility)
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get adjusted duration based on accessibility settings
  static Duration getAdjustedDuration(
    BuildContext context,
    Duration duration,
  ) {
    if (shouldReduceMotion(context)) {
      return Duration.zero;
    }
    return duration;
  }

  /// Get adjusted curve based on accessibility settings
  static Curve getAdjustedCurve(BuildContext context, Curve curve) {
    if (shouldReduceMotion(context)) {
      return Curves.linear;
    }
    return curve;
  }
}

/// Shader warmup helper to prevent jank on first animation
class ShaderWarmup {
  // Prevent instantiation
  ShaderWarmup._();

  /// Precompile common shaders to avoid jank
  static Future<void> warmupShaders() async {
    // Warmup gradient shader
    await _warmupGradient();

    // Warmup blur shader
    await _warmupBlur();

    // Warmup shadow shader
    await _warmupShadow();
  }

  static Future<void> _warmupGradient() async {
    final canvas = PictureRecorder();
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.blue, Colors.purple],
      ).createShader(const Rect.fromLTWH(0, 0, 100, 100));

    Canvas(canvas).drawRect(
      const Rect.fromLTWH(0, 0, 100, 100),
      paint,
    );
    canvas.endRecording();
  }

  static Future<void> _warmupBlur() async {
    final canvas = PictureRecorder();
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    Canvas(canvas).drawRect(
      const Rect.fromLTWH(0, 0, 100, 100),
      paint,
    );
    canvas.endRecording();
  }

  static Future<void> _warmupShadow() async {
    final canvas = PictureRecorder();
    final paint = Paint()
      ..color = Colors.black
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    Canvas(canvas).drawRect(
      const Rect.fromLTWH(0, 0, 100, 100),
      paint,
    );
    canvas.endRecording();
  }
}

/// Animation state manager for complex sequences
class AnimationSequence {
  final List<AnimationConfig> _sequence;
  int _currentIndex = 0;

  AnimationSequence(this._sequence);

  /// Get current animation config
  AnimationConfig get current => _sequence[_currentIndex];

  /// Move to next animation in sequence
  bool next() {
    if (_currentIndex < _sequence.length - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }

  /// Reset to beginning
  void reset() {
    _currentIndex = 0;
  }

  /// Check if sequence is complete
  bool get isComplete => _currentIndex >= _sequence.length - 1;

  /// Get total sequence duration
  Duration get totalDuration {
    return _sequence.fold(
      Duration.zero,
      (total, config) =>
          total + config.duration + (config.delay ?? Duration.zero),
    );
  }
}
