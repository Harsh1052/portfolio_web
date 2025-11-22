import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Base widget for scroll-based animations with visibility detection
/// Optimized with RepaintBoundary to isolate repaints
class ScrollAnimatedWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double visibilityThreshold;
  final bool animateOnce;

  const ScrollAnimatedWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.visibilityThreshold = 0.1,
    this.animateOnce = true,
  });

  @override
  State<ScrollAnimatedWidget> createState() => _ScrollAnimatedWidgetState();
}

class _ScrollAnimatedWidgetState extends State<ScrollAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (widget.animateOnce && _hasAnimated) return;

    if (info.visibleFraction >= widget.visibilityThreshold) {
      if (!_hasAnimated) {
        _hasAnimated = true;
        Future.delayed(widget.delay, () {
          if (mounted) {
            _controller.forward();
          }
        });
      }
    } else if (!widget.animateOnce) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('scroll_anim_${widget.key ?? widget.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => widget.child,
          child: widget.child,
        ),
      ),
    );
  }

  AnimationController get controller => _controller;
}

/// Fade in animation with scroll detection
class FadeInOnScroll extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double visibilityThreshold;
  final bool animateOnce;

  const FadeInOnScroll({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.visibilityThreshold = 0.1,
    this.animateOnce = true,
  });

  @override
  State<FadeInOnScroll> createState() => _FadeInOnScrollState();
}

class _FadeInOnScrollState extends State<FadeInOnScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (widget.animateOnce && _hasAnimated) return;

    if (info.visibleFraction >= widget.visibilityThreshold) {
      if (!_hasAnimated) {
        _hasAnimated = true;
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    } else if (!widget.animateOnce && mounted) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('fade_in_${widget.key ?? widget.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: RepaintBoundary(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Slide in animation with scroll detection
class SlideInOnScroll extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final Offset begin;
  final Offset end;
  final double visibilityThreshold;
  final bool animateOnce;

  const SlideInOnScroll({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.begin = const Offset(0, 0.3),
    this.end = Offset.zero,
    this.visibilityThreshold = 0.1,
    this.animateOnce = true,
  });

  /// Slide in from bottom
  const SlideInOnScroll.fromBottom({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.visibilityThreshold = 0.1,
    this.animateOnce = true,
  })  : begin = const Offset(0, 0.3),
        end = Offset.zero;

  /// Slide in from left
  const SlideInOnScroll.fromLeft({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.visibilityThreshold = 0.1,
    this.animateOnce = true,
  })  : begin = const Offset(-0.3, 0),
        end = Offset.zero;

  /// Slide in from right
  const SlideInOnScroll.fromRight({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.visibilityThreshold = 0.1,
    this.animateOnce = true,
  })  : begin = const Offset(0.3, 0),
        end = Offset.zero;

  @override
  State<SlideInOnScroll> createState() => _SlideInOnScrollState();
}

class _SlideInOnScrollState extends State<SlideInOnScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (widget.animateOnce && _hasAnimated) return;

    if (info.visibleFraction >= widget.visibilityThreshold) {
      if (!_hasAnimated) {
        _hasAnimated = true;
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    } else if (!widget.animateOnce && mounted) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('slide_in_${widget.key ?? widget.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: RepaintBoundary(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Scale in animation with scroll detection
class ScaleInOnScroll extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double beginScale;
  final double endScale;
  final double visibilityThreshold;
  final bool animateOnce;

  const ScaleInOnScroll({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutBack,
    this.beginScale = 0.8,
    this.endScale = 1.0,
    this.visibilityThreshold = 0.1,
    this.animateOnce = true,
  });

  @override
  State<ScaleInOnScroll> createState() => _ScaleInOnScrollState();
}

class _ScaleInOnScrollState extends State<ScaleInOnScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: widget.beginScale,
      end: widget.endScale,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (widget.animateOnce && _hasAnimated) return;

    if (info.visibleFraction >= widget.visibilityThreshold) {
      if (!_hasAnimated) {
        _hasAnimated = true;
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    } else if (!widget.animateOnce && mounted) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('scale_in_${widget.key ?? widget.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: RepaintBoundary(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
