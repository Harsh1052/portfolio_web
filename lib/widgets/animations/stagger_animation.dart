import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Stagger animation for lists with scroll detection
/// Optimized with RepaintBoundary for each item
class StaggeredListAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration itemDelay;
  final Curve curve;
  final Axis direction;
  final double visibilityThreshold;
  final bool animateOnce;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  const StaggeredListAnimation({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 600),
    this.itemDelay = const Duration(milliseconds: 100),
    this.curve = Curves.easeOutCubic,
    this.direction = Axis.vertical,
    this.visibilityThreshold = 0.1,
    this.animateOnce = true,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  State<StaggeredListAnimation> createState() => _StaggeredListAnimationState();
}

class _StaggeredListAnimationState extends State<StaggeredListAnimation>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _fadeAnimations = [];
  final List<Animation<Offset>> _slideAnimations = [];
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    for (int i = 0; i < widget.children.length; i++) {
      final controller = AnimationController(
        duration: widget.duration,
        vsync: this,
      );
      _controllers.add(controller);

      final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: widget.curve),
      );
      _fadeAnimations.add(fadeAnimation);

      final slideAnimation = Tween<Offset>(
        begin: widget.direction == Axis.vertical
            ? const Offset(0, 0.2)
            : const Offset(0.2, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: controller, curve: widget.curve),
      );
      _slideAnimations.add(slideAnimation);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (widget.animateOnce && _hasAnimated) return;

    if (info.visibleFraction >= widget.visibilityThreshold) {
      if (!_hasAnimated) {
        _hasAnimated = true;
        _animateItems();
      }
    } else if (!widget.animateOnce) {
      _reverseAnimations();
    }
  }

  void _animateItems() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.itemDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  void _reverseAnimations() {
    for (var controller in _controllers.reversed) {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('stagger_list_${widget.key ?? widget.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: widget.direction == Axis.vertical
          ? Column(
              crossAxisAlignment: widget.crossAxisAlignment,
              mainAxisAlignment: widget.mainAxisAlignment,
              mainAxisSize: widget.mainAxisSize,
              children: _buildAnimatedChildren(),
            )
          : Row(
              crossAxisAlignment: widget.crossAxisAlignment,
              mainAxisAlignment: widget.mainAxisAlignment,
              mainAxisSize: widget.mainAxisSize,
              children: _buildAnimatedChildren(),
            ),
    );
  }

  List<Widget> _buildAnimatedChildren() {
    return List.generate(widget.children.length, (index) {
      return RepaintBoundary(
        child: SlideTransition(
          position: _slideAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: widget.children[index],
          ),
        ),
      );
    });
  }
}

/// Stagger animation for grids with scroll detection
class StaggeredGridAnimation extends StatefulWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final Duration duration;
  final Duration itemDelay;
  final Curve curve;
  final double visibilityThreshold;
  final bool animateOnce;

  const StaggeredGridAnimation({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
    this.childAspectRatio = 1.0,
    this.duration = const Duration(milliseconds: 600),
    this.itemDelay = const Duration(milliseconds: 80),
    this.curve = Curves.easeOutCubic,
    this.visibilityThreshold = 0.1,
    this.animateOnce = true,
  });

  @override
  State<StaggeredGridAnimation> createState() => _StaggeredGridAnimationState();
}

class _StaggeredGridAnimationState extends State<StaggeredGridAnimation>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _fadeAnimations = [];
  final List<Animation<double>> _scaleAnimations = [];
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    for (int i = 0; i < widget.children.length; i++) {
      final controller = AnimationController(
        duration: widget.duration,
        vsync: this,
      );
      _controllers.add(controller);

      final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: widget.curve),
      );
      _fadeAnimations.add(fadeAnimation);

      final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: widget.curve),
      );
      _scaleAnimations.add(scaleAnimation);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (widget.animateOnce && _hasAnimated) return;

    if (info.visibleFraction >= widget.visibilityThreshold) {
      if (!_hasAnimated) {
        _hasAnimated = true;
        _animateItems();
      }
    } else if (!widget.animateOnce) {
      _reverseAnimations();
    }
  }

  void _animateItems() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.itemDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  void _reverseAnimations() {
    for (var controller in _controllers.reversed) {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('stagger_grid_${widget.key ?? widget.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
        children: _buildAnimatedChildren(),
      ),
    );
  }

  List<Widget> _buildAnimatedChildren() {
    return List.generate(widget.children.length, (index) {
      return RepaintBoundary(
        child: ScaleTransition(
          scale: _scaleAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: widget.children[index],
          ),
        ),
      );
    });
  }
}

/// Stagger animation builder for custom layouts
class StaggeredAnimationBuilder extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index, Animation<double> animation) itemBuilder;
  final Duration duration;
  final Duration itemDelay;
  final Curve curve;
  final double visibilityThreshold;
  final bool animateOnce;
  final Axis scrollDirection;

  const StaggeredAnimationBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.duration = const Duration(milliseconds: 600),
    this.itemDelay = const Duration(milliseconds: 100),
    this.curve = Curves.easeOutCubic,
    this.visibilityThreshold = 0.1,
    this.animateOnce = true,
    this.scrollDirection = Axis.vertical,
  });

  @override
  State<StaggeredAnimationBuilder> createState() => _StaggeredAnimationBuilderState();
}

class _StaggeredAnimationBuilderState extends State<StaggeredAnimationBuilder>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.itemCount; i++) {
      final controller = AnimationController(
        duration: widget.duration,
        vsync: this,
      );
      _controllers.add(controller);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (widget.animateOnce && _hasAnimated) return;

    if (info.visibleFraction >= widget.visibilityThreshold) {
      if (!_hasAnimated) {
        _hasAnimated = true;
        _animateItems();
      }
    } else if (!widget.animateOnce) {
      _reverseAnimations();
    }
  }

  void _animateItems() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.itemDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  void _reverseAnimations() {
    for (var controller in _controllers.reversed) {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('stagger_builder_${widget.key ?? widget.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Column(
        children: List.generate(
          widget.itemCount,
          (index) => RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controllers[index],
              builder: (context, child) {
                return widget.itemBuilder(
                  context,
                  index,
                  CurvedAnimation(
                    parent: _controllers[index],
                    curve: widget.curve,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
