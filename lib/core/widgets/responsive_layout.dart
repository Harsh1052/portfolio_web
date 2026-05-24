import 'package:flutter/widgets.dart';

abstract final class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;

  // Max width for main content column (prose, cards)
  static const double maxContent = 860;
  // Max width for the overall page wrapper
  static const double maxPage = 1200;

  // Horizontal padding per viewport
  static const double paddingMobile = 20;
  static const double paddingTablet = 40;
  static const double paddingDesktop = 80;
}

/// Chooses between mobile / tablet / desktop builders via LayoutBuilder.
/// Tablet falls back to mobile builder if not supplied.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        if (w >= Breakpoints.tablet) return desktop(context);
        if (w >= Breakpoints.mobile && tablet != null) return tablet!(context);
        return mobile(context);
      },
    );
  }
}

/// Centers content at [maxWidth] with responsive horizontal padding.
/// Padding is applied OUTSIDE the max-width constraint so the content
/// column is never compressed on large screens.
class ContentWrapper extends StatelessWidget {
  const ContentWrapper({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContent,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        // On desktop the ConstrainedBox centres the column; no extra padding needed.
        final hPad = w < Breakpoints.mobile
            ? Breakpoints.paddingMobile
            : w < Breakpoints.tablet
                ? Breakpoints.paddingTablet
                : 0.0;

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
