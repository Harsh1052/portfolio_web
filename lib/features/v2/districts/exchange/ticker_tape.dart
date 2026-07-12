import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'market_simulator.dart';

/// Seamlessly looping ticker tape fed by the market simulator — the
/// classic exchange-floor strip, flowing through the district.
class TickerTape extends StatelessWidget {
  const TickerTape({
    super.key,
    required this.quotes,
    required this.loop,
  });

  final ValueListenable<List<Quote>> quotes;

  /// Looping 0..1 value (from the scene ticker) driving the marquee.
  final Animation<double> loop;

  static const _green = Color(0xFF10B981);
  static const _red = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFF05070F).withValues(alpha: 0.78),
        border: const Border(
          top: BorderSide(color: Color(0xFF1E2A3F)),
          bottom: BorderSide(color: Color(0xFF1E2A3F)),
        ),
      ),
      child: ClipRect(
        child: ValueListenableBuilder<List<Quote>>(
          valueListenable: quotes,
          builder: (context, list, _) {
            final items = [
              for (final q in list) _QuoteChip(quote: q),
            ];
            return AnimatedBuilder(
              animation: loop,
              builder: (context, child) => FractionalTranslation(
                // Content is doubled below; −0.5 of own width = one full
                // copy → a perfectly seamless loop.
                translation: Offset(-((loop.value * 3) % 1) * 0.5, 0),
                child: child,
              ),
              child: OverflowBox(
                maxWidth: double.infinity,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [...items, ...items],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuoteChip extends StatelessWidget {
  const _QuoteChip({required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final up = quote.up;
    final color = up ? TickerTape._green : TickerTape._red;
    final pct = quote.pctChange;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            quote.symbol,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(width: 7),
          Text(
            quote.price.toStringAsFixed(2),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(width: 5),
          Icon(
            up ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
            size: 18,
            color: color,
          ),
          Text(
            '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(2)}%',
            style: GoogleFonts.jetBrainsMono(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }
}
