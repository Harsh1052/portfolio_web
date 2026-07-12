import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/motion_tokens.dart';
import '../../core/progress_utils.dart';
import '../../widgets/stamp.dart';
import '../../widgets/story_panel.dart';
import 'candlestick_skyline_painter.dart';
import 'market_simulator.dart';
import 'progress_deltas.dart';
import 'ticker_tape.dart';

/// The Exchange — the Kotak Securities chapter (2026–present):
///
/// | band        | what happens                                            |
/// |-------------|---------------------------------------------------------|
/// | 0.00 – 0.12 | arrival — night district title, ticker tape flows in    |
/// | 0.08 – 0.30 | skyline-as-chart: candles rise, chart grid reveals       |
/// | 0.16 – 0.40 | beat 1 · real time, real money (WebSocket streaming)    |
/// | 0.40 – 0.62 | beat 2 · architecture under pressure                    |
/// | 0.62 – 0.84 | beat 3 · same rule, new domain + tech chips             |
/// | 0.84 – 1.00 | lights dim — end of the built city (for now)            |
///
/// All market data is a clearly fictional simulation (tech-pun tickers) —
/// the streaming mechanics are the exhibit, not the prices.
class ExchangeScene extends StatefulWidget {
  const ExchangeScene({super.key, required this.progress});

  final ValueListenable<double> progress;

  @override
  State<ExchangeScene> createState() => _ExchangeSceneState();
}

class _ExchangeSceneState extends State<ExchangeScene>
    with SingleTickerProviderStateMixin {
  static const _green = Color(0xFF10B981);

  late final AnimationController _ticker = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  );
  late final MarketSimulator _market = MarketSimulator();

  @override
  void initState() {
    super.initState();
    if (!V2MotionSettings.instance.reduced.value) {
      _ticker.repeat();
      _market.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _market.dispose();
    super.dispose();
  }

  static const _chips = [
    'WebSockets',
    'BLoC / Cubit',
    'Clean Architecture',
    'GetIt · DI',
    'Unit Testing',
    'Git',
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final isMobile = mq.width < 700;

    // Panels on the right this time — the journey alternates sides.
    final panelAlign =
        isMobile ? const Alignment(0, -0.34) : const Alignment(0.72, -0.1);
    final panelWidth = isMobile ? mq.width - 48 : 430.0;

    return ValueListenableBuilder<double>(
      valueListenable: widget.progress,
      builder: (context, t, _) {
        final arrive = t.band(0.0, 0.10, curve: V2Motion.reveal);
        final titleFade = 1 - t.band(0.10, 0.18);
        final buildIn = t.band(0.08, 0.30, curve: Curves.easeOut);
        final gridReveal =
            t.band(0.10, 0.24) * (1 - t.band(0.30, 0.42));
        final chipsIn = t.band(0.64, 0.74);
        final chipsOut = 1 - t.band(0.80, 0.86);
        final dimOut = t.band(0.84, 1.0, curve: Curves.easeIn);
        final stampShow = t.band(0.20, 0.26) * (1 - t.band(0.80, 0.86));

        return Stack(
          fit: StackFit.expand,
          children: [
            // ── Candlestick skyline, trading live ──
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ticker,
                builder: (_, __) => ValueListenableBuilder<List<Quote>>(
                  valueListenable: _market.quotes,
                  builder: (_, quotes, __) => CustomPaint(
                    painter: CandlestickSkylinePainter(
                      buildIn: buildIn,
                      gridReveal: gridReveal,
                      time: _ticker.value,
                      deltas: CandleDeltas([
                        for (final q in quotes) q.price - q.lastPrice,
                      ]),
                      isMobile: isMobile,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
            // ── Ticker tape flowing under the top bar ──
            Align(
              alignment: const Alignment(0, -0.82),
              child: IgnorePointer(
                child: Opacity(
                  opacity: (arrive * (1 - dimOut)).clamp(0.0, 1.0),
                  child: RepaintBoundary(
                    // Decorative churn — meaningless to screen readers.
                    child: ExcludeSemantics(
                      child: TickerTape(quotes: _market.quotes, loop: _ticker),
                    ),
                  ),
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
                        'The Exchange',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 34 : 52,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '2026 – present · Kotak Securities · Flutter Developer',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: isMobile ? 11 : 13,
                          color: _green.withValues(alpha: 0.9),
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
                accent: _green,
                maxWidth: panelWidth,
                title: 'Real time, real money',
                body:
                    'June 2026 — I joined Kotak Securities to build trading '
                    'applications. Market data arrives as a live WebSocket '
                    'stream, and prices move faster than frames render. Every '
                    'dropped millisecond is a worse fill on someone\'s order.',
              ),
            ),
            Align(
              alignment: panelAlign,
              child: StoryPanel(
                t: t,
                start: 0.40,
                end: 0.62,
                accent: _green,
                maxWidth: panelWidth,
                title: 'Architecture under pressure',
                body:
                    'BLoC and Cubit state machines, Clean Architecture '
                    'boundaries, GetIt dependency injection, unit tests as a '
                    'reflex — in a regulated fintech environment, discipline '
                    'isn\'t a preference. It is the product.',
              ),
            ),
            Align(
              alignment: panelAlign,
              child: StoryPanel(
                t: t,
                start: 0.62,
                end: 0.84,
                accent: _green,
                maxWidth: panelWidth,
                title: 'Same rule, new domain',
                body:
                    'The lesson from farmers\' phones still applies: the '
                    'user\'s device is the only benchmark that matters. Only '
                    'now the stakes are measured in basis points — and slow '
                    'costs real money.',
              ),
            ),
            // ── Tech chips (no invented metrics — the stack is the stat) ──
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
                        for (var i = 0; i < _chips.length; i++)
                          Opacity(
                            opacity: t
                                .band(0.64 + i * 0.02, 0.70 + i * 0.02)
                                .clamp(0.0, 1.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _green.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _green.withValues(alpha: 0.5),
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
            // ── End-of-city dim ──
            IgnorePointer(
              child: ColoredBox(
                color: const Color(0xFF05070F).withValues(alpha: dimOut * 0.55),
              ),
            ),
            // ── Stamp #2, on the exchange floor ──
            if (stampShow > 0)
              Align(
                alignment: isMobile
                    ? const Alignment(-0.78, 0.66)
                    : const Alignment(-0.84, 0.62),
                child: Opacity(
                  opacity: stampShow.clamp(0.0, 1.0),
                  child: const CollectibleStamp(
                    id: 'exchange',
                    label: 'Exchange stamp',
                    color: Color(0xFF10B981),
                    icon: Icons.candlestick_chart_rounded,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
