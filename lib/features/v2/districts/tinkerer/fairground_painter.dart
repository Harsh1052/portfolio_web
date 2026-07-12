import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/progress_utils.dart';

/// Tinkerers' Park — a night carnival, fully procedural: a ferris wheel
/// cranked by the visitor's scroll with cabins that stay upright and glow,
/// twinkling string lights, striped tents with waving pennants — and the
/// v1 bug-game bug, walking through on its little cameo.
///
/// * [t] district progress — build-in, wheel rotation, the bug's walk.
/// * [time] loops 0..1 — twinkle, pennant wave, leg scurry.
class FairgroundPainter extends CustomPainter {
  FairgroundPainter({
    required this.t,
    required this.time,
    required this.sway,
    required this.isMobile,
  });

  final double t;
  final double time;
  final bool sway;
  final bool isMobile;

  static const _steel = Color(0xFF8A5A9E);
  static const _steelDark = Color(0xFF4A2B5E);
  static const _cabinColors = [
    Color(0xFFF5B93E),
    Color(0xFFF472B6),
    Color(0xFF7DD3FC),
    Color(0xFF6EE7B7),
  ];
  static const _bulbColors = [
    Color(0xFFFFD98A),
    Color(0xFFF472B6),
    Color(0xFF7DD3FC),
    Color(0xFF6EE7B7),
  ];
  static const _tentA = Color(0xFFB84A6E);
  static const _tentB = Color(0xFFEAE0C8);
  static const _ground = Color(0xFF160D26);
  static const _bug = Color(0xFF2A1B2E);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final gy = h * 0.86;
    final buildIn = t.band(0.06, 0.26, curve: Curves.easeOutCubic);
    final lightsIn = t.band(0.10, 0.20);
    final dim = t.band(0.88, 1.0);
    final alpha = buildIn * (1 - dim * .45);

    // ── String lights across the sky ──
    if (lightsIn > 0) {
      _lightString(canvas, w, h * .16, h * .07, 0, lightsIn * (1 - dim * .3));
      _lightString(canvas, w, h * .24, h * .05, 3, lightsIn * (1 - dim * .3));
    }

    // ── Tents (left side) ──
    if (buildIn > 0) {
      final tentW = w * (isMobile ? .30 : .17);
      _tent(canvas, Offset(w * .10, gy), tentW, tentW * .8, alpha);
      if (!isMobile) {
        _tent(canvas, Offset(w * .30, gy), tentW * .8, tentW * .62, alpha);
      }
    }

    // ── Ferris wheel, cranked by scroll ──
    final center = Offset(
      w * (isMobile ? .58 : .68),
      gy - h * (isMobile ? .30 : .34),
    );
    final radius = h * (isMobile ? .22 : .27);
    final rotation =
        t * math.pi * 2.2 + (sway ? time * math.pi * .3 : 0);
    _ferrisWheel(canvas, center, radius, rotation, gy, alpha);

    // ── Ground ──
    canvas.drawRect(
      Rect.fromLTWH(0, gy, w, h - gy),
      Paint()..color = _ground,
    );
    // Light pools from the fair.
    canvas.drawRect(
      Rect.fromLTWH(0, gy, w, h - gy),
      Paint()
        ..color = _cabinColors[1].withValues(alpha: .05 * alpha),
    );

