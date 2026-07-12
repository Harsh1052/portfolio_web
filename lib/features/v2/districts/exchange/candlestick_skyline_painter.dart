import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'progress_deltas.dart';

/// The Exchange's signature moment: the skyline IS a candlestick chart.
///
/// Buildings are candle bodies (green/red) with wick antennas and lit
/// windows; a faint chart grid fades in behind them during the reveal so
/// the visitor "sees" the trick.
///
/// * [buildIn] 0..1 — candles rise from the ground, staggered left→right.
/// * [gridReveal] 0..1 — chart grid + baseline behind the skyline.
/// * [time] loops 0..1 — antenna beacons blink, live candles glow-pulse.
/// * [deltas] — live per-candle direction from the market simulator; the
///   first candles recolor with the stream so the skyline actually trades.
class CandlestickSkylinePainter extends CustomPainter {
  CandlestickSkylinePainter({
    required this.buildIn,
    required this.gridReveal,
    required this.time,
    required this.deltas,
    required this.isMobile,
  });

  final double buildIn;
  final double gridReveal;
  final double time;
  final CandleDeltas deltas;
  final bool isMobile;

  static const _green = Color(0xFF10B981);
  static const _greenDark = Color(0xFF065F46);
  static const _red = Color(0xFFEF4444);
  static const _redDark = Color(0xFF7F1D1D);
  static const _grid = Color(0xFF1E2A3F);
  static const _window = Color(0xFFBFE8D9);
  static const _ground = Color(0xFF05070F);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final groundY = h * 0.88;

    // ── Chart grid behind the skyline ──
    if (gridReveal > 0.01) {
      final gridPaint = Paint()
        ..color = _grid.withValues(alpha: .55 * gridReveal)
        ..strokeWidth = 1;
      for (var i = 1; i <= 5; i++) {
        final y = groundY - (groundY * .75) * (i / 5);
        canvas.drawLine(Offset(0, y), Offset(w * gridReveal, y), gridPaint);
      }
      // Baseline.
      canvas.drawLine(
        Offset(0, groundY),
        Offset(w, groundY),
        Paint()
          ..color = _grid.withValues(alpha: .9 * gridReveal)
          ..strokeWidth = 1.6,
      );
    }

    // ── Candle buildings ──
    final n = isMobile ? 8 : 14;
    final rnd = math.Random(17);
    final slotW = w / n;

    for (var i = 0; i < n; i++) {
      // Staggered rise, left to right.
      final stagger = i / n * 0.5;
      final riseT = ((buildIn - stagger) / 0.5).clamp(0.0, 1.0);
      if (riseT <= 0) continue;
      final rise = Curves.easeOutCubic.transform(riseT);

      final bodyW = slotW * (0.42 + rnd.nextDouble() * 0.18);
      final cx = slotW * i + slotW / 2;
      final fullH = h * (0.16 + rnd.nextDouble() * 0.34);
      final bodyH = fullH * rise;
      final top = groundY - bodyH;

      // Live direction for the first candles; seeded for the rest.
      final liveDelta = deltas.deltaFor(i);
      final isUp = liveDelta != null ? liveDelta >= 0 : rnd.nextBool();
      final body = isUp ? _green : _red;
      final shade = isUp ? _greenDark : _redDark;

      // Glow-pulse on live candles.
      if (liveDelta != null) {
        final pulse =
            0.22 + 0.16 * math.sin((time * 3 + i * .21) * math.pi * 2);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - bodyW / 2 - 5, top - 5, bodyW + 10, bodyH + 5),
            const Radius.circular(6),
          ),
          Paint()..color = body.withValues(alpha: pulse * rise),
        );
      }

      // Body.
      final rect = Rect.fromLTWH(cx - bodyW / 2, top, bodyW, bodyH + 2);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: const Radius.circular(3),
          topRight: const Radius.circular(3),
        ),
        Paint()..color = shade,
      );
      // Lit face (right side toward the "moon").
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(cx - bodyW / 2, top, bodyW * .5, bodyH + 2),
          topLeft: const Radius.circular(3),
        ),
        Paint()..color = body.withValues(alpha: .85),
      );

      // Wick antenna above + stub below the baseline.
      final wickPaint = Paint()
        ..color = body.withValues(alpha: .9 * rise)
        ..strokeWidth = 2;
      final wickH = fullH * (0.18 + rnd.nextDouble() * 0.22) * rise;
      canvas.drawLine(Offset(cx, top), Offset(cx, top - wickH), wickPaint);
      canvas.drawLine(
        Offset(cx, groundY),
        Offset(cx, groundY + 6 * rise),
        wickPaint,
      );
      // Blinking beacon at the wick tip.
      final blink =
          0.35 + 0.65 * ((math.sin((time * 6 + i) * math.pi * 2) + 1) / 2);
      canvas.drawCircle(
        Offset(cx, top - wickH),
        2.2,
        Paint()..color = Colors.white.withValues(alpha: blink * rise * .9),
      );

      // Windows — sparse lit grid inside the body.
      final winPaint = Paint()
        ..color = _window.withValues(alpha: .5 * rise);
      final cols = math.max(1, (bodyW / 11).floor());
      final rows = math.max(1, (bodyH / 15).floor());
      for (var c = 0; c < cols; c++) {
        for (var r = 0; r < rows; r++) {
          if (rnd.nextDouble() > 0.3) continue;
          canvas.drawRect(
            Rect.fromLTWH(
              cx - bodyW / 2 + 4 + c * 11.0,
              top + 5 + r * 15.0,
              3.2,
              4.4,
            ),
            winPaint,
          );
        }
      }
    }

    // ── Ground ──
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, w, h - groundY),
      Paint()..color = _ground,
    );
    // Soft neon reflection under the skyline.
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, w, (h - groundY) * .6),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _green.withValues(alpha: .08 * buildIn),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(0, groundY, w, (h - groundY) * .6)),
    );
  }

  @override
  bool shouldRepaint(CandlestickSkylinePainter old) =>
      old.buildIn != buildIn ||
      old.gridReveal != gridReveal ||
      old.time != time ||
      old.deltas != deltas ||
      old.isMobile != isMobile;
}
