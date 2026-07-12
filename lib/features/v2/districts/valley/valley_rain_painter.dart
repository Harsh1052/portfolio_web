import 'dart:math' as math;
import 'package:flutter/material.dart';

/// The monsoon — dark clouds slide in and slanted rain falls while the
/// farmer story plays, then clears as the lesson lands. [intensity] 0..1
/// drives everything; at 0 nothing paints.
class ValleyRainPainter extends CustomPainter {
  ValleyRainPainter({
    required this.time,
    required this.intensity,
    required this.isMobile,
  });

  final double time;
  final double intensity;
  final bool isMobile;

  static const _cloud = Color(0xFF3A2B4E);
  static const _cloudLit = Color(0xFF54406B);
  static const _rain = Color(0xFFBFD9F2);

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0.01) return;
    final w = size.width;
    final h = size.height;

    // ── Scene dimming ──
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFF10121F).withValues(alpha: .22 * intensity),
    );

    // ── Clouds slide down/in with intensity, drift slowly with time ──
    final drift = math.sin(time * math.pi * 2) * 14;
    final entry = (1 - intensity) * -80;
    _cloudCluster(
      canvas,
      Offset(w * .24 + drift, h * .10 + entry),
      w * .17,
      _cloud,
      intensity,
    );
    _cloudCluster(
      canvas,
      Offset(w * .62 - drift, h * .06 + entry),
      w * .21,
      _cloud,
      intensity,
    );
    _cloudCluster(
      canvas,
      Offset(w * .85 + drift * .6, h * .14 + entry),
      w * .13,
      _cloudLit,
      intensity * .9,
    );

    // ── Slanted rain, looping fall ──
    final count = (isMobile ? 34 : 68);
    final rnd = math.Random(23);
    final paint = Paint()
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < count; i++) {
      final fx = rnd.nextDouble();
      final phase = rnd.nextDouble();
      final depth = .4 + rnd.nextDouble() * .6;
      final speed = 1.4 + depth;
      final cycle = (phase + time * speed * 4) % 1.0;
      final x = fx * (w + 60) - 30 - cycle * 40 * depth;
      final y = cycle * (h + 60) - 30;
      final len = 12 + 10 * depth;

      paint.color = _rain.withValues(alpha: .30 * depth * intensity);
      canvas.drawLine(
        Offset(x, y),
        Offset(x - len * .28, y + len),
        paint,
      );
    }
  }

  void _cloudCluster(
    Canvas canvas,
    Offset c,
    double r,
    Color color,
    double alpha,
  ) {
    final paint = Paint()..color = color.withValues(alpha: alpha.clamp(0.0, 1.0));
    canvas.drawOval(
      Rect.fromCenter(center: c, width: r * 2.4, height: r * .9),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: c.translate(-r * .6, -r * .28), width: r * 1.3, height: r * .8),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: c.translate(r * .5, -r * .34), width: r * 1.1, height: r * .7),
      paint,
    );
  }

  @override
  bool shouldRepaint(ValleyRainPainter old) =>
      old.time != time ||
      old.intensity != intensity ||
      old.isMobile != isMobile;
}
