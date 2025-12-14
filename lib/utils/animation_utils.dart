import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/design_constants.dart';

/// Helper functions for creating consistent animations throughout the app
class AnimationUtils {
  // Prevent instantiation
  AnimationUtils._();

  /// Creates a stagger animation for list items
  ///
  /// [index] - Index of the item in the list
  /// [itemCount] - Total number of items
  /// [child] - Widget to animate
  /// [delay] - Base delay before animation starts
  static Widget createStaggerAnimation({
    required int index,
    required int itemCount,
    required Widget child,
    Duration delay = const Duration(milliseconds: 100),
  }) {
    final staggerDelay = delay.inMilliseconds + (index * 100);

    return child
        .animate()
        .fadeIn(
          duration: DesignConstants.animationNormal,
          delay: Duration(milliseconds: staggerDelay),
          curve: DesignConstants.curveDecelerate,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: DesignConstants.animationNormal,
          delay: Duration(milliseconds: staggerDelay),
          curve: DesignConstants.curveDecelerate,
        );
  }

  /// Creates a scroll-triggered animation
  ///
  /// [child] - Widget to animate
  /// [delay] - Delay before animation starts
  static Widget createScrollAnimation({
    required Widget child,
    Duration delay = Duration.zero,
  }) {
    return child
        .animate()
        .fadeIn(
          duration: DesignConstants.animationSlow,
          delay: delay,
          curve: DesignConstants.curveDecelerate,
        )
        .slideY(
          begin: 0.3,
          end: 0,
          duration: DesignConstants.animationSlow,
          delay: delay,
          curve: DesignConstants.curveDecelerate,
        )
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          duration: DesignConstants.animationSlow,
          delay: delay,
          curve: DesignConstants.curveDecelerate,
        );
  }

  /// Creates a shimmer animation effect
  ///
  /// [child] - Widget to apply shimmer to
  /// [duration] - Duration of one shimmer cycle
  static Widget createShimmerAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    return child.animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: duration,
          color: Colors.white.withValues(alpha: 0.3),
          angle: 0.5,
        );
  }

  /// Creates a pulse animation effect
  ///
  /// [child] - Widget to pulse
  /// [duration] - Duration of one pulse cycle
  /// [scale] - Maximum scale factor
  static Widget createPulseAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
    double scale = 1.05,
  }) {
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1.0, 1.0),
          end: Offset(scale, scale),
          duration: duration,
          curve: Curves.easeInOut,
        );
  }

  /// Creates a floating animation effect
  ///
  /// [child] - Widget to float
  /// [duration] - Duration of one float cycle
  /// [offset] - Maximum vertical offset
  static Widget createFloatAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 3000),
    double offset = 10.0,
  }) {
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: 0,
          end: offset,
          duration: duration,
          curve: Curves.easeInOut,
        );
  }

  /// Creates a gradient text shimmer animation
  ///
  /// [child] - Text widget to animate
  /// [gradient] - Gradient to use for shimmer
  static Widget createGradientShimmer({
    required Widget child,
    Gradient gradient = AppColors.primaryGradient,
  }) {
    return child.animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: 2000.ms,
          color: Colors.white.withValues(alpha: 0.5),
        );
  }

  /// Creates a reveal animation from left
  ///
  /// [child] - Widget to reveal
  /// [delay] - Delay before animation starts
  static Widget createRevealFromLeft({
    required Widget child,
    Duration delay = Duration.zero,
  }) {
    return child
        .animate()
        .fadeIn(
          duration: DesignConstants.animationNormal,
          delay: delay,
        )
        .slideX(
          begin: -0.3,
          end: 0,
          duration: DesignConstants.animationNormal,
          delay: delay,
          curve: DesignConstants.curveDecelerate,
        );
  }

  /// Creates a reveal animation from right
  ///
  /// [child] - Widget to reveal
  /// [delay] - Delay before animation starts
  static Widget createRevealFromRight({
    required Widget child,
    Duration delay = Duration.zero,
  }) {
    return child
        .animate()
        .fadeIn(
          duration: DesignConstants.animationNormal,
          delay: delay,
        )
        .slideX(
          begin: 0.3,
          end: 0,
          duration: DesignConstants.animationNormal,
          delay: delay,
          curve: DesignConstants.curveDecelerate,
        );
  }

  /// Creates a scale-in animation
  ///
  /// [child] - Widget to scale in
  /// [delay] - Delay before animation starts
  static Widget createScaleIn({
    required Widget child,
    Duration delay = Duration.zero,
  }) {
    return child
        .animate()
        .fadeIn(
          duration: DesignConstants.animationNormal,
          delay: delay,
        )
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: DesignConstants.animationNormal,
          delay: delay,
          curve: DesignConstants.curveDecelerate,
        );
  }

  /// Creates a bounce animation
  ///
  /// [child] - Widget to bounce
  /// [delay] - Delay before animation starts
  static Widget createBounceAnimation({
    required Widget child,
    Duration delay = Duration.zero,
  }) {
    return child.animate().scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: DesignConstants.animationSlow,
          delay: delay,
          curve: Curves.elasticOut,
        );
  }

  /// Creates a rotation animation
  ///
  /// [child] - Widget to rotate
  /// [duration] - Duration of one rotation
  static Widget createRotationAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    return child.animate(onPlay: (controller) => controller.repeat()).rotate(
          begin: 0,
          end: 1,
          duration: duration,
        );
  }
}
