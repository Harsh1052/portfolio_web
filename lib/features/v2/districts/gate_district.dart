import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/district.dart';
import '../core/motion_tokens.dart';

/// District 1 — The City Gate. Phase 0 ships the typographic welcome and
/// scroll invitation; the illustrated gate scene arrives in Phase 1.
class GateDistrict extends District {
  const GateDistrict();

  @override
  String get id => 'gate';
  @override
  String get title => 'The City Gate';
  @override
  String get subtitle => 'Welcome to the City of Code';
  @override
  double get scrollLengthFactor => 1.6;
  @override
  DistrictSky get sky => const DistrictSky(
        top: Color(0xFF191036),
        mid: Color(0xFF3D2160),
        horizon: Color(0xFFB03D66),
      );
  @override
  Color get accent => const Color(0xFFF5B93E);

  @override
  Widget build(BuildContext context, ValueListenable<double> progress) {
    return ValueListenableBuilder<double>(
      valueListenable: progress,
      builder: (context, t, _) {
        // Title drifts up and fades as the visitor walks through the gate.
        final drift = t * 120;
        final fade = (1 - t * 1.6).clamp(0.0, 1.0);

        return Stack(
          children: [
            Center(
              child: Transform.translate(
                offset: Offset(0, -drift),
                child: Opacity(
                  opacity: fade,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'HARSH SUREJA',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize:
                              MediaQuery.of(context).size.width < 700 ? 40 : 72,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 4,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Welcome to the City of Code',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 16,
                          color: const Color(0xFFF5B93E),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Flutter Developer · 5+ years · 15+ apps shipped\n'
                        '75,000+ people use what I build',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          height: 1.7,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Scroll invitation, pinned near the bottom of the viewport.
            Positioned(
              left: 0,
              right: 0,
              bottom: 36,
              child: Opacity(
                opacity: fade,
                child: const _ScrollHint(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScrollHint extends StatefulWidget {
  const _ScrollHint();

  @override
  State<_ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<_ScrollHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = V2MotionSettings.instance.reduced.value;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'scroll to enter the city',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            letterSpacing: 1.2,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        reduced
            ? const Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.white70, size: 26)
            : AnimatedBuilder(
                animation: _bob,
                builder: (_, child) => Transform.translate(
                  offset: Offset(
                      0, Curves.easeInOut.transform(_bob.value) * 10),
                  child: child,
                ),
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white70, size: 26),
              ),
      ],
    );
  }
}