    // ── The bug-game bug, walking through with the scroll ──
    final walk = t.band(0.25, 0.75);
    if (walk > 0 && walk < 1) {
      _bugCameo(canvas, Offset(w * walk, gy - 5), alpha);
    }
  }

  void _lightString(
    Canvas canvas,
    double w,
    double y,
    double sag,
    int seedShift,
    double alpha,
  ) {
    final wirePath = Path()
      ..moveTo(0, y)
      ..quadraticBezierTo(w / 2, y + sag * 2, w, y);
    canvas.drawPath(
      wirePath,
      Paint()
        ..color = Colors.white.withValues(alpha: .18 * alpha)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke,
    );
    final count = isMobile ? 9 : 15;
    for (var i = 0; i < count; i++) {
      final u = (i + 1) / (count + 1);
      final bx = w * u;
      final by = y + sag * 2 * 2 * u * (1 - u) + 4;
      final color = _bulbColors[(i + seedShift) % _bulbColors.length];
      final twinkle =
          .5 + .5 * math.sin((time * 2.5 + i * .7) * math.pi * 2);
      canvas.drawCircle(
        Offset(bx, by),
        5.5,
        Paint()..color = color.withValues(alpha: .25 * twinkle * alpha),
      );
      canvas.drawCircle(
        Offset(bx, by),
        2.4,
        Paint()..color = color.withValues(alpha: (.5 + .5 * twinkle) * alpha),
      );
    }
  }

  void _tent(
    Canvas canvas,
    Offset baseLeft,
    double tw,
    double th,
    double alpha,
  ) {
    final gy = baseLeft.dy;
    final left = baseLeft.dx;
    final peak = Offset(left + tw / 2, gy - th);

    // Striped canopy: fan of alternating wedges from the peak.
    const stripes = 6;
    for (var s = 0; s < stripes; s++) {
      final x0 = left + tw * (s / stripes);
      final x1 = left + tw * ((s + 1) / stripes);
      final wedge = Path()
        ..moveTo(peak.dx, peak.dy)
        ..lineTo(x0, gy - th * .32)
        ..lineTo(x1, gy - th * .32)
        ..close();
      canvas.drawPath(
        wedge,
        Paint()
          ..color =
              (s.isEven ? _tentA : _tentB).withValues(alpha: .95 * alpha),
      );
    }
    // Scalloped skirt + walls.
    canvas.drawRect(
      Rect.fromLTWH(left + tw * .08, gy - th * .32, tw * .84, th * .32),
      Paint()..color = _tentA.withValues(alpha: .8 * alpha),
    );
    // Entrance.
    canvas.drawPath(
      Path()
        ..moveTo(left + tw * .42, gy)
        ..lineTo(left + tw * .5, gy - th * .26)
        ..lineTo(left + tw * .58, gy)
        ..close(),
      Paint()..color = _steelDark.withValues(alpha: alpha),
    );
    // Pole + waving pennant.
    canvas.drawLine(
      peak,
      peak.translate(0, -16),
      Paint()
        ..color = _steelDark.withValues(alpha: alpha)
        ..strokeWidth = 2,
    );
    final wave = sway ? math.sin(time * math.pi * 2 * 2) * 4 : 0.0;
    canvas.drawPath(
      Path()
        ..moveTo(peak.dx, peak.dy - 16)
        ..quadraticBezierTo(
          peak.dx + 10, peak.dy - 14 + wave, peak.dx + 18, peak.dy - 12 + wave)
        ..lineTo(peak.dx, peak.dy - 8)
        ..close(),
      Paint()..color = _cabinColors[1].withValues(alpha: .95 * alpha),
    );
  }

  void _ferrisWheel(
    Canvas canvas,
    Offset c,
    double r,
    double rotation,
    double gy,
    double alpha,
  ) {
    final rim = Paint()
      ..color = _steel.withValues(alpha: alpha)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final spoke = Paint()
      ..color = _steel.withValues(alpha: .8 * alpha)
      ..strokeWidth = 2;

    // Support A-frame.
    final legs = Paint()
      ..color = _steelDark.withValues(alpha: alpha)
      ..strokeWidth = 5;
    canvas.drawLine(c, Offset(c.dx - r * .55, gy), legs);
    canvas.drawLine(c, Offset(c.dx + r * .55, gy), legs);

    // Rim (double ring).
    canvas.drawCircle(c, r, rim);
    canvas.drawCircle(c, r * .92, rim..strokeWidth = 1.4);

    // Spokes + upright cabins.
    const cabins = 8;
    for (var i = 0; i < cabins; i++) {
      final a = rotation + i * math.pi * 2 / cabins;
      final p = c + Offset(math.cos(a), math.sin(a)) * r;
      canvas.drawLine(c, p, spoke);

      final color = _cabinColors[i % _cabinColors.length];
      final cabin = Rect.fromCenter(
        center: p.translate(0, 9),
        width: 15,
        height: 12,
      );
      // Glow, then body — cabins hang and stay upright.
      canvas.drawCircle(
        p.translate(0, 9),
        11,
        Paint()..color = color.withValues(alpha: .22 * alpha),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(cabin, const Radius.circular(4)),
        Paint()..color = color.withValues(alpha: .95 * alpha),
      );
      canvas.drawLine(
        p,
        p.translate(0, 4),
        Paint()
          ..color = _steelDark.withValues(alpha: alpha)
          ..strokeWidth = 2,
      );
    }

    // Hub.
    canvas.drawCircle(
      c,
      7,
      Paint()..color = _steelDark.withValues(alpha: alpha),
    );
    canvas.drawCircle(
      c,
      3,
      Paint()..color = _cabinColors[0].withValues(alpha: alpha),
    );
  }

  /// The v1 bug-game bug, scurrying across the park.
  void _bugCameo(Canvas canvas, Offset pos, double alpha) {
    final bob = math.sin(time * math.pi * 2 * 6) * 1.2;
    final body = pos.translate(0, -6 + bob);
    final paint = Paint()..color = _bug.withValues(alpha: alpha);
    final legPaint = Paint()
      ..color = _bug.withValues(alpha: alpha)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    // Six scurrying legs.
    for (var i = 0; i < 3; i++) {
      final phase = math.sin((time * 8 + i) * math.pi * 2) * 3;
      final lx = body.dx - 6 + i * 6.0;
      canvas.drawLine(
          Offset(lx, body.dy + 2), Offset(lx - 3 + phase, body.dy + 8), legPaint);
      canvas.drawLine(
          Offset(lx, body.dy + 2), Offset(lx + 3 - phase, body.dy + 8), legPaint);
    }
    // Body + head + antennae.
    canvas.drawOval(
      Rect.fromCenter(center: body, width: 18, height: 11),
      paint,
    );
    canvas.drawCircle(body.translate(10, -1), 4.4, paint);
    canvas.drawLine(
        body.translate(12, -4), body.translate(16, -9), legPaint);
    canvas.drawLine(
        body.translate(14, -3), body.translate(19, -6), legPaint);
    // Shell shine.
    canvas.drawOval(
      Rect.fromCenter(center: body.translate(-3, -2), width: 6, height: 3),
      Paint()..color = _cabinColors[2].withValues(alpha: .5 * alpha),
    );
  }

  @override
  bool shouldRepaint(FairgroundPainter old) =>
      old.t != t ||
      old.time != time ||
      old.sway != sway ||
      old.isMobile != isMobile;
}
