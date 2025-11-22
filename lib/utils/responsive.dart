import 'package:flutter/material.dart';
import 'design_constants.dart';

/// Comprehensive Responsive Utilities
/// Extends ResponsiveHelper with additional responsive helpers
///
/// Usage:
/// ```dart
/// Responsive.of(context).isMobile
/// Responsive.of(context).spacing.large
/// Responsive.of(context).fontSize.h1
/// ```
class Responsive {
  final BuildContext context;
  late final MediaQueryData _mediaQuery;
  late final Size _screenSize;

  Responsive.of(this.context) {
    _mediaQuery = MediaQuery.of(context);
    _screenSize = _mediaQuery.size;
  }

  // ==================== SCREEN SIZE QUERIES ====================

  /// Screen width
  double get width => _screenSize.width;

  /// Screen height
  double get height => _screenSize.height;

  /// Safe area padding
  EdgeInsets get padding => _mediaQuery.padding;

  /// View insets (keyboard, etc.)
  EdgeInsets get viewInsets => _mediaQuery.viewInsets;

  /// Device pixel ratio
  double get devicePixelRatio => _mediaQuery.devicePixelRatio;

  // ==================== BREAKPOINT CHECKS ====================

  /// Is mobile device (< 600px)
  bool get isMobile => width < DesignConstants.breakpointMobile;

  /// Is tablet device (600-1024px)
  bool get isTablet =>
      width >= DesignConstants.breakpointMobile &&
      width < DesignConstants.breakpointDesktop;

  /// Is desktop device (>= 1024px)
  bool get isDesktop => width >= DesignConstants.breakpointDesktop;

  /// Is large desktop (>= 1440px)
  bool get isLargeDesktop => width >= DesignConstants.breakpointLargeDesktop;

  /// Is small mobile (< 375px)
  bool get isSmallMobile => width < 375;

  /// Is landscape orientation
  bool get isLandscape => _mediaQuery.orientation == Orientation.landscape;

  /// Is portrait orientation
  bool get isPortrait => _mediaQuery.orientation == Orientation.portrait;

  // ==================== RESPONSIVE VALUES ====================

  /// Get value based on screen size
  T getValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    if (isLargeDesktop && largeDesktop != null) return largeDesktop;
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Get value with custom breakpoints
  T getValueWithBreakpoints<T>({
    required T defaultValue,
    required Map<double, T> breakpoints,
  }) {
    T result = defaultValue;
    final sortedBreakpoints = breakpoints.keys.toList()..sort();

    for (final breakpoint in sortedBreakpoints) {
      if (width >= breakpoint) {
        result = breakpoints[breakpoint] as T;
      }
    }

    return result;
  }

  // ==================== RESPONSIVE SPACING ====================

  /// Responsive spacing getters
  ResponsiveSpacing get spacing => ResponsiveSpacing._(this);

  // ==================== RESPONSIVE FONT SIZES ====================

  /// Responsive font size getters
  ResponsiveFontSize get fontSize => ResponsiveFontSize._(this);

  // ==================== RESPONSIVE DIMENSIONS ====================

  /// Responsive dimension getters
  ResponsiveDimensions get dimensions => ResponsiveDimensions._(this);

  // ==================== RESPONSIVE LAYOUT ====================

  /// Get number of columns for grid layout
  int get gridColumns {
    if (isLargeDesktop) return 4;
    if (isDesktop) return 3;
    if (isTablet) return 2;
    return 1;
  }

  /// Get container padding
  double get containerPadding {
    if (isDesktop) return DesignConstants.containerPaddingDesktop;
    if (isTablet) return DesignConstants.containerPaddingTablet;
    return DesignConstants.containerPaddingMobile;
  }

  /// Get section spacing
  double get sectionSpacing {
    if (isDesktop) return DesignConstants.sectionSpacingDesktop;
    if (isTablet) return DesignConstants.sectionSpacingTablet;
    return DesignConstants.sectionSpacingMobile;
  }

