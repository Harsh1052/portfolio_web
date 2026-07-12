import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/district.dart';
import '../widgets/illustration_texture.dart';
import '../widgets/scene_builder.dart';
import '../widgets/scene_piece.dart';

/// District 5 preview — Harvest Valley (the FarmSetu chapter).
///
/// Phase 0 ships this as the proof that the whole ported pipeline works:
/// grain texture background, [ScenePiece] with entrance choreography and
/// scroll-linked depth zoom, all composited by [SceneBuilder]. Full story
/// beats and parallax field layers arrive in Phase 2.
class ValleyDistrict extends District {
  const ValleyDistrict();

  @override
  String get id => 'valley';
  @override
  String get title => 'Harvest Valley';
  @override
  String get subtitle => '2024–2026 · FarmSetu';
  @override
  double get scrollLengthFactor => 2.0;
  @override
  DistrictSky get sky => const DistrictSky(
        top: Color(0xFF3D2160),
        mid: Color(0xFFDF6A46),
        horizon: Color(0xFFFFBE5C),
      );
  @override
  Color get accent => const Color(0xFFE8912E);

  @override
  Widget build(BuildContext context, ValueListenable<double> progress) {
    return SceneBuilder(
      bgBuilder: (context, anim) => [
        // Painterly paper: tinted speckle grain over the sky gradient.
        Positioned.fill(
          child: IllustrationTexture(
            'assets/v2/_common/speckles.png',
            color: const Color(0xFF8A5510).withValues(alpha: 0.4),
            opacity: anim,
          ),
        ),
      ],
      mgBuilder: (context, anim) => [
        ScenePiece(
          imagePath: 'assets/v2/valley/valley_hero.png',
          entrance: anim,
          zoom: progress,
          zoomAmt: .08,
          heightFactor: .62,
          minHeight: 320,
          initialOffset: const Offset(0, 60),
          initialScale: .92,
          fractionalOffset: const Offset(0, .04),
        ),
      ],
      fgBuilder: (context, anim) => [
        Positioned(
          left: 0,
          right: 0,
          bottom: 48,
          child: FadeTransition(
            opacity: anim,
            child: Column(
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$subtitle · 15,000 farmers on budget phones',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
