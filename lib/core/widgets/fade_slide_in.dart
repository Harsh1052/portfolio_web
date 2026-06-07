import 'package:flutter/material.dart';

/// A widget that fades and slides its [child] upward into view once it enters
/// the viewport.
///
/// **How visibility is detected:**
/// Uses a post-frame callback loop — every time Flutter renders a frame
/// (including during scroll), this widget checks its screen position via
/// [RenderBox.localToGlobal]. Once visible, it triggers the animation and
/// stops polling. This is safe because Flutter only renders frames when
/// something changes (i.e., during scroll), so idle performance is unaffected.
///
/// Usage:
/// ```dart
/// FadeSlideIn(
///   delay: Duration(milliseconds: 100),
///   child: ProjectCard(project: p),
/// )
/// ```
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 480),
    this.offsetY = 20.0,
  });

  final Widget child;

  /// Stagger delay before the animation starts.
  final Duration delay;

  /// Total animation duration.
  final Duration duration;

  /// Pixels below final position the widget starts from.
  final double offsetY;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  final GlobalKey _key = GlobalKey();
  bool _triggered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: Offset(0, widget.offsetY / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Start the per-frame visibility polling after the first layout.
    WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleCheck());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Checks if this widget is in the viewport.
  /// If yes → triggers animation and stops.
  /// If no  → schedules itself again on the next frame.
  ///
  /// During scrolling Flutter continuously renders new frames, so this
  /// gets called on every scroll frame until the widget becomes visible.
  void _scheduleCheck() {
    if (_triggered || !mounted) return;

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) {
      // Layout not done yet — retry next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleCheck());
      return;
    }

    final topLeft = renderBox.localToGlobal(Offset.zero);
    final viewHeight = MediaQuery.sizeOf(context).height;

    // Trigger when the top edge of the widget is within 95% of the viewport.
    if (topLeft.dy < viewHeight * 0.95) {
      _triggered = true;
      _trigger();
    } else {
      // Not visible yet — check again on the next rendered frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleCheck());
    }
  }

  void _trigger() {
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: SizedBox(key: _key, child: widget.child),
      ),
    );
  }
}
