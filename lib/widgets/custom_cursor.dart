import 'package:flutter/material.dart';

import '../utils/design_constants.dart';

/// Custom Cursor Effect for Desktop
/// Provides an animated cursor that follows mouse movement
class CustomCursor extends StatefulWidget {
  final Widget child;

  const CustomCursor({
    super.key,
    required this.child,
  });

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor> {
  Offset _cursorPosition = Offset.zero;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    // Only show custom cursor on desktop
    if (ResponsiveHelper.isMobile(context) ||
        ResponsiveHelper.isTablet(context)) {
      return widget.child;
    }

    return MouseRegion(
      onHover: (event) {
        setState(() {
          _cursorPosition = event.position;
          _isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHovering = false;
        });
      },
      cursor: SystemMouseCursors.none, // Hide default cursor
      child: Stack(
        children: [
          widget.child,

          // Custom cursor dot
          if (_isHovering)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 50),
              curve: Curves.easeOut,
              left: _cursorPosition.dx - 6,
              top: _cursorPosition.dy - 6,
              child: IgnorePointer(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withAlpha(((0.5) * 255).toInt()),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Custom cursor ring
          if (_isHovering)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              left: _cursorPosition.dx - 20,
              top: _cursorPosition.dy - 20,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _isHovering ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: AppColors.primaryBlue.withAlpha(((0.5) * 255).toInt()),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Hover Scale Widget - Scales widget on hover
class HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;

  const HoverScale({
    super.key,
    required this.child,
    this.scale = 1.05,
  });

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedScale(
        scale: _isHovering ? widget.scale : 1.0,
        duration: DesignConstants.animationFast,
        curve: DesignConstants.curveEmphasized,
        child: widget.child,
      ),
    );
  }
}

/// Hover Lift Widget - Lifts widget on hover with shadow
class HoverLift extends StatefulWidget {
  final Widget child;
  final double liftOffset;

  const HoverLift({
    super.key,
    required this.child,
    this.liftOffset = -8.0,
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: DesignConstants.animationFast,
        curve: DesignConstants.curveEmphasized,
        transform: Matrix4.translationValues(
          0,
          _isHovering ? widget.liftOffset : 0,
          0,
        ),
        child: AnimatedContainer(
          duration: DesignConstants.animationFast,
          decoration: BoxDecoration(
            boxShadow: _isHovering ? AppShadows.xLarge : AppShadows.small,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
