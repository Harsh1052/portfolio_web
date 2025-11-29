import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/design_constants.dart';
import '../utils/glassmorphic_utils.dart';

/// Reusable glassmorphic card component with configurable blur, opacity, and border styles
///
/// This widget creates a frosted glass effect with backdrop blur, gradient borders,
/// and theme-aware styling for both light and dark modes.
class GlassmorphicCard extends StatefulWidget {
  /// Child widget to display inside the glass card
  final Widget child;

  /// Border radius for the card
  final double borderRadius;

  /// Blur radius for the glass effect
  final double? blurRadius;

  /// Background opacity (uses theme defaults if null)
  final double? opacity;

  /// Optional gradient overlay
  final Gradient? gradient;

  /// Border width
  final double? borderWidth;

  /// Padding inside the card
  final EdgeInsetsGeometry? padding;

  /// Whether to enable hover animation
  final bool enableHoverAnimation;

  /// Custom box shadow
  final List<BoxShadow>? boxShadow;

  /// On tap callback
  final VoidCallback? onTap;

  /// Margin around the card
  final EdgeInsetsGeometry? margin;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.borderRadius = DesignConstants.borderRadiusLarge,
    this.blurRadius,
    this.opacity,
    this.gradient,
    this.borderWidth,
    this.padding,
    this.enableHoverAnimation = true,
    this.boxShadow,
    this.onTap,
    this.margin,
  });

  @override
  State<GlassmorphicCard> createState() => _GlassmorphicCardState();
}

class _GlassmorphicCardState extends State<GlassmorphicCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBlur = widget.blurRadius ??
        GlassmorphicUtils.getGlassBlur(
          context,
          GlassmorphicTokens.blurMedium,
        );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: DesignConstants.animationNormal,
          curve: DesignConstants.curveStandard,
          margin: widget.margin,
          transform: widget.enableHoverAnimation && _isHovered
              ? (Matrix4.identity()..scale(1.02))
              : Matrix4.identity(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: effectiveBlur,
                sigmaY: effectiveBlur,
              ),
              child: Container(
                padding: widget.padding ??
                    const EdgeInsets.all(DesignConstants.spacingLarge),
                decoration: GlassmorphicUtils.createGlassEffect(
                  isDark: isDark,
                  blurRadius: effectiveBlur,
                  opacity: widget.opacity,
                  borderRadius: widget.borderRadius,
                  gradient: widget.gradient,
                  borderWidth: widget.borderWidth,
                ).copyWith(
                  boxShadow: widget.boxShadow ??
                      (widget.enableHoverAnimation && _isHovered
                          ? (isDark
                              ? PremiumShadows.glassDark
                              : PremiumShadows.glassLight)
                          : (isDark
                              ? PremiumShadows.glassDark
                              : PremiumShadows.glassLight)),
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Glassmorphic card with gradient border
class GlassmorphicCardWithBorder extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Gradient borderGradient;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassmorphicCardWithBorder({
    super.key,
    required this.child,
    this.borderRadius = DesignConstants.borderRadiusLarge,
    this.borderGradient = AppColors.primaryGradient,
    this.borderWidth = 2.0,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: borderGradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.all(borderWidth),
      child: GlassmorphicCard(
        borderRadius: borderRadius - borderWidth,
        padding: padding,
        borderWidth: 0,
        child: child,
      ),
    );
  }
}
