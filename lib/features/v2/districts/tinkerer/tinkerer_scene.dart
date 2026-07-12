import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/motion_tokens.dart';
import '../../core/progress_utils.dart';
import '../../widgets/stamp.dart';
import '../../widgets/story_panel.dart';
import 'fairground_painter.dart';

/// Tinkerers' Park — the side-project chapter (nights & weekends):
///
/// | band        | what happens                                            |
/// |-------------|---------------------------------------------------------|
/// | 0.00 – 0.10 | arrival — string lights twinkle on over the fair        |
/// | 0.06 – 0.26 | tents rise, the ferris wheel starts turning with scroll |
/// | 0.16 – 0.40 | beat 1 · Trovo, the treasure hunt                       |
/// | 0.25 – 0.75 | the v1 bug walks through (scroll carries it)            |
/// | 0.40 – 0.62 | beat 2 · this site is the playground                    |
/// | 0.62 – 0.86 | beat 3 · learning out loud + project chips              |
/// | 0.88 – 1.00 | the fair dims — last stop: The Harbor (coming soon)     |
class TinkererScene extends StatefulWidget {
  const TinkererScene({super.key, required this.progress});

  final ValueListenable<double> progress;

  @override
  State<TinkererScene> createState() => _TinkererSceneState();
}

class _TinkererSceneState extends State<TinkererScene>
    with SingleTickerProviderStateMixin {
  static const _accent = Color(0xFFF472B6);

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
    'Trovo',
    'City of Code',
    'Analytics Engine',
    'Ambience Engine',
    'Bug Hunt Game',
    'Python (learning)',
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
            // ── The fairground ──
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ticker,
                builder: (_, __) => CustomPaint(
                  painter: FairgroundPainter(
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
                        "Tinkerers' Park",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 34 : 52,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'nights & weekends · where ideas ride for free',
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
                title: 'Trovo — the treasure hunt',
                body:
                    'A location-based treasure hunt game, built end to end on '
                    'nights and weekends: geo systems, hunt mechanics, the '
                    'works. All systems built — content phase next. Side '
                    'projects are where you take the risks client work '
                    'won\'t let you.',
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
                title: 'You\'re standing in one',
                body:
                    'This site is the playground: a first-party analytics '
                    'engine, a sky that matches your local weather, a bug-hunt '
                    'mini-game — say hi to the bug walking past — and this '
                    'whole scrolling city. Every experiment here taught '
                    'something a tutorial couldn\'t.',
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
                title: 'Learning out loud',
                body:
                    'Writing on Medium about what I build, and learning Python '
                    'to see the other side of the API — not just consuming '
                    'backends, but designing them. The park never closes; '
                    'something is always under construction here.',
              ),
            ),
            // ── Project chips ──
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
            // ── Stamp #6, by the ticket booth ──
            if (stampShow > 0)
              Align(
                alignment: isMobile
                    ? const Alignment(0.78, 0.66)
                    : const Alignment(0.84, 0.62),
                child: Opacity(
                  opacity: stampShow.clamp(0.0, 1.0),
                  child: const CollectibleStamp(
                    id: 'tinkerer',
                    label: 'Tinkerer stamp',
                    color: Color(0xFFF472B6),
                    icon: Icons.attractions_rounded,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
