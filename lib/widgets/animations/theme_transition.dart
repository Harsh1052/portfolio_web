import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme_controller.dart';

/// Animated theme switcher with smooth transition effects
/// Wraps the entire app to provide seamless theme switching animations
class AnimatedThemeSwitcher extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimatedThemeSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedThemeSwitcher> createState() => _AnimatedThemeSwitcherState();
}

class _AnimatedThemeSwitcherState extends State<AnimatedThemeSwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Trigger animation when theme changes
      Get.find<ThemeController>().themeMode;

      // Schedule animation after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.status != AnimationStatus.forward) {
          _triggerAnimation();
        }
      });

      return RepaintBoundary(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return widget.child;
          },
          child: widget.child,
        ),
      );
    });
  }
}

/// Circular reveal animation for theme switching
/// Creates an expanding circle effect from a specific position
class ThemeCircularReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset? revealOrigin;

  const ThemeCircularReveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.revealOrigin,
  });

  @override
  State<ThemeCircularReveal> createState() => _ThemeCircularRevealState();
}

class _ThemeCircularRevealState extends State<ThemeCircularReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      final isDark = themeController.isDarkMode;

      if (_isDark != isDark) {
        _isDark = isDark;
        _controller.forward(from: 0.0);
      }

      return RepaintBoundary(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return ClipPath(
              clipper: CircularRevealClipper(
                fraction: _animation.value,
                center: widget.revealOrigin,
              ),
              child: widget.child,
            );
          },
          child: widget.child,
        ),
      );
    });
  }
}

/// Custom clipper for circular reveal effect
class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset? center;

  CircularRevealClipper({
    required this.fraction,
    this.center,
  });

  @override
  Path getClip(Size size) {
    final revealCenter = center ?? Offset(size.width / 2, size.height / 2);

    // Calculate maximum radius (diagonal of screen)
    final maxRadius = (size.longestSide * 1.5) * fraction;

    final path = Path()
      ..addOval(
        Rect.fromCircle(
          center: revealCenter,
          radius: maxRadius,
        ),
      );

    return path;
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return fraction != oldClipper.fraction || center != oldClipper.center;
  }
}

/// Fade transition for theme switching
class ThemeFadeTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const ThemeFadeTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      final isDark = themeController.isDarkMode;

      return RepaintBoundary(
        child: AnimatedSwitcher(
          duration: duration,
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: Container(
            key: ValueKey(isDark),
            child: child,
          ),
        ),
      );
    });
  }
}

/// Slide transition for theme switching
class ThemeSlideTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final AxisDirection direction;

  const ThemeSlideTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.direction = AxisDirection.up,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      final isDark = themeController.isDarkMode;

      Offset getBeginOffset() {
        switch (direction) {
          case AxisDirection.up:
            return const Offset(0, 1);
          case AxisDirection.down:
            return const Offset(0, -1);
          case AxisDirection.left:
            return const Offset(1, 0);
          case AxisDirection.right:
            return const Offset(-1, 0);
        }
      }

      return RepaintBoundary(
        child: AnimatedSwitcher(
          duration: duration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: getBeginOffset(),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey(isDark),
            child: child,
          ),
        ),
      );
    });
  }
}

/// Scale transition for theme switching
class ThemeScaleTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double beginScale;

  const ThemeScaleTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.beginScale = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      final isDark = themeController.isDarkMode;

      return RepaintBoundary(
        child: AnimatedSwitcher(
          duration: duration,
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: Tween<double>(
                begin: beginScale,
                end: 1.0,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey(isDark),
            child: child,
          ),
        ),
      );
    });
  }
}

/// Rotation transition for theme switching (moon/sun effect)
class ThemeRotationTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const ThemeRotationTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      final isDark = themeController.isDarkMode;

      return RepaintBoundary(
        child: AnimatedSwitcher(
          duration: duration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween<double>(
                begin: 0.0,
                end: 0.5,
              ).animate(animation),
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.8,
                  end: 1.0,
                ).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
            );
          },
          child: Container(
            key: ValueKey(isDark),
            child: child,
          ),
        ),
      );
    });
  }
}

/// Animated theme mode indicator
/// Shows a smooth icon transition between light/dark modes
class AnimatedThemeIcon extends StatelessWidget {
  final double size;
  final Color? color;
  final Duration duration;

  const AnimatedThemeIcon({
    super.key,
    this.size = 24,
    this.color,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      final isDark = themeController.isDarkMode;

      return RepaintBoundary(
        child: AnimatedSwitcher(
          duration: duration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
            );
          },
          child: Icon(
            isDark ? Icons.dark_mode : Icons.light_mode,
            key: ValueKey(isDark),
            size: size,
            color: color ?? Theme.of(context).iconTheme.color,
          ),
        ),
      );
    });
  }
}

/// Color tween animation for smooth color transitions during theme change
class AnimatedThemeColor extends ImplicitlyAnimatedWidget {
  final Color? lightColor;
  final Color? darkColor;
  final Widget Function(BuildContext, Color) builder;

  const AnimatedThemeColor({
    super.key,
    this.lightColor,
    this.darkColor,
    required this.builder,
    super.duration = const Duration(milliseconds: 300),
    super.curve = Curves.easeInOut,
  });

  @override
  AnimatedWidgetBaseState<AnimatedThemeColor> createState() =>
      _AnimatedThemeColorState();
}

class _AnimatedThemeColorState
    extends AnimatedWidgetBaseState<AnimatedThemeColor> {
  ColorTween? _colorTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    final themeController = Get.find<ThemeController>();
    final targetColor = themeController.isDarkMode
        ? (widget.darkColor ?? Colors.white)
        : (widget.lightColor ?? Colors.black);

    _colorTween = visitor(
      _colorTween,
      targetColor,
      (value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _colorTween?.evaluate(animation) ?? Colors.transparent,
    );
  }
}
