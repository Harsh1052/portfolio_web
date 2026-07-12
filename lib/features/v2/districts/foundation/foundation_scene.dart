import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/motion_tokens.dart';
import '../../core/progress_utils.dart';
import '../../widgets/stamp.dart';
import '../../widgets/story_panel.dart';
import 'construction_site_painter.dart';
import 'foundation_grid_painter.dart';

/// Foundation Square — where the city began (2017–2021):
///
/// | band        | what happens                                            |
/// |-------------|---------------------------------------------------------|
/// | 0.00 – 0.12 | arrival — drafting-paper grid unrolls over the morning  |
/// | 0.10 – 0.34 | blueprint outlines dash-draw the buildings-to-be        |
/// | 0.16 – 0.40 | beat 1 · GTU — every city starts with drawings          |
/// | 0.30 – 0.64 | steel frames rise; the crane lowers its beam            |
/// | 0.40 – 0.62 | beat 2 · first steel — the internship                   |
/// | 0.62 – 0.86 | beat 3 · topping out + milestone chips; tower finishes  |
/// | 0.86 – 1.00 | grid rolls away — on toward Harvest Valley              |
class FoundationScene extends StatefulWidget {
  const FoundationScene({super.key, required this.progress});

  final ValueListenable<double> progress;

  @override
  State<FoundationScene> createState() => _FoundationSceneState();
}

class _FoundationSceneState extends State<FoundationScene>
    with SingleTickerProviderStateMixin {
  static const _accent = Color(0xFF5FA8E8);

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

  static const _milestones = [
    'B.E. Computer Engineering · 2021',
    'Dart',
    'Flutter',
    'Git',
    'Scrum',
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final isMobile = mq.width < 700;

    // Alternating sides: gate center → foundation right → valley left.
    final panelAlign =
        isMobile ? const Alignment(0, -0.34) : const Alignment(0.72, -0.1);
    final panelWidth = isMobile ? mq.width - 48 : 430.0;

    return ValueListenableBuilder<double>(
      valueListenable: widget.progress,
      builder: (context, t, _) {
        final arrive = t.band(0.0, 0.10, curve: V2Motion.reveal);
        final titleFade = 1 - t.band(0.10, 0.18);
        final grid = t.band(0.04, 0.16) * (1 - t.band(0.86, 0.96));
        final outline = t.band(0.10, 0.34);
        final build = t.band(0.30, 0.64, curve: Curves.easeInOut);
        final craneDrop = t.band(0.34, 0.60, curve: Curves.easeInOut);
        final complete = t.band(0.64, 0.86);
        final chipsIn = t.band(0.66, 0.76);
        final chipsOut = 1 - t.band(0.82, 0.88);
        final stampShow = t.band(0.18, 0.24) * (1 - t.band(0.80, 0.86));

        return Stack(
          fit: StackFit.expand,
          children: [
            // ── Drafting-paper grid ──
            RepaintBoundary(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: FoundationGridPainter(reveal: grid),
                  size: Size.infinite,
                ),
              ),
            ),
            // ── Construction site ──
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ticker,
                builder: (_, __) => CustomPaint(
                  painter: ConstructionSitePainter(
                    outline: outline,
                    build: build,
                    complete: complete,
                    craneDrop: craneDrop,
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
                        'Foundation Square',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 34 : 52,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '2017–2021 · where the city began',
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
                title: 'Every city starts with drawings',
                body:
                    '2017, Gujarat Technological University — Computer '
                    'Engineering. Four years of fundamentals: data structures, '
                    'operating systems, software design. Blueprints feel '
                    'abstract until you realize every building you\'ll ever '
                    'ship comes from them.',
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
                title: 'First steel',
                body:
                    'January 2021 — Flutter intern at Across the Glob, '
                    'Bangalore. First real codebase, first standups, first '
                    'code review that stung. Eight months of learning how '
                    'software actually gets built — beam by beam.',
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
                title: 'Topping out',
                body:
                    'By August 2021 the foundation was set — and the first '
                    'tower of this city was ready for its own address. '
                    'Every district you\'ll walk through from here stands '
                    'on this square.',
              ),
            ),
            // ── Milestone chips ──
            Align(
              alignment: isMobile
                  ? const Alignment(0, 0.42)
                  : const Alignment(0.72, 0.52),
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
                        for (var i = 0; i < _milestones.length; i++)
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
                                _milestones[i],
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
            // ── Stamp #3, by the site office ──
            if (stampShow > 0)
              Align(
                alignment: isMobile
                    ? const Alignment(0.78, 0.66)
                    : const Alignment(-0.84, 0.62),
                child: Opacity(
                  opacity: stampShow.clamp(0.0, 1.0),
                  child: const CollectibleStamp(
                    id: 'foundation',
                    label: 'Foundation stamp',
                    color: Color(0xFF5FA8E8),
                    icon: Icons.architecture_rounded,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
