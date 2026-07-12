import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Three parallax layers of terraced wheat fields with individually
/// swaying stalks along the front ridge — the living ground of Harvest
/// Valley, all procedural.
///
/// * [time] loops 0..1 (long ticker) → stalk sway.
/// * [progress] district scroll → layers shift at different rates.
/// * [night] 0..1 → palette dims toward the Exchange handoff.
class WheatFieldPainter extends CustomPainter {
  WheatFieldPainter({
    required this.time,
    required this.progress,
    required this.night,
    required this.sway,
    required this.isMobile,
  });

  final double time;
  final double progress;
  final double night;
  final bool sway;
  final bool isMobile;

  static const _backHill = Color(0xFF7C4A9E);
  static const _midHill = Color(0xFFC05A54);
  static const _frontField = Color(0xFFE8912E);
  static const _frontLight = Color(0xFFF5B93E);
  static const _rows = Color(0xFFC97F26);
  static const _stalk = Color(0xFFD9A03A);
  static const _grain = Color(0xFF8A5510);
  static const _nightTint = Color(0xFF10121F);

  Color _dim(Color c) => Color.lerp(c, _nightTint, night * .75)!;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Back hills (slowest parallax) ──
    _hill(
      canvas,
      w,
      h,
      baseY: h * .58,
      amp: h * .06,
      shift: progress * -22,
      color: _dim(_backHill),
    );

    // ── Mid hills ──
    _hill(
      canvas,
      w,
      h,
      baseY: h * .68,
      amp: h * .05,
      shift: progress * -48,
      color: _dim(_midHill),
    );

    // ── Front field ──
    final frontY = h * .78;
    final frontShift = progress * -84;
    final front = Path()
      ..moveTo(-60 + frontShift * .2, frontY + math.sin(frontShift * .01) * 4);
    for (var x = -60.0; x <= w + 80; x += 40) {
      front.quadraticBezierTo(
        x + 20 + frontShift * .2,
        frontY - 14 + math.sin((x + frontShift) * .012) * 10,
        x + 40 + frontShift * .2,
        frontY + math.sin((x + 40 + frontShift) * .012) * 8,
      );
    }
    front
      ..lineTo(w + 80, h + 10)
      ..lineTo(-60, h + 10)
      ..close();
    canvas.drawPath(front, Paint()..color = _dim(_frontField));

    // Sunlit top band of the front field.
    canvas.save();
    canvas.clipPath(front);
    canvas.drawRect(
      Rect.fromLTWH(0, frontY - 26, w, 30),
      Paint()..color = _dim(_frontLight).withValues(alpha: .55),
    );
    // Contour rows following the field.
    final rowPaint = Paint()
      ..color = _dim(_rows).withValues(alpha: .5)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    for (var i = 1; i <= 4; i++) {
      final y = frontY + (h - frontY) * (i / 5);
      final row = Path()..moveTo(-20, y);
      for (var x = -20.0; x <= w + 20; x += 60) {
        row.quadraticBezierTo(
          x + 30 + frontShift * .1,
          y - 8,
          x + 60 + frontShift * .1,
          y,
        );
      }
      canvas.drawPath(row, rowPaint);
    }
    canvas.restore();

    // ── Swaying stalks along the front ridge ──
    final count = isMobile ? 16 : 34;
    final rnd = math.Random(13);
    final stalkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final grainPaint = Paint()..color = _dim(_grain);

    for (var i = 0; i < count; i++) {
      final fx = rnd.nextDouble();
      final x = fx * (w + 60) - 30 + frontShift * .25;
      final ridgeY = frontY + math.sin((fx * (w + 60) + frontShift) * .012) * 8;
      final len = 26 + rnd.nextDouble() * 22;
      final phase = rnd.nextDouble() * math.pi * 2;
      final lean = sway
          ? math.sin(time * math.pi * 2 * 2 + phase) * (4 + len * .1)
          : 2.0;

      stalkPaint
        ..color = _dim(_stalk).withValues(alpha: .95)
        ..strokeWidth = 2.4;
      final tipX = x + lean;
      final tipY = ridgeY - len;
      final stem = Path()
        ..moveTo(x, ridgeY + 4)
        ..quadraticBezierTo(x + lean * .4, ridgeY - len * .55, tipX, tipY);
      canvas.drawPath(stem, stalkPaint);

      // Grain head.
      canvas.drawOval(
        Rect.fromCenter(center: Offset(tipX, tipY - 4), width: 7, height: 13),
        grainPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(tipX - 4, tipY + 1), width: 5.4, height: 10),
        grainPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(tipX + 4, tipY + 1), width: 5.4, height: 10),
        grainPaint,
      );
    }
  }

  void _hill(
    Canvas canvas,
    double w,
    double h, {
    required double baseY,
    required double amp,
    required double shift,
    required Color color,
  }) {
    final path = Path()..moveTo(-80, baseY);
    for (var x = -80.0; x <= w + 100; x += 90) {
      path.quadraticBezierTo(
        x + 45 + shift * .3,
        baseY - amp + math.sin((x + shift) * .008) * amp * .8,
        x + 90 + shift * .3,
        baseY + math.sin((x + 90 + shift) * .006) * amp * .4,
      );
    }
    path
      ..lineTo(w + 100, h + 10)
      ..lineTo(-80, h + 10)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(WheatFieldPainter old) =>
      old.time != time ||
      old.progress != progress ||
      old.night != night ||
      old.sway != sway ||
      old.isMobile != isMobile;
}
