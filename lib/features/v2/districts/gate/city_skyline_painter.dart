import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Procedural city silhouette behind the gate — the whole City of Code,
/// glimpsed from outside the walls.
///
/// Two instances at different [depth]s create parallax; [reveal] (doors
/// opening) warms the silhouettes and lights the windows, as if the city
/// wakes when the visitor steps in. Buildings are seed-deterministic, so
/// the skyline is stable between frames and hot-reloads.
class CitySkylinePainter extends CustomPainter {
  CitySkylinePainter({
    required this.depth, // 0 = far, 1 = near
    required this.reveal, // 0..1 — doors-open amount
    required this.parallaxY, // px shift downward as the visitor approaches
    required this.groundY, // fraction of height where buildings sit
  });

  final double depth;
  final double reveal;
  final double parallaxY;
  final double groundY;

  static const _farColor = Color(0xFF241543);
  static const _nearColor = Color(0xFF33205C);
  static const _warm = Color(0xFF8E3A63);
  static const _window = Color(0xFFFFD98A);

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(depth < .5 ? 11 : 29);
    final base = Color.lerp(_farColor, _nearColor, depth)!;
    final tint = Color.lerp(base, _warm, reveal * (0.18 + depth * 0.12))!;
    final paint = Paint()..color = tint;

    final gy = size.height * groundY + parallaxY;
    final maxH = size.height * (0.14 + 0.16 * depth);
    final minH = size.height * (0.05 + 0.07 * depth);

    var x = -20.0;
    while (x < size.width + 20) {
      final bw = 26 + rnd.nextDouble() * (44 + 30 * depth);
      final bh = minH + rnd.nextDouble() * (maxH - minH);
      final top = gy - bh;
      final kind = rnd.nextInt(6);

      final rect = Rect.fromLTWH(x, top, bw, bh + 4);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: const Radius.circular(3),
          topRight: const Radius.circular(3),
        ),
        paint,
      );

      // Rooftop variety: antenna, dome, or water tank.
      if (kind == 0) {
        canvas.drawRect(
          Rect.fromLTWH(x + bw / 2 - 1.2, top - bh * .28, 2.4, bh * .28),
          paint,
        );
        canvas.drawCircle(Offset(x + bw / 2, top - bh * .28), 2.6, paint);
      } else if (kind == 1) {
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(x + bw / 2, top),
            width: bw * .7,
            height: bw * .7,
          ),
          math.pi,
          math.pi,
          true,
          paint,
        );
      } else if (kind == 2 && depth > .5) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x + bw * .2, top - 7, bw * .3, 7),
            const Radius.circular(2),
          ),
          paint,
        );
      }

      // Lit windows — near layer only, waking up with [reveal].
      if (depth > .5 && reveal > 0.05) {
        final winPaint = Paint()
          ..color = _window.withValues(alpha: 0.75 * reveal);
        final cols = (bw / 12).floor();
        final rows = (bh / 16).floor();
        for (var c = 0; c < cols; c++) {
          for (var r = 0; r < rows; r++) {
            if (rnd.nextDouble() > 0.24) continue; // sparse
            canvas.drawRect(
              Rect.fromLTWH(x + 5 + c * 12.0, top + 6 + r * 16.0, 3.4, 4.6),
              winPaint,
            );
          }
        }
      }

      x += bw + 3 + rnd.nextDouble() * 14;
    }

    // Ground band the buildings sit on.
    canvas.drawRect(
      Rect.fromLTWH(0, gy, size.width, size.height - gy),
      Paint()..color = Color.lerp(const Color(0xFF160D2B), _warm, reveal * .08)!,
    );
  }

  @override
  bool shouldRepaint(CitySkylinePainter old) =>
      old.reveal != reveal ||
      old.parallaxY != parallaxY ||
      old.depth != depth ||
      old.groundY != groundY;
}
