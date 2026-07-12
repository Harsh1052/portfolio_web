import 'package:flutter/material.dart';
import 'district.dart';
import 'journey_scroll_engine.dart';

/// Journey-wide sky. Paints a vertical gradient interpolated between
/// adjacent districts' [DistrictSky]s as the visitor scrolls, so dawn at
/// the Gate melts into Harvest Valley gold and Exchange night without a
/// single hard cut.
class SkyGradient extends StatelessWidget {
  const SkyGradient({super.key, required this.engine});

  final JourneyScrollEngine engine;

  @override
  Widget build(BuildContext context) {
    final skies = [for (final d in engine.districts) d.sky];

    return ValueListenableBuilder<double>(
      valueListenable: engine.journeyProgress,
      builder: (context, t, _) {
        final DistrictSky sky;
        if (skies.length == 1) {
          sky = skies.first;
        } else {
          final u = (t * (skies.length - 1)).clamp(0.0, skies.length - 1.0);
          final i = u.floor().clamp(0, skies.length - 2);
          sky = DistrictSky.lerp(skies[i], skies[i + 1], u - i);
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
