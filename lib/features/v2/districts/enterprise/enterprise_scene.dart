import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/motion_tokens.dart';
import '../../core/progress_utils.dart';
import '../../widgets/stamp.dart';
import '../../widgets/stat_counter.dart';
import '../../widgets/story_panel.dart';
import 'glass_towers_painter.dart';

/// Enterprise Heights — the Elision Infotech chapter (2023–2024):
///
/// | band        | what happens                                            |
/// |-------------|---------------------------------------------------------|
/// | 0.00 – 0.10 | arrival — blue hour, towers rise                        |
/// | 0.16 – 0.40 | beat 1 · enterprise scale                               |
/// | 0.34 – 0.56 | the widest tower's windows light up to spell 50K        |
/// | 0.40 – 0.62 | beat 2 · leading the floor                              |
/// | 0.58 – 0.80 | crash-rate graph falls; beat 3 · hardening the towers   |
/// | 0.62 – 0.80 | scroll-scrubbed counters                                |
/// | 0.88 – 1.00 | lights dim — down the hill toward Harvest Valley        |
class EnterpriseScene extends StatefulWidget {
  const EnterpriseScene({super.key, required this.progress});

  final ValueListenable<double> progress;

  @override
  State<EnterpriseScene> createState() => _EnterpriseSceneState();
}

class _EnterpriseSceneState extends State<EnterpriseScene>
    with SingleTickerProviderStateMixin {
  static const _accent = Color(0xFF7DD3FC);

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

    final panelAlign =
        isMobile ? const Alignment(0, -0.34) : const Alignment(0.72, -0.1);
    final panelWidth = isMobile ? mq.width - 48 : 430.0;

    return ValueListenableBuilder<double>(
      valueListenable: widget.progress,
      builder: (context, t, _) {
        final arrive = t.band(0.0, 0.10, curve: V2Motion.reveal);
        final titleFade = 1 - t.band(0.10, 0.18);
        final countersIn = t.band(0.62, 0.70);
        final countersOut = 1 - t.band(0.80, 0.86);
        final stampShow = t.band(0.18, 0.24) * (1 - t.band(0.80, 0.86));

        return Stack(
          fit: StackFit.expand,
          children: [
            // ── Glass towers ──
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ticker,
                builder: (_, __) => CustomPaint(
                  painter: GlassTowersPainter(
                    t: t,
                    time: _ticker.value,
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
                        'Enterprise Heights',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 34 : 52,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '2023–2024 · Elision Infotech · Senior Flutter Developer',
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
                title: 'Enterprise scale',
                body:
                    'January 2023, Elision Infotech — my first "Senior" in the '
                    'title and my first taste of scale: eight-plus enterprise '
                    'apps serving fifty thousand people. Watch the big tower — '
                    'that\'s what fifty thousand lit windows feels like.',
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
                title: 'Leading the floor',
                body:
                    'Three Flutter developers, daily code reviews, shared '
                    'standards — my first time being the elevator instead of '
                    'the passenger. Payment gateways, cloud messaging, '
                    'analytics: the plumbing enterprise apps live or die by.',
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
                title: 'Hardening the towers',
                body:
                    'Scale punishes sloppiness. Unit tests, widget tests, and '
                    'real error handling cut crash rates by sixty percent — '
                    'watch the graph fall. Leaner builds shipped faster and '
                    'downloaded smaller. Reliability is a feature.',
              ),
            ),
            // ── Scroll-scrubbed counters ──
            Align(
              alignment: isMobile
                  ? const Alignment(0, 0.42)
                  : const Alignment(-0.68, 0.62),
              child: IgnorePointer(
                child: Opacity(
                  opacity: (countersIn * countersOut).clamp(0.0, 1.0),
                  child: Wrap(
                    spacing: isMobile ? 20 : 36,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      StatCounter(
                        t: t,
                        start: 0.62,
                        end: 0.78,
                        target: 50000,
                        suffix: '+',
                        label: 'active users',
                        accent: _accent,
                        compact: isMobile,
                      ),
                      StatCounter(
                        t: t,
                        start: 0.62,
                        end: 0.78,
                        target: 60,
                        suffix: '%',
                        label: 'fewer crashes',
                        accent: _accent,
                        compact: isMobile,
                      ),
                      StatCounter(
                        t: t,
                        start: 0.62,
                        end: 0.78,
                        target: 8,
                        suffix: '+',
                        label: 'enterprise apps',
                        accent: _accent,
                        compact: isMobile,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Stamp #5, in the tower plaza ──
            if (stampShow > 0)
              Align(
                alignment: isMobile
                    ? const Alignment(0.78, 0.66)
                    : const Alignment(-0.84, 0.62),
                child: Opacity(
                  opacity: stampShow.clamp(0.0, 1.0),
                  child: const CollectibleStamp(
                    id: 'enterprise',
                    label: 'Enterprise stamp',
                    color: Color(0xFF7DD3FC),
                    icon: Icons.apartment_rounded,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
