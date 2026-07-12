import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/motion_tokens.dart';
import '../../core/progress_utils.dart';
import '../../widgets/stamp.dart';
import '../../widgets/story_panel.dart';
import 'workshop_lane_painter.dart';

/// Craftsman's Lane — the Tagline Infotech chapter (2021–2022):
///
/// | band        | what happens                                            |
/// |-------------|---------------------------------------------------------|
/// | 0.00 – 0.10 | arrival — the lane wakes, facades rise                  |
/// | 0.12 – 0.22 | lanterns string across; gears start turning with scroll |
/// | 0.20 – 0.50 | shop signs flicker on, one craft at a time              |
/// | 0.16 – 0.40 | beat 1 · ten apps, two platforms                        |
/// | 0.40 – 0.62 | beat 2 · animation as craft                             |
/// | 0.62 – 0.86 | beat 3 · built to work offline + craft chips            |
/// | 0.88 – 1.00 | the lane dims, lanterns last — on toward the valley     |
class CraftsmanScene extends StatefulWidget {
  const CraftsmanScene({super.key, required this.progress});

  final ValueListenable<double> progress;

  @override
  State<CraftsmanScene> createState() => _CraftsmanSceneState();
}

class _CraftsmanSceneState extends State<CraftsmanScene>
    with SingleTickerProviderStateMixin {
  static const _accent = Color(0xFFFFB84D);

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

  static const _chips = [
    'Redux',
    'SQLite',
    'Hive',
    'Firebase',
    'Custom Animations',
    'Material Design',
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final isMobile = mq.width < 700;

    final panelAlign =
        isMobile ? const Alignment(0, -0.34) : const Alignment(-0.72, -0.1);
    final panelWidth = isMobile ? mq.width - 48 : 430.0;

    return ValueListenableBuilder<double>(
      valueListenable: widget.progress,
      builder: (context, t, _) {
        final arrive = t.band(0.0, 0.10, curve: V2Motion.reveal);
        final titleFade = 1 - t.band(0.10, 0.18);
        final chipsIn = t.band(0.66, 0.76);
        final chipsOut = 1 - t.band(0.82, 0.88);
        final stampShow = t.band(0.18, 0.24) * (1 - t.band(0.80, 0.86));

        return Stack(
          fit: StackFit.expand,
          children: [
            // ── The lane itself ──
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ticker,
                builder: (_, __) => CustomPaint(
                  painter: WorkshopLanePainter(
                    t: t,
                    time: _ticker.value,
                    sway: !V2MotionSettings.instance.reduced.value,
                    isMobile: isMobile,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
            // ── Arrival title ──
            Align(
              alignment: const Alignment(0, -0.52),
              child: IgnorePointer(
                child: Opacity(
                  opacity: (arrive * titleFade).clamp(0.0, 1.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Craftsman's Lane",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 34 : 52,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '2021–2022 · Tagline Infotech',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: isMobile ? 11 : 13,
                          color: _accent.withValues(alpha: 0.95),
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
                start: 0.16,
                end: 0.40,
                accent: _accent,
                maxWidth: panelWidth,
                title: 'Ten apps, two platforms',
                body:
                    'August 2021 — my first developer title, at Tagline '
                    'Infotech. Ten-plus apps across Android and iOS, each one '
                    'a small workshop: responsive layouts, adaptive UI, and '
                    'the discipline of making the same design feel native on '
                    'two platforms at once.',
              ),
            ),
            Align(
              alignment: panelAlign,
              child: StoryPanel(
                t: t,
                start: 0.40,
                end: 0.62,
                accent: _accent,
                maxWidth: panelWidth,
                title: 'Animation as craft',
                body:
                    'This is where I fell for Flutter\'s animation framework — '
                    'implicit, explicit, custom curves, hand-tuned motion. '
                    'Everything moving in this lane is built with what I '
                    'learned here. Good motion isn\'t decoration; it\'s how an '
                    'app tells you it\'s alive.',
              ),
            ),
            Align(
              alignment: panelAlign,
              child: StoryPanel(
                t: t,
                start: 0.62,
                end: 0.86,
                accent: _accent,
                maxWidth: panelWidth,
                title: 'Built to work offline',
                body:
                    'India\'s connectivity taught the next lesson early: '
                    'SQLite and Hive for offline-first persistence, Redux to '
                    'keep state predictable, Firebase when the network came '
                    'back. Apps that assume perfect networks are apps that '
                    'break.',
              ),
            ),
            // ── Craft chips ──
            Align(
              alignment: isMobile
                  ? const Alignment(0, 0.42)
                  : const Alignment(-0.72, 0.52),
              child: IgnorePointer(
                child: Opacity(
                  opacity: (chipsIn * chipsOut).clamp(0.0, 1.0),
                  child: SizedBox(
                    width: panelWidth,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var i = 0; i < _chips.length; i++)
                          Opacity(
                            opacity: t
                                .band(0.66 + i * 0.02, 0.72 + i * 0.02)
                                .clamp(0.0, 1.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _accent.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _accent.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                _chips[i],
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.92),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ── Stamp #4, hanging by a workshop door ──
            if (stampShow > 0)
              Align(
                alignment: isMobile
                    ? const Alignment(-0.78, 0.66)
                    : const Alignment(0.84, 0.62),
                child: Opacity(
                  opacity: stampShow.clamp(0.0, 1.0),
                  child: const CollectibleStamp(
                    id: 'craftsman',
                    label: 'Craftsman stamp',
                    color: Color(0xFFFFB84D),
                    icon: Icons.handyman_rounded,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
