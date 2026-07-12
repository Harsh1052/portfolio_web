import 'package:flutter/material.dart';
import 'district.dart';
import 'journey_scroll_engine.dart';

/// Journey-wide sky. Paints a vertical gradient that holds each district's
/// [DistrictSky] through its scene and blends into the next only near the
/// boundary (driven by the engine's boundary-aligned `districtCoord`), so
/// dawn at the Gate melts into Harvest Valley gold and Exchange night
/// exactly where the districts meet.
class SkyGradient extends StatelessWidget {
  const SkyGradient({super.key, required this.engine});

  final JourneyScrollEngine engine;

  @override
  Widget build(BuildContext context) {
    final skies = [for (final d in engine.districts) d.sky];

    return ValueListenableBuilder<double>(
      valueListenable: engine.districtCoord,
      builder: (context, u, _) {
        final DistrictSky sky;
        if (skies.length == 1) {
          sky = skies.first;
        } else {
          final clamped = u.clamp(0.0, skies.length - 1.0);
          final i = clamped.floor().clamp(0, skies.length - 2);
          sky = DistrictSky.lerp(skies[i], skies[i + 1], clamped - i);
        }
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.55, 1.0],
              colors: [sky.top, sky.mid, sky.horizon],
            ),
          ),
        );
      },
    );
  }
}