  /// Get max content width
  double get maxContentWidth {
    if (isLargeDesktop) return 1400;
    if (isDesktop) return 1200;
    if (isTablet) return 900;
    return double.infinity;
  }

  // ==================== RESPONSIVE WIDGETS ====================

  /// Build different widgets for different screen sizes
  Widget when({
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
    Widget? largeDesktop,
  }) {
    if (isLargeDesktop && largeDesktop != null) return largeDesktop;
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Build widget with builder pattern
  Widget builder({
    required Widget Function(BuildContext context, Responsive responsive) builder,
  }) {
    return builder(context, this);
  }

  // ==================== SCALE FACTORS ====================

  /// Get scale factor based on screen size (1.0 = mobile baseline)
  double get scaleFactor {
    if (isLargeDesktop) return 1.3;
    if (isDesktop) return 1.2;
    if (isTablet) return 1.1;
    return 1.0;
  }

  /// Scale a value based on screen size
  double scale(double value) => value * scaleFactor;

  /// Responsive width percentage
  double wp(double percentage) => width * (percentage / 100);

  /// Responsive height percentage
  double hp(double percentage) => height * (percentage / 100);

  /// Responsive size (using smaller dimension)
  double sp(double percentage) {
    final smallerDimension = width < height ? width : height;
    return smallerDimension * (percentage / 100);
  }
}

// ==================== RESPONSIVE SPACING ====================

class ResponsiveSpacing {
  final Responsive _responsive;

  ResponsiveSpacing._(this._responsive);

  double get xs => _responsive.getValue(
        mobile: DesignConstants.spacingXSmall,
        desktop: DesignConstants.spacingXSmall * 1.2,
      );

  double get small => _responsive.getValue(
        mobile: DesignConstants.spacingSmall,
        desktop: DesignConstants.spacingSmall * 1.2,
      );

  double get medium => _responsive.getValue(
        mobile: DesignConstants.spacingMedium,
        desktop: DesignConstants.spacingMedium * 1.2,
      );

  double get large => _responsive.getValue(
        mobile: DesignConstants.spacingLarge,
        desktop: DesignConstants.spacingLarge * 1.2,
      );

  double get xl => _responsive.getValue(
        mobile: DesignConstants.spacingXLarge,
        desktop: DesignConstants.spacingXLarge * 1.2,
      );

  double get xxl => _responsive.getValue(
        mobile: DesignConstants.spacing2XLarge,
        desktop: DesignConstants.spacing2XLarge * 1.2,
      );

  double get xxxl => _responsive.getValue(
        mobile: DesignConstants.spacing3XLarge,
        desktop: DesignConstants.spacing3XLarge * 1.2,
      );
}

// ==================== RESPONSIVE FONT SIZES ====================

class ResponsiveFontSize {
  final Responsive _responsive;

  ResponsiveFontSize._(this._responsive);

  /// Display Large (Hero titles)
  double get displayLarge => _responsive.getValue(
        mobile: 40,
        tablet: 56,
        desktop: 72,
        largeDesktop: 80,
      );

  /// Display Medium
  double get displayMedium => _responsive.getValue(
        mobile: 32,
        tablet: 40,
        desktop: 56,
        largeDesktop: 64,
      );

  /// Display Small
  double get displaySmall => _responsive.getValue(
        mobile: 28,
        tablet: 32,
        desktop: 40,
        largeDesktop: 48,
      );

  /// Heading 1
  double get h1 => _responsive.getValue(
        mobile: 24,
        tablet: 28,
        desktop: 32,
        largeDesktop: 36,
      );

  /// Heading 2
  double get h2 => _responsive.getValue(
        mobile: 20,
        tablet: 24,
        desktop: 28,
        largeDesktop: 32,
      );

  /// Heading 3
  double get h3 => _responsive.getValue(
        mobile: 18,
        tablet: 20,
        desktop: 24,
        largeDesktop: 28,
      );

  /// Heading 4
  double get h4 => _responsive.getValue(
        mobile: 16,
        tablet: 18,
        desktop: 20,
        largeDesktop: 22,
      );

