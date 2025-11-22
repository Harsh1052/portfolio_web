import 'package:flutter/material.dart';

/// Animated button with hover effects
/// Uses AnimatedContainer for performance
class AnimatedHoverButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? hoverColor;
  final double elevation;
  final double hoverElevation;
  final double scale;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AnimatedHoverButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.hoverColor,
    this.elevation = 2.0,
    this.hoverElevation = 8.0,
    this.scale = 1.05,
    this.padding,
    this.borderRadius,
  });

  @override
  State<AnimatedHoverButton> createState() => _AnimatedHoverButtonState();
}

class _AnimatedHoverButtonState extends State<AnimatedHoverButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: RepaintBoundary(
        child: AnimatedScale(
          scale: _isHovering ? widget.scale : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: _isHovering
                  ? (widget.hoverColor ?? theme.colorScheme.primary)
                  : (widget.backgroundColor ??
                      theme.colorScheme.primaryContainer),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withAlpha(30),
                  blurRadius:
                      _isHovering ? widget.hoverElevation : widget.elevation,
                  offset: Offset(0, _isHovering ? 4 : 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                child: Padding(
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Card with animated ripple effect on tap
class RippleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double elevation;

  const RippleCard({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor,
    this.padding,
    this.borderRadius,
    this.elevation = 2.0,
  });

  @override
  State<RippleCard> createState() => _RippleCardState();
}

class _RippleCardState extends State<RippleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(16);

    return RepaintBoundary(
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Card(
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            splashColor:
                widget.rippleColor ?? theme.colorScheme.primary.withAlpha(((0.1) * 255).toInt()),
            highlightColor: theme.colorScheme.primary.withAlpha(((0.05) * 255).toInt()),
            borderRadius: borderRadius,
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(16),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer loading effect
/// Optimized with RepaintBoundary
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
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
    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final baseColor =
        widget.baseColor ?? theme.colorScheme.surfaceContainerHighest.withAlpha(((0.3) * 255).toInt());
    final highlightColor =
        widget.highlightColor ?? theme.colorScheme.surface.withAlpha(((0.5) * 255).toInt());

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  baseColor,
                  highlightColor,
                  baseColor,
                ],
                stops: [
                  _animation.value - 1.0,
                  _animation.value,
                  _animation.value + 1.0,
                ],
                transform: const GradientRotation(0.3),
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Hover scale animation for cards
class HoverScaleCard extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final VoidCallback? onTap;

  const HoverScaleCard({
    super.key,
    required this.child,
    this.scale = 1.03,
    this.duration = const Duration(milliseconds: 200),
    this.onTap,
  });

  @override
  State<HoverScaleCard> createState() => _HoverScaleCardState();
}

class _HoverScaleCardState extends State<HoverScaleCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: RepaintBoundary(
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _isHovering ? widget.scale : 1.0,
            duration: widget.duration,
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: widget.duration,
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..translate(0.0, _isHovering ? -4.0 : 0.0),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Pulse animation for attention-grabbing elements
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool repeat;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 1.0,
    this.maxScale = 1.05,
    this.repeat = true,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
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
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}

/// Icon with rotation animation on hover
class AnimatedHoverIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final VoidCallback? onTap;
  final double rotation;

  const AnimatedHoverIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.onTap,
    this.rotation = 0.1,
  });

  @override
  State<AnimatedHoverIcon> createState() => _AnimatedHoverIconState();
}

class _AnimatedHoverIconState extends State<AnimatedHoverIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: widget.rotation,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _controller.forward();
      },
      onExit: (_) {
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    widget.icon,
                    size: widget.size,
                    color: widget.color,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Gradient border animation
class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final Duration duration;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    required this.gradientColors,
    this.borderWidth = 2.0,
    this.borderRadius,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
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
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: widget.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(_animation.value * 2 * 3.14159),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(widget.borderWidth),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(10),
                ),
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}
