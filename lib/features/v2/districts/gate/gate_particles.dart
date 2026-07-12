import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Warm dust motes drifting in the gate's light — pure canvas, seeded so
/// positions are stable. [time] loops 0..1 from a long ticker; [lift]
/// (scroll progress) draws the motes gently upward as the visitor enters.
class GateParticlesPainter extends CustomPainter {
  GateParticlesPainter({
    required this.time,
    required this.lift,
    required this.count,
    required this.color,
  });

  final double time;
  final double lift;
  final int count;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(5);
    for (var i = 0; i < count; i++) {
      final phase = rnd.nextDouble();
      final baseX = rnd.nextDouble() * size.width;
      final baseY = rnd.nextDouble() * size.height;
      final depth = 0.3 + rnd.nextDouble() * 0.7;

      // Slow vertical cycle + sinusoidal sway.
      final cycle = (baseY / size.height - time * depth - lift * .25) % 1.0;
      final y = cycle * size.height;
      final x = baseX +
          math.sin((time + phase) * math.pi * 2 * (0.5 + depth)) * 18 * depth;

      // Twinkle.
      final alpha = (0.10 + 0.22 * depth) *
          (0.55 + 0.45 * math.sin((time * 3 + phase) * math.pi * 2));
      final radius = 1.0 + 1.8 * depth;

      final glow = Paint()
        ..color = color.withValues(alpha: alpha * .4);
      canvas.drawCircle(Offset(x, y), radius * 2.4, glow);
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = color.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(GateParticlesPainter old) =>
      old.time != time ||
      old.lift != lift ||
      old.count != count ||
      old.color != color;
}
