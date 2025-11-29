import 'package:flutter/material.dart';

/// Design Constants for the Portfolio Application
/// Contains colors, spacing, animations, shadows, and responsive breakpoints
class DesignConstants {
  // Prevent instantiation
  DesignConstants._();

  // ==================== RESPONSIVE BREAKPOINTS ====================

  /// Mobile devices: < 600px
  static const double breakpointMobile = 600;

  /// Tablet devices: 600-1024px
  static const double breakpointTablet = 1024;

  /// Desktop devices: > 1024px
  static const double breakpointDesktop = 1024;

  /// Large desktop: > 1440px
  static const double breakpointLargeDesktop = 1440;

  // ==================== SPACING SYSTEM ====================

  /// Extra small spacing: 4px
  static const double spacingXSmall = 4.0;

  /// Small spacing: 8px
  static const double spacingSmall = 8.0;

  /// Medium spacing: 16px
  static const double spacingMedium = 16.0;

  /// Large spacing: 24px
  static const double spacingLarge = 24.0;

  /// Extra large spacing: 32px
  static const double spacingXLarge = 32.0;

  /// 2X large spacing: 48px
  static const double spacing2XLarge = 48.0;

  /// 3X large spacing: 64px
  static const double spacing3XLarge = 64.0;

  /// 4X large spacing: 96px
  static const double spacing4XLarge = 96.0;

  // ==================== BORDER RADIUS ====================

  /// Extra small radius: 4px
  static const double borderRadiusXSmall = 4.0;

  /// Small radius: 8px
  static const double borderRadiusSmall = 8.0;

  /// Medium radius: 12px
  static const double borderRadiusMedium = 12.0;

  /// Large radius: 16px
  static const double borderRadiusLarge = 16.0;

  /// Extra large radius: 24px
  static const double borderRadiusXLarge = 24.0;

  /// Full circle/pill radius
  static const double borderRadiusFull = 9999.0;

  // ==================== ANIMATION DURATIONS ====================

  /// Very fast animation: 150ms - for micro-interactions
  static const Duration animationFast = Duration(milliseconds: 150);

  /// Normal animation: 300ms - default for most transitions
  static const Duration animationNormal = Duration(milliseconds: 300);

  /// Slow animation: 500ms - for elaborate transitions
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// Very slow animation: 800ms - for page transitions
  static const Duration animationVerySlow = Duration(milliseconds: 800);

  // ==================== ANIMATION CURVES ====================

  /// Standard easing curve
  static const Curve curveStandard = Curves.easeInOut;

  /// Emphasized easing curve - for important actions
  static const Curve curveEmphasized = Curves.easeOutCubic;

  /// Decelerated easing - elements entering screen
  static const Curve curveDecelerate = Curves.easeOut;

  /// Accelerated easing - elements leaving screen
  static const Curve curveAccelerate = Curves.easeIn;

  // ==================== LAYOUT CONSTANTS ====================

  /// Maximum content width for large screens
  static const double maxContentWidth = 1200;

  /// Container padding for mobile
  static const double containerPaddingMobile = spacingMedium;

  /// Container padding for tablet
  static const double containerPaddingTablet = spacingLarge;

  /// Container padding for desktop
  static const double containerPaddingDesktop = spacing2XLarge;

  /// Section spacing for mobile
  static const double sectionSpacingMobile = spacing3XLarge;

  /// Section spacing for tablet
  static const double sectionSpacingTablet = spacing4XLarge;

  /// Section spacing for desktop
  static const double sectionSpacingDesktop = spacing4XLarge * 1.5;

  // ==================== ICON SIZES ====================

  /// Small icon size: 16px
  static const double iconSizeSmall = 16.0;

  /// Medium icon size: 24px
  static const double iconSizeMedium = 24.0;

  /// Large icon size: 32px
  static const double iconSizeLarge = 32.0;

  /// Extra large icon size: 48px
  static const double iconSizeXLarge = 48.0;

