import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'animation_constants.dart';

/// Custom page transitions for GetX navigation
/// Provides performance-optimized, beautiful page transitions

/// Fade transition with scale
class FadeScaleTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RepaintBoundary(
      child: FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.92,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: curve ?? Curves.easeOutCubic,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Slide from bottom with fade
class SlideFromBottomTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RepaintBoundary(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeOutCubic,
          ),
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }
}

/// Slide from right (like iOS)
class SlideFromRightTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RepaintBoundary(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeOutCubic,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Slide from left
class SlideFromLeftTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RepaintBoundary(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1.0, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeOutCubic,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Shared axis transition (Material Design)
class SharedAxisTransition extends CustomTransition {
  final SharedAxisTransitionType transitionType;

  SharedAxisTransition({
    this.transitionType = SharedAxisTransitionType.horizontal,
  });

  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final animationCurve = CurvedAnimation(
      parent: animation,
      curve: curve ?? Curves.easeInOut,
    );

    final secondaryAnimationCurve = CurvedAnimation(
      parent: secondaryAnimation,
      curve: curve ?? Curves.easeInOut,
    );

    Offset getOffset(bool isPrimary) {
      switch (transitionType) {
        case SharedAxisTransitionType.horizontal:
          return Offset(isPrimary ? 0.3 : -0.3, 0);
        case SharedAxisTransitionType.vertical:
          return Offset(0, isPrimary ? 0.3 : -0.3);
        case SharedAxisTransitionType.scaled:
          return Offset.zero;
      }
    }

    if (transitionType == SharedAxisTransitionType.scaled) {
      return RepaintBoundary(
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(animationCurve),
          child: FadeTransition(
            opacity: animationCurve,
            child: child,
          ),
        ),
      );
    }

    return RepaintBoundary(
      child: Stack(
        children: [
          // Outgoing page
          if (secondaryAnimation.value > 0)
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: getOffset(false),
              ).animate(secondaryAnimationCurve),
              child: FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0)
                    .animate(secondaryAnimationCurve),
                child: Container(),
              ),
            ),
          // Incoming page
          SlideTransition(
            position: Tween<Offset>(
              begin: getOffset(true),
              end: Offset.zero,
            ).animate(animationCurve),
            child: FadeTransition(
              opacity: animationCurve,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}

/// Fade through transition (Material Design)
class FadeThroughTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RepaintBoundary(
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
          ),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: curve ?? Curves.easeOutCubic,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Zoom transition with blur effect
class ZoomBlurTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RepaintBoundary(
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.1, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeOutCubic,
          ),
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }
}

/// Rotation transition
class RotationFadeTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RepaintBoundary(
      child: RotationTransition(
        turns: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.easeOutCubic,
          ),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: curve ?? Curves.easeOutBack,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Elastic scale transition
class ElasticScaleTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RepaintBoundary(
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.7, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve ?? Curves.elasticOut,
          ),
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }
}

/// Custom reveal transition (circular)
class CircularRevealTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return ClipPath(
            clipper: CircularRevealClipper(
              fraction: animation.value,
              alignment: alignment ?? Alignment.center,
            ),
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}

class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Alignment alignment;

  CircularRevealClipper({
    required this.fraction,
    this.alignment = Alignment.center,
  });

  @override
  Path getClip(Size size) {
    final center = alignment.alongSize(size);
    final maxRadius = (size.longestSide * 1.5) * fraction;

    final path = Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: maxRadius,
        ),
      );

    return path;
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return fraction != oldClipper.fraction || alignment != oldClipper.alignment;
  }
}

/// Page route builder utilities
class PageTransitions {
  PageTransitions._();

  /// Get transition based on type
  static CustomTransition getTransition(TransitionType type) {
    switch (type) {
      case TransitionType.fadeScale:
        return FadeScaleTransition();
      case TransitionType.slideFromBottom:
        return SlideFromBottomTransition();
      case TransitionType.slideFromRight:
        return SlideFromRightTransition();
      case TransitionType.slideFromLeft:
        return SlideFromLeftTransition();
      case TransitionType.sharedAxisHorizontal:
        return SharedAxisTransition(
          transitionType: SharedAxisTransitionType.horizontal,
        );
      case TransitionType.sharedAxisVertical:
        return SharedAxisTransition(
          transitionType: SharedAxisTransitionType.vertical,
        );
      case TransitionType.fadeThrough:
        return FadeThroughTransition();
      case TransitionType.zoomBlur:
        return ZoomBlurTransition();
      case TransitionType.rotationFade:
        return RotationFadeTransition();
      case TransitionType.elasticScale:
        return ElasticScaleTransition();
      case TransitionType.circularReveal:
        return CircularRevealTransition();
    }
  }

  /// Navigate with custom transition
  static Future<T?> navigateTo<T>(
    Widget page, {
    TransitionType transition = TransitionType.fadeScale,
    Duration duration = AnimationConstants.normal,
    Curve curve = Curves.easeOutCubic,
  }) async {
    return Get.to<T>(
      () => page,
      transition: Transition.cupertinoDialog,
      duration: duration,
      curve: curve,
    );
  }

  /// Navigate and replace with custom transition
  static Future<T?> navigateReplace<T>(
    Widget page, {
    TransitionType transition = TransitionType.fadeScale,
    Duration duration = AnimationConstants.normal,
    Curve curve = Curves.easeOutCubic,
  }) async {
    return Get.off<T>(
      () => page,
      transition: Transition.circularReveal,
      duration: duration,
      curve: curve,
    );
  }

  /// Navigate and remove all previous routes
  static Future<T?> navigateReplaceAll<T>(
    Widget page, {
    TransitionType transition = TransitionType.fadeScale,
    Duration duration = AnimationConstants.normal,
    Curve curve = Curves.easeOutCubic,
  }) async {
    return Get.offAll<T>(
      () => page,
      duration: duration,
      curve: curve,
    );
  }
}

/// Transition types enum
enum TransitionType {
  fadeScale,
  slideFromBottom,
  slideFromRight,
  slideFromLeft,
  sharedAxisHorizontal,
  sharedAxisVertical,
  fadeThrough,
  zoomBlur,
  rotationFade,
  elasticScale,
  circularReveal,
}
