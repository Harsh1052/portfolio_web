import 'package:flutter/animation.dart';

/// Choreography helper: slice one 0..1 district progress into overlapping
/// bands, so a scene reads like a score:
///
/// ```dart
/// final doorsOpen = t.band(0.25, 0.70, curve: Curves.easeInOutCubic);
/// final titleFade = 1 - t.band(0.30, 0.55);
/// ```
extension ProgressBands on double {
  /// Remaps this value's [start]..[end] range to 0..1 (clamped), optionally
  /// shaped by [curve].
  double band(double start, double end, {Curve curve = Curves.linear}) {
    assert(end > start, 'band end must be greater than start');
    final t = ((this - start) / (end - start)).clamp(0.0, 1.0);
    return curve.transform(t);
  }
}