  /// Body Large
  double get bodyLarge => _responsive.getValue(
        mobile: 16,
        desktop: 18,
        largeDesktop: 20,
      );

  /// Body Medium
  double get bodyMedium => _responsive.getValue(
        mobile: 14,
        desktop: 16,
      );

  /// Body Small
  double get bodySmall => _responsive.getValue(
        mobile: 12,
        desktop: 14,
      );

  /// Caption
  double get caption => _responsive.getValue(
        mobile: 12,
        desktop: 13,
      );

  /// Button text
  double get button => _responsive.getValue(
        mobile: 14,
        desktop: 16,
      );
}

// ==================== RESPONSIVE DIMENSIONS ====================

class ResponsiveDimensions {
  final Responsive _responsive;

  ResponsiveDimensions._(this._responsive);

  /// Icon sizes
  double get iconSmall => _responsive.getValue(
        mobile: 16,
        desktop: 18,
      );

  double get iconMedium => _responsive.getValue(
        mobile: 24,
        desktop: 28,
      );

  double get iconLarge => _responsive.getValue(
        mobile: 32,
        desktop: 40,
      );

  double get iconXL => _responsive.getValue(
        mobile: 48,
        desktop: 56,
      );

  /// Button heights
  double get buttonHeight => _responsive.getValue(
        mobile: 48,
        desktop: 56,
      );

  double get buttonHeightSmall => _responsive.getValue(
        mobile: 36,
        desktop: 40,
      );

  double get buttonHeightLarge => _responsive.getValue(
        mobile: 56,
        desktop: 64,
      );

  /// Input heights
  double get inputHeight => _responsive.getValue(
        mobile: 48,
        desktop: 56,
      );

  /// Avatar sizes
  double get avatarSmall => _responsive.getValue(
        mobile: 32,
        desktop: 40,
      );

  double get avatarMedium => _responsive.getValue(
        mobile: 48,
        desktop: 56,
      );

  double get avatarLarge => _responsive.getValue(
        mobile: 64,
        desktop: 80,
      );

  double get avatarXL => _responsive.getValue(
        mobile: 96,
        desktop: 120,
      );

  /// Card dimensions
  double get cardMinHeight => _responsive.getValue(
        mobile: 200,
        tablet: 250,
        desktop: 300,
      );

  double get cardMaxWidth => _responsive.getValue(
        mobile: double.infinity,
        tablet: 400,
        desktop: 450,
      );

  /// Hero section height
  double get heroHeight => _responsive.getValue(
        mobile: _responsive.height * 0.7,
        tablet: _responsive.height * 0.8,
        desktop: _responsive.height * 0.9,
      );
}

// ==================== RESPONSIVE WIDGET ====================

/// Responsive widget that rebuilds on screen size changes
class ResponsiveWidget extends StatelessWidget {
  final Widget Function(BuildContext context, Responsive responsive) builder;

  const ResponsiveWidget({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, Responsive.of(context));
  }
}

// ==================== RESPONSIVE LAYOUT BUILDER ====================

/// Build different layouts for different screen sizes
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive.of(context).when(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }
}

// ==================== RESPONSIVE PADDING ====================

/// Responsive padding widget
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double? mobile;
  final double? tablet;
  final double? desktop;
  final double? largeDesktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final padding = responsive.getValue(
      mobile: mobile ?? DesignConstants.containerPaddingMobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );

    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}

// ==================== RESPONSIVE CONTAINER ====================

/// Responsive container with max width constraint
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.margin,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Container(
      alignment: alignment ?? Alignment.center,
      padding: padding,
      margin: margin,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? responsive.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}

// ==================== RESPONSIVE TEXT ====================

/// Text widget with responsive font size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final fontSize = responsive.getValue(
      mobile: mobileFontSize ?? 14,
      tablet: tabletFontSize,
      desktop: desktopFontSize,
    );

    return Text(
      text,
      style: style?.copyWith(fontSize: fontSize) ??
          TextStyle(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
