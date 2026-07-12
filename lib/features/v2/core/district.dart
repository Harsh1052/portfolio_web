import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Sky colors a district contributes to the journey-wide gradient.
///
/// The [SkyGradient] interpolates between adjacent districts' skies as the
/// visitor scrolls, stitching all scenes into one continuous world.
class DistrictSky {
  const DistrictSky({
    required this.top,
    required this.mid,
    required this.horizon,
  });

  final Color top;
  final Color mid;
  final Color horizon;

  static DistrictSky lerp(DistrictSky a, DistrictSky b, double t) => DistrictSky(
        top: Color.lerp(a.top, b.top, t)!,
        mid: Color.lerp(a.mid, b.mid, t)!,
        horizon: Color.lerp(a.horizon, b.horizon, t)!,
      );
}

/// Contract every district of the City of Code implements.
///
/// A district declares its identity, palette, and scroll length; the
/// [JourneyScrollEngine] hands it a live 0→1 local progress to choreograph
/// its scene against. Districts never touch raw scroll offsets.
abstract class District {
  const District();

  /// Stable id — also used for analytics events (`v2_<id>` dwell tracking).
  String get id;

  /// Display name, e.g. `Harvest Valley`.
  String get title;

  /// Chapter tagline, e.g. `2024–2026 · FarmSetu`.
  String get subtitle;

  /// Scroll length in viewport-heights (≥ 1). Longer = more choreography room.
  double get scrollLengthFactor;

  /// Sky contribution for the journey-wide gradient.
  DistrictSky get sky;

  /// Accent color (map rail dot, headings).
  Color get accent;

  /// Build the scene. [progress] is this district's local scroll progress:
  /// 0 when its top reaches the viewport top, 1 when fully scrolled through.
  Widget build(BuildContext context, ValueListenable<double> progress);
}
