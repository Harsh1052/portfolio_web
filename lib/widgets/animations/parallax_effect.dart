import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Parallax scrolling effect for hero sections
/// Optimized with RepaintBoundary for performance
class ParallaxScroll extends StatelessWidget {
  final Widget background;
  final Widget foreground;
  final double backgroundSpeed;
  final double foregroundSpeed;
  final GlobalKey scrollKey;

  const ParallaxScroll({
    super.key,
    required this.background,
    required this.foreground,
    required this.scrollKey,
    this.backgroundSpeed = 0.5,
    this.foregroundSpeed = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Parallax background layer
        RepaintBoundary(
          child: _ParallaxLayer(
            scrollKey: scrollKey,
            speed: backgroundSpeed,
            child: background,
          ),
        ),
        // Foreground content
        RepaintBoundary(
          child: _ParallaxLayer(
            scrollKey: scrollKey,
            speed: foregroundSpeed,
            child: foreground,
          ),
        ),
      ],
    );
  }
}

class _ParallaxLayer extends StatelessWidget {
  final Widget child;
  final double speed;
  final GlobalKey scrollKey;

  const _ParallaxLayer({
    required this.child,
    required this.speed,
    required this.scrollKey,
  });

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: scrollKey,
        speed: speed,
      ),
      children: [child],
    );
  }
}

class _ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;
  final double speed;

  _ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
    required this.speed,
  }) : super(repaint: scrollable.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;

    final childRect = verticalAlignment.inscribe(
      backgroundSize,
      Offset.zero & listItemSize,
    );

    final offset = Offset(0, childRect.top * (1 - speed));

    context.paintChild(
      0,
      transform: Matrix4.translationValues(0.0, offset.dy, 0.0),
    );
  }

  @override
  bool shouldRepaint(_ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey ||
        speed != oldDelegate.speed;
  }
}

/// Simple parallax background widget
class ParallaxBackground extends StatefulWidget {
  final Widget child;
  final double intensity;
  final bool enableParallax;

  const ParallaxBackground({
    super.key,
    required this.child,
    this.intensity = 0.3,
    this.enableParallax = true,
  });

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  double _offset = 0.0;
  ScrollController? _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = Scrollable.maybeOf(context)?.widget.controller;
    _scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController != null && mounted && widget.enableParallax) {
      setState(() {
        _offset = _scrollController!.offset * widget.intensity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Transform.translate(
        offset: Offset(0, -_offset),
        child: widget.child,
      ),
    );
  }
}

/// Mouse follower gradient effect (desktop only)
class MouseFollowerGradient extends StatefulWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double radius;
  final double opacity;
  final bool enabled;

  const MouseFollowerGradient({
    super.key,
    required this.child,
    required this.gradientColors,
    this.radius = 300,
    this.opacity = 0.3,
    this.enabled = true,
  });

  @override
  State<MouseFollowerGradient> createState() => _MouseFollowerGradientState();
}

class _MouseFollowerGradientState extends State<MouseFollowerGradient>
    with SingleTickerProviderStateMixin {
  Offset _mousePosition = Offset.zero;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateMousePosition(PointerEvent details) {
    if (!widget.enabled) return;
    setState(() {
      _mousePosition = details.localPosition;
    });
  }

  void _onEnter(PointerEnterEvent event) {
    _controller.forward();
  }

  void _onExit(PointerExitEvent event) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: _updateMousePosition,
      child: RepaintBoundary(
        child: Stack(
          children: [
            widget.child,
            if (widget.enabled)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _MouseGradientPainter(
                          position: _mousePosition,
                          colors: widget.gradientColors,
                          radius: widget.radius,
                          opacity: widget.opacity * _animation.value,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MouseGradientPainter extends CustomPainter {
  final Offset position;
  final List<Color> colors;
  final double radius;
  final double opacity;

  _MouseGradientPainter({
    required this.position,
    required this.colors,
    required this.radius,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: colors.map((c) => c.withAlpha(((opacity) * 255).toInt())).toList(),
        stops: const [0.0, 0.5, 1.0],
      ).createShader(
        Rect.fromCircle(center: position, radius: radius),
      );

    canvas.drawCircle(position, radius, paint);
  }

  @override
  bool shouldRepaint(_MouseGradientPainter oldDelegate) {
    return position != oldDelegate.position ||
        opacity != oldDelegate.opacity ||
        radius != oldDelegate.radius;
  }
}

/// Animated gradient background
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    required this.colors,
    this.duration = const Duration(seconds: 3),
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: widget.begin,
                end: widget.end,
                colors: widget.colors,
                stops: [
                  0.0,
                  _animation.value,
                  1.0,
                ],
              ),
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Floating animation for elements
class FloatingAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double distance;
  final Axis axis;

  const FloatingAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.distance = 10.0,
    this.axis = Axis.vertical,
  });

  @override
  State<FloatingAnimation> createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: -widget.distance,
      end: widget.distance,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: widget.axis == Axis.vertical
                ? Offset(0, _animation.value)
                : Offset(_animation.value, 0),
            child: widget.child,
          );
        },
      ),
    );
  }
}
