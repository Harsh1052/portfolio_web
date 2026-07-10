import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'analytics_service.dart';

/// Wraps a portfolio section and reports enter/exit to [AnalyticsService],
/// which turns the pair into a dwell-time measurement.
///
/// A section counts as "viewed" while ≥ 35% of it is on screen — generous
/// enough for tall sections that never fully fit in the viewport.
class TrackedSection extends StatelessWidget {
  const TrackedSection({super.key, required this.name, required this.child});

  final String name;
  final Widget child;

  static const _threshold = 0.35;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('tracked-section-$name'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= _threshold) {
          AnalyticsService.sectionEnter(name);
        } else {
          AnalyticsService.sectionExit(name);
        }
      },
      child: child,
    );
  }
}

/// Tracks how deep visitors scroll the page, firing once per milestone
/// (25 / 50 / 75 / 100 %).
class ScrollDepthTracker extends StatelessWidget {
  const ScrollDepthTracker({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (n) {
        final max = n.metrics.maxScrollExtent;
        if (max <= 0) return false;
        final pct = (n.metrics.pixels / max * 100).clamp(0, 100);
        for (final milestone in const [25, 50, 75, 100]) {
          if (pct >= milestone) AnalyticsService.scrollDepth(milestone);
        }
        return false; // keep bubbling
      },
      child: child,
    );
  }
}