  // ==================== ELEVATION ====================

  /// Elevation level 0: No shadow
  static const double elevation0 = 0.0;

  /// Elevation level 1: Subtle shadow
  static const double elevation1 = 1.0;

  /// Elevation level 2: Card shadow
  static const double elevation2 = 2.0;

  /// Elevation level 3: Raised elements
  static const double elevation3 = 4.0;

  /// Elevation level 4: Floating action button
  static const double elevation4 = 8.0;

  /// Elevation level 5: Modal or dialog
  static const double elevation5 = 16.0;
}

/// Color Palette with Modern Gradients
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ==================== PRIMARY COLORS - BLUE ====================

  /// Primary blue - vibrant and modern
  static const Color primaryBlue = Color(0xFF0EA5E9); // Sky blue 500

  /// Primary blue dark - for hover states and dark mode containers
  static const Color primaryBlueDark = Color(0xFF0369A1); // Sky blue 800

  /// Primary blue light - for light mode containers
  static const Color primaryBlueLight = Color(0xFF7DD3FC); // Sky blue 300

  // ==================== SECONDARY COLORS - PURPLE ====================

  /// Accent purple - creative and elegant
  static const Color accentPurple = Color(0xFF8B5CF6); // Violet 500

  /// Accent purple dark
  static const Color accentPurpleDark = Color(0xFF6D28D9); // Violet 700

  /// Accent purple light
  static const Color accentPurpleLight = Color(0xFFA78BFA); // Violet 400

  // ==================== TERTIARY COLORS - TEAL ====================

  /// Accent teal - fresh and professional
  static const Color accentTeal = Color(0xFF14B8A6); // Teal 500

  /// Accent teal dark
  static const Color accentTealDark = Color(0xFF0F766E); // Teal 700

  /// Accent teal light
  static const Color accentTealLight = Color(0xFF2DD4BF); // Teal 400

  // ==================== LIGHT THEME COLORS ====================

  /// Light background - almost white
  static const Color backgroundLight = Color(0xFFFAFAFA); // Gray 50

  /// Light surface - pure white
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Light surface variant - subtle gray
  static const Color surfaceVariantLight = Color(0xFFF5F5F5); // Gray 100

  /// Primary text color for light theme
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate 900

  /// Secondary text color for light theme
  static const Color textSecondaryLight = Color(0xFF475569); // Slate 600

  /// Tertiary text color for light theme
  static const Color textTertiaryLight = Color(0xFF94A3B8); // Slate 400

  /// Outline color for light theme
  static const Color outlineLight = Color(0xFFE2E8F0); // Slate 200

  /// Outline variant for light theme
  static const Color outlineVariantLight = Color(0xFFF1F5F9); // Slate 100

  // ==================== DARK THEME COLORS ====================

  /// Dark background - rich dark
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900

  /// Dark surface - slightly lighter
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800

  /// Dark surface variant - elevated surface
  static const Color surfaceVariantDark = Color(0xFF334155); // Slate 700

  /// Primary text color for dark theme
  static const Color textPrimaryDark = Color(0xFFF1F5F9); // Slate 100

  /// Secondary text color for dark theme
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate 400

  /// Tertiary text color for dark theme
  static const Color textTertiaryDark = Color(0xFF64748B); // Slate 500

  /// Outline color for dark theme
  static const Color outlineDark = Color(0xFF334155); // Slate 700

  /// Outline variant for dark theme
  static const Color outlineVariantDark = Color(0xFF1E293B); // Slate 800

  // ==================== STATUS COLORS ====================

  /// Success green
  static const Color successGreen = Color(0xFF10B981); // Emerald 500

  /// Success green light
  static const Color successGreenLight = Color(0xFF34D399); // Emerald 400

  /// Error red
  static const Color errorRed = Color(0xFFEF4444); // Red 500

  /// Error red light
  static const Color errorRedLight = Color(0xFFF87171); // Red 400

  /// Warning orange
  static const Color warningOrange = Color(0xFFF59E0B); // Amber 500

  /// Warning orange light
  static const Color warningOrangeLight = Color(0xFFFBBF24); // Amber 400

  /// Info blue
  static const Color infoBlue = Color(0xFF3B82F6); // Blue 500

  /// Info blue light
  static const Color infoBluLight = Color(0xFF60A5FA); // Blue 400

  // ==================== GRADIENTS ====================

  /// Primary gradient - blue to purple
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary gradient - teal to blue
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [accentTeal, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient - purple to pink
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentPurple, Color(0xFFEC4899)], // Purple to Pink
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark gradient - for dark mode backgrounds
  static const LinearGradient darkGradient = LinearGradient(
    colors: [backgroundDark, surfaceDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hero gradient - vibrant multi-color
  static const LinearGradient heroGradient = LinearGradient(
    colors: [primaryBlue, accentPurple, accentTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Overlay gradient - for text on images
  static const LinearGradient overlayGradient = LinearGradient(
    colors: [
      Color(0x00000000),
      Color(0xCC000000),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Card gradient for dark theme - subtle glassmorphic background
  static const LinearGradient cardGradientDark = LinearGradient(
    colors: [
      Color(0x1AFFFFFF), // 10% white
      Color(0x0DFFFFFF), // 5% white
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Card gradient for light theme - subtle glassmorphic background
  static const LinearGradient cardGradientLight = LinearGradient(
    colors: [
      Color(0x33FFFFFF), // 20% white
      Color(0x1AFFFFFF), // 10% white
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Shimmer gradient - for loading states
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0x00FFFFFF),
      Color(0x33FFFFFF),
      Color(0x00FFFFFF),
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );
}

/// Shadow Definitions for Depth
class AppShadows {
  // Prevent instantiation
  AppShadows._();

  // ==================== LIGHT THEME SHADOWS ====================

  /// Extra small shadow - subtle depth
  static const List<BoxShadow> xSmall = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Small shadow - for cards and buttons
  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Medium shadow - for elevated components
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 3,
      offset: Offset(0, 2),
    ),
  ];

  /// Large shadow - for modals and popovers
  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];

  /// Extra large shadow - for floating elements
  static const List<BoxShadow> xLarge = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 10,
      offset: Offset(0, 6),
    ),
  ];

  // ==================== DARK THEME SHADOWS ====================

  /// Small shadow for dark theme
  static const List<BoxShadow> smallDark = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium shadow for dark theme
  static const List<BoxShadow> mediumDark = [
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  /// Large shadow for dark theme
  static const List<BoxShadow> largeDark = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  // ==================== COLORED SHADOWS ====================

  /// Primary colored shadow - for primary buttons/cards
  static const List<BoxShadow> primary = [
    BoxShadow(
      color: Color(0x330EA5E9),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Secondary colored shadow - for accent elements
  static const List<BoxShadow> secondary = [
    BoxShadow(
      color: Color(0x338B5CF6),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
}

/// Responsive Helper Methods
class ResponsiveHelper {
  // Prevent instantiation
  ResponsiveHelper._();

  /// Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < DesignConstants.breakpointMobile;
  }

  /// Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= DesignConstants.breakpointMobile &&
        width < DesignConstants.breakpointDesktop;
  }

  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >=
        DesignConstants.breakpointDesktop;
  }

  /// Check if screen is large desktop
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >=
        DesignConstants.breakpointLargeDesktop;
  }

  /// Get responsive value based on screen size
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  /// Get responsive padding
  static double getContainerPadding(BuildContext context) {
    if (isDesktop(context)) return DesignConstants.containerPaddingDesktop;
    if (isTablet(context)) return DesignConstants.containerPaddingTablet;
    return DesignConstants.containerPaddingMobile;
  }

  /// Get responsive section spacing
  static double getSectionSpacing(BuildContext context) {
    if (isDesktop(context)) return DesignConstants.sectionSpacingDesktop;
    if (isTablet(context)) return DesignConstants.sectionSpacingTablet;
    return DesignConstants.sectionSpacingMobile;
  }
}

/// Glassmorphic Design Tokens
/// Contains constants for creating consistent glassmorphic effects
class GlassmorphicTokens {
  // Prevent instantiation
  GlassmorphicTokens._();

  // ==================== BLUR AMOUNTS ====================

  /// Small blur: 5px
  static const double blurSmall = 5.0;

  /// Medium blur: 10px - default for most glass effects
  static const double blurMedium = 10.0;

  /// Large blur: 20px - for prominent glass effects
  static const double blurLarge = 20.0;

  // ==================== OPACITY VALUES ====================

  /// Glass opacity for dark theme
  static const double opacityDark = 0.1;

  /// Glass opacity for light theme
  static const double opacityLight = 0.2;

  // ==================== BORDER WIDTHS ====================

  /// Thin border: 0.5px
  static const double borderThin = 0.5;

  /// Medium border: 1px - default for glass cards
  static const double borderMedium = 1.0;

  /// Thick border: 2px
  static const double borderThick = 2.0;

  // ==================== BORDER COLORS ====================

  /// Glass border color for dark theme
  static const Color glassBorderDark = Color(0x33FFFFFF); // 20% white

  /// Glass border color for light theme
  static const Color glassBorderLight = Color(0x4DFFFFFF); // 30% white
}

/// Premium Shadow Definitions for Glassmorphic Effects
class PremiumShadows {
  // Prevent instantiation
  PremiumShadows._();

  // ==================== GLASS SHADOWS ====================

  /// Glass shadow for light theme
  static const List<BoxShadow> glassLight = [
    BoxShadow(
      color: Color(0x0A000000), // 4% black
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x05000000), // 2% black
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  /// Glass shadow for dark theme
  static const List<BoxShadow> glassDark = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0F000000), // 6% black
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  /// Elevated glass shadow for light theme - for hover states
  static const List<BoxShadow> glassElevatedLight = [
    BoxShadow(
      color: Color(0x14000000), // 8% black
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4% black
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
  ];

  /// Elevated glass shadow for dark theme - for hover states
  static const List<BoxShadow> glassElevatedDark = [
    BoxShadow(
      color: Color(0x26000000), // 15% black
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x14000000), // 8% black
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
  ];
}

/// Particle Animation Configuration
class ParticleConfig {
  // Prevent instantiation
  ParticleConfig._();

  // ==================== PARTICLE COUNTS ====================

  /// Particle count for mobile devices - reduced for performance
  static const int particleCountMobile = 20;

  /// Particle count for tablet devices
  static const int particleCountTablet = 40;

  /// Particle count for desktop devices
  static const int particleCountDesktop = 60;

  // ==================== PARTICLE COLORS ====================

  /// Particle colors for dark theme
  static const List<Color> colorsDark = [
    Color(0x330EA5E9), // 20% primary blue
    Color(0x338B5CF6), // 20% accent purple
    Color(0x3314B8A6), // 20% accent teal
    Color(0x1AFFFFFF), // 10% white
  ];

  /// Particle colors for light theme
  static const List<Color> colorsLight = [
    Color(0x1A0EA5E9), // 10% primary blue
    Color(0x1A8B5CF6), // 10% accent purple
    Color(0x1A14B8A6), // 10% accent teal
    Color(0x0D000000), // 5% black
  ];

  // ==================== PARTICLE SIZES ====================

  /// Minimum particle size
  static const double minSize = 2.0;

  /// Maximum particle size
  static const double maxSize = 6.0;

  // ==================== PARTICLE SPEEDS ====================

  /// Minimum particle speed (pixels per second)
  static const double minSpeed = 10.0;

  /// Maximum particle speed (pixels per second)
  static const double maxSpeed = 30.0;

  // ==================== PARTICLE OPACITY ====================

  /// Particle opacity
  static const double opacity = 0.6;
}
