import 'package:flutter/material.dart';
import 'design_constants.dart';

/// Utility functions for creating glassmorphic effects consistently across the app
class GlassmorphicUtils {
  // Prevent instantiation
  GlassmorphicUtils._();

  /// Creates a glassmorphic BoxDecoration with blur and transparency
  ///
  /// [isDark] - Whether to use dark theme styling
  /// [blurRadius] - Amount of blur (default: medium)
  /// [opacity] - Background opacity (uses theme defaults if null)
  /// [borderRadius] - Border radius for the glass card
  /// [gradient] - Optional gradient overlay
  /// [borderWidth] - Width of the border (default: medium)
  static BoxDecoration createGlassEffect({
    required bool isDark,
    double? blurRadius,
    double? opacity,
    double borderRadius = DesignConstants.borderRadiusLarge,
    Gradient? gradient,
    double? borderWidth,
  }) {
    final effectiveBlur = blurRadius ?? GlassmorphicTokens.blurMedium;
    final effectiveOpacity = opacity ??
        (isDark
            ? GlassmorphicTokens.opacityDark
            : GlassmorphicTokens.opacityLight);
    final effectiveBorderWidth = borderWidth ?? GlassmorphicTokens.borderMedium;

    return BoxDecoration(
      gradient: gradient ??
          (isDark ? AppColors.cardGradientDark : AppColors.cardGradientLight),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isDark
            ? GlassmorphicTokens.glassBorderDark
            : GlassmorphicTokens.glassBorderLight,
        width: effectiveBorderWidth,
      ),
      boxShadow: isDark ? PremiumShadows.glassDark : PremiumShadows.glassLight,
    );
  }

  /// Creates a gradient border for glass cards
  ///
  /// [isDark] - Whether to use dark theme styling
  /// [borderRadius] - Border radius for the glass card
  /// [gradient] - Gradient for the border
  static BoxDecoration createGlassBorder({
    required bool isDark,
    double borderRadius = DesignConstants.borderRadiusLarge,
    Gradient? gradient,
  }) {
    return BoxDecoration(
      gradient: gradient ?? AppColors.primaryGradient,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Gets theme-aware glass opacity
  static double getGlassOpacity(bool isDark) {
    return isDark
        ? GlassmorphicTokens.opacityDark
        : GlassmorphicTokens.opacityLight;
  }

  /// Gets performance-aware blur radius based on device
  ///
  /// [context] - BuildContext for responsive checks
  /// [preferredBlur] - Preferred blur radius
  static double getGlassBlur(BuildContext context, double preferredBlur) {
    // Reduce blur on mobile for better performance
    if (ResponsiveHelper.isMobile(context)) {
      return preferredBlur * 0.75;
    }
    return preferredBlur;
  }

  /// Creates a shimmer effect decoration
  static BoxDecoration createShimmerEffect({
    required bool isDark,
    double borderRadius = DesignConstants.borderRadiusLarge,
  }) {
    return BoxDecoration(
      gradient: AppColors.shimmerGradient,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Creates a glow effect with colored shadow
  ///
  /// [color] - Base color for the glow
  /// [intensity] - Glow intensity (0.0 to 1.0)
  static List<BoxShadow> createGlowEffect({
    required Color color,
    double intensity = 0.5,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(0.4 * intensity),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: color.withOpacity(0.2 * intensity),
        blurRadius: 40,
        offset: const Offset(0, 8),
      ),
    ];
  }

  /// Gets particle count based on device performance
  static int getParticleCount(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return ParticleConfig.particleCountMobile;
    } else if (ResponsiveHelper.isTablet(context)) {
      return ParticleConfig.particleCountTablet;
    }
    return ParticleConfig.particleCountDesktop;
  }

  /// Gets particle colors based on theme
  static List<Color> getParticleColors(bool isDark) {
    return isDark ? ParticleConfig.colorsDark : ParticleConfig.colorsLight;
  }
}
