import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/ambience/ambience_controller.dart';
import '../../core/motion_tokens.dart';
import '../../core/progress_utils.dart';
import '../../widgets/stamp.dart';
import 'city_skyline_painter.dart';
import 'gate_painter.dart';
import 'gate_particles.dart';

/// The City Gate, choreographed against local scroll progress:
///
/// | band        | what happens                                            |
/// |-------------|---------------------------------------------------------|
/// | 0.00 – 0.20 | arrival — name over the gate, hint bobbing              |
/// | 0.20 – 0.62 | doors swing open, light spills, skyline wakes, approach |
/// | 0.45 – 0.80 | headline stats revealed through the opening             |
/// | 0.72 – 1.00 | towers part, everything fades — we're inside            |
class GateScene extends StatefulWidget {
  const GateScene({super.key, required this.progress});

  final ValueListenable<double> progress;

  @override
  State<GateScene> createState() => _GateSceneState();
}

class _GateSceneState extends State<GateScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );

  @override
  void initState() {
    super.initState();
    if (!V2MotionSettings.instance.reduced.value) _ticker.repeat();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Color get _moteColor {
    if (Get.isRegistered<AmbienceController>()) {
      return Get.find<AmbienceController>().particleColor;
    }
    return const Color(0xFFFFD98A);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return ValueListenableBuilder<double>(
      valueListenable: widget.progress,
      builder: (context, t, _) {
        final open = t.band(0.20, 0.62, curve: Curves.easeInOutCubic);
        final part = t.band(0.72, 1.0, curve: Curves.easeInCubic);
        final approach = t.band(0.0, 1.0, curve: V2Motion.parallax);
        final nameFade = 1 - t.band(0.22, 0.48);
        final hintFade = 1 - t.band(0.06, 0.18);
        final statsIn = t.band(0.45, 0.62, curve: V2Motion.reveal);
        final statsOut = 1 - t.band(0.68, 0.82);
        final stampShow = t.band(0.10, 0.16) * (1 - t.band(0.60, 0.68));

        return Stack(
          fit: StackFit.expand,
          children: [
            // ── Far skyline (slow parallax) ──
            RepaintBoundary(
              child: CustomPaint(
                painter: CitySkylinePainter(
                  depth: 0,
                  reveal: open,
                  parallaxY: approach * 26,
                  groundY: 0.86,
                ),
              ),
            ),
            // ── Near skyline ──
            RepaintBoundary(
              child: CustomPaint(
                painter: CitySkylinePainter(
                  depth: 1,
                  reveal: open,
                  parallaxY: approach * 54,
                  groundY: 0.865,
                ),
              ),
            ),
            // ── Gate — scales up slightly as we walk toward it ──
            RepaintBoundary(
              child: Transform.scale(
                scale: 1 + approach * 0.16,
                alignment: const Alignment(0, .65),
                child: CustomPaint(
                  painter: GatePainter(
                    open: open,
                    part: part,
                    isMobile: isMobile,
                  ),
                ),
              ),
            ),
            // ── Dust motes in the light (ambience-tinted) ──
            RepaintBoundary(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _ticker,
                  builder: (_, __) => CustomPaint(
                    painter: GateParticlesPainter(
                      time: _ticker.value,
                      lift: t,
                      count: isMobile ? 22 : 54,
                      color: _moteColor,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
            // ── Name over the gate ──
            Align(
              alignment: const Alignment(0, -0.42),
              child: Opacity(
                opacity: nameFade,
                child: Transform.translate(
                  offset: Offset(0, -t * 90),
                  child: _NameBlock(isMobile: isMobile),
                ),
              ),
            ),
            // ── Stats revealed through the open doors ──
            if (statsIn > 0)
              Align(
                alignment: const Alignment(0, .18),
                child: Opacity(
                  opacity: (statsIn * statsOut).clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, (1 - statsIn) * 30),
                    child: _StatsRow(isMobile: isMobile),
                  ),
                ),
              ),
            // ── Scroll hint ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: Opacity(
                opacity: hintFade,
                child: _ScrollHint(ticker: _ticker),
              ),
            ),
            // ── Stamp #8, tucked by the city wall ──
            if (stampShow > 0)
              Align(
                alignment: isMobile
                    ? const Alignment(-0.8, 0.55)
                    : const Alignment(-0.86, 0.5),
                child: Opacity(
                  opacity: stampShow.clamp(0.0, 1.0),
                  child: const CollectibleStamp(
                    id: 'gate',
                    label: 'Gate stamp',
                    color: Color(0xFFFFD98A),
                    icon: Icons.location_city_rounded,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _NameBlock extends StatelessWidget {
  const _NameBlock({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFD98A), Color(0xFFF5B93E)],
          ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: Text(
            'HARSH SUREJA',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: isMobile ? 38 : 68,
              fontWeight: FontWeight.w600,
              letterSpacing: isMobile ? 3 : 6,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'W E L C O M E   T O   T H E   C I T Y   O F   C O D E',
          textAlign: TextAlign.center,
          style: GoogleFonts.jetBrainsMono(
            fontSize: isMobile ? 10 : 13,
            color: Colors.white.withValues(alpha: 0.85),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.isMobile});

  final bool isMobile;

  static const _stats = [
    ('5+', 'years of Flutter'),
    ('15+', 'apps shipped'),
    ('75K+', 'people served'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: isMobile ? 18 : 44,
      runSpacing: 14,
      children: [
        for (final (value, label) in _stats)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: isMobile ? 26 : 36,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFFD98A),
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 11 : 13,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _ScrollHint extends StatelessWidget {
  const _ScrollHint({required this.ticker});

  final AnimationController ticker;

  @override
  Widget build(BuildContext context) {
    final reduced = V2MotionSettings.instance.reduced.value;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'scroll to open the gates',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            letterSpacing: 1.2,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 6),
        reduced
            ? const Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.white70, size: 26)
            : AnimatedBuilder(
                animation: ticker,
                builder: (_, child) {
                  // Reuse the long ticker: fast bob from its fraction.
                  final bob =
                      Curves.easeInOut.transform((ticker.value * 10) % 1.0);
                  return Transform.translate(
                    offset: Offset(0, bob * 10),
                    child: child,
                  );
                },
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white70, size: 26),
              ),
      ],
    );
  }
}
