import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/motion_tokens.dart';
import '../../core/progress_utils.dart';
import '../../widgets/stamp.dart';
import '../../widgets/stat_counter.dart';
import '../../widgets/story_panel.dart';
import 'valley_rain_painter.dart';
import 'wheat_field_painter.dart';

/// Harvest Valley — the FarmSetu chapter, told in three beats:
///
/// | band        | what happens                                             |
/// |-------------|----------------------------------------------------------|
/// | 0.00 – 0.14 | arrival — title over golden fields, hero art rises       |
/// | 0.14 – 0.36 | beat 1 · sole engineer of the whole stack                |
/// | 0.34 – 0.60 | beat 2 · the farmer's phone — monsoon rolls in and rains |
/// | 0.60 – 0.84 | beat 3 · the lesson + scroll-scrubbed stats              |
/// | 0.82 – 1.00 | sunset → night, handing off to the Exchange              |
class ValleyScene extends StatefulWidget {
  const ValleyScene({super.key, required this.progress});

  final ValueListenable<double> progress;

  @override
  State<ValleyScene> createState() => _ValleySceneState();
}

class _ValleySceneState extends State<ValleyScene>
    with SingleTickerProviderStateMixin {
  static const _accent = Color(0xFFF5B93E);

  late final AnimationController _ticker = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
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

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final isMobile = mq.width < 700;

    return ValueListenableBuilder<double>(
      valueListenable: widget.progress,
      builder: (context, t, _) {
        final arrive = t.band(0.0, 0.12, curve: V2Motion.reveal);
        final titleFade = 1 - t.band(0.10, 0.18);
        final rain = t.band(0.34, 0.42) * (1 - t.band(0.54, 0.62));
        final night = t.band(0.82, 1.0, curve: Curves.easeInOut);
        final sunDrop = t.band(0.55, 0.95, curve: Curves.easeIn);
        final stampShow = t.band(0.16, 0.22) * (1 - t.band(0.80, 0.86));

        // Panel geometry: text left on desktop, centered on mobile.
        final panelAlign =
            isMobile ? const Alignment(0, -0.34) : const Alignment(-0.72, -0.1);
        final panelWidth = isMobile ? mq.width - 48 : 430.0;

        return Stack(
          fit: StackFit.expand,
          children: [
            // ── Setting sun (behind the fields) ──
            Align(
              alignment: Alignment(
                lerpDouble(0.45, 0.75, sunDrop)!,
                lerpDouble(-0.45, 0.85, sunDrop)!,
              ),
              child: IgnorePointer(
                child: Opacity(
                  opacity: (1 - night) * (1 - rain * .5),
                  child: Container(
                    width: isMobile ? 90 : 130,
                    height: isMobile ? 90 : 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFFFF6D8),
                          Color(0xFFFFD98A),
                          Color(0x00FFB84D),
                        ],
                        stops: [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ── Parallax wheat fields ──
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ticker,
                builder: (_, __) => CustomPaint(
                  painter: WheatFieldPainter(
                    time: _ticker.value,
                    progress: t,
                    night: night,
                    sway: !V2MotionSettings.instance.reduced.value,
                    isMobile: isMobile,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
            // ── Hero illustration (farmhouse hill) ──
            Align(
              alignment: Alignment(isMobile ? 0 : 0.82, 1),
              child: IgnorePointer(
                child: Opacity(
                  opacity: (arrive * (1 - night * .9)).clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(t * -26, (1 - arrive) * 70),
                    child: Transform.scale(
                      scale: 1 + t * 0.05,
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/v2/valley/valley_hero.png',
                        height: mq.height * (isMobile ? 0.36 : 0.56),
                        fit: BoxFit.contain,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ── Arrival title ──
            Align(
              alignment: const Alignment(0, -0.5),
              child: IgnorePointer(
                child: Opacity(
                  opacity: (arrive * titleFade).clamp(0.0, 1.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Harvest Valley',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 34 : 52,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '2024–2026 · FarmSetu · sole mobile & web engineer',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: isMobile ? 11 : 13,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Story beats ──
            Align(
              alignment: panelAlign,
              child: StoryPanel(
                t: t,
                start: 0.14,
                end: 0.36,
                accent: _accent,
                maxWidth: panelWidth,
                title: 'The whole stack, mine',
                body:
                    'June 2024 — I joined FarmSetu as the sole engineer for the '
                    'entire mobile and web stack. Architecture, releases, '
                    'performance, observability — all of it mine to figure out. '
                    'That kind of ownership forces you to grow faster than any '
                    'tutorial can.',
              ),
            ),
            Align(
              alignment: panelAlign,
              child: StoryPanel(
                t: t,
                start: 0.36,
                end: 0.60,
                accent: _accent,
                maxWidth: panelWidth,
                title: "The farmer's phone",
                body:
                    'On a field visit, a farmer told me the app was too slow and '
                    'burned through his mobile data. We had tested on WiFi, on '
                    'flagship phones. That one conversation changed how I build: '
                    'payloads shrank, calls were cut, unchanged data got cached. '
                    'His phone was the only benchmark that mattered.',
              ),
            ),
            Align(
              alignment: panelAlign,
              child: StoryPanel(
                t: t,
                start: 0.60,
                end: 0.84,
                accent: _accent,
                maxWidth: panelWidth,
                title: 'Ship like no one will catch your bugs',
                body:
                    'When no one else reviews your code, you write it '
                    'differently. You read your own pull requests like a '
                    'stranger. You build the safety net yourself — and the '
                    'numbers follow.',
              ),
            ),
            // ── Scroll-scrubbed stats under beat 3 ──
            Align(
              alignment:
                  isMobile ? const Alignment(0, 0.42) : const Alignment(-0.72, 0.52),
              child: IgnorePointer(
                child: Opacity(
                  opacity:
                      (t.band(0.62, 0.70) * (1 - t.band(0.80, 0.86))).clamp(0.0, 1.0),
                  child: Wrap(
                    spacing: isMobile ? 20 : 36,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      StatCounter(
                        t: t,
                        start: 0.62,
                        end: 0.78,
                        target: 15000,
                        suffix: '+',
                        label: 'farmers served daily',
                        accent: _accent,
                        compact: isMobile,
                      ),
                      StatCounter(
                        t: t,
                        start: 0.62,
                        end: 0.78,
                        target: 45,
                        suffix: '%',
                        label: 'faster app',
                        accent: _accent,
                        compact: isMobile,
                      ),
                      StatCounter(
                        t: t,
                        start: 0.62,
                        end: 0.78,
                        target: 87,
                        suffix: '%',
                        label: 'quicker releases (4h → 1 click)',
                        accent: _accent,
                        compact: isMobile,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Monsoon ──
            RepaintBoundary(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _ticker,
                  builder: (_, __) => CustomPaint(
                    painter: ValleyRainPainter(
                      time: _ticker.value,
                      intensity: rain,
                      isMobile: isMobile,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
            // ── Night handoff to the Exchange ──
            IgnorePointer(
              child: ColoredBox(
                color: const Color(0xFF0B1220).withValues(alpha: night * 0.5),
              ),
            ),
            // ── Stamp #1, tucked by the fields ──
            if (stampShow > 0)
              Align(
                alignment: isMobile
                    ? const Alignment(0.78, 0.66)
                    : const Alignment(-0.86, 0.68),
                child: Opacity(
                  opacity: stampShow.clamp(0.0, 1.0),
                  child: const CollectibleStamp(
                    id: 'valley',
                    label: 'Valley stamp',
                    color: Color(0xFFF5B93E),
                    icon: Icons.grass_rounded,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
