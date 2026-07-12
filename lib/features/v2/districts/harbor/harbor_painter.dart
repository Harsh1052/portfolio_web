import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/progress_utils.dart';

/// The Harbor — dusk over the water at the edge of the city:
/// shimmering sea, a lighthouse with a slowly sweeping beam, a wooden
/// dock, bobbing paper boats — and one paper boat that sails for the
/// horizon as the visitor scrolls, carrying their visit with it.
class HarborPainter extends CustomPainter {
  HarborPainter({
    required this.t,
    required this.time,
    required this.sway,
    required this.isMobile,
  });

  final double t;
  final double time;
  final bool sway;
  final bool isMobile;

  static const _water = Color(0xFF16223E);
  static const _waterLight = Color(0xFF23405F);
  static const _shimmer = Color(0xFF9FC4E8);
  static const _moon = Color(0xFFF6EED8);
  static const _wood = Color(0xFF3D2A1E);
  static const _woodLight = Color(0xFF6B4226);
  static const _lightTower = Color(0xFFEAE0C8);
  static const _lightBand = Color(0xFFB84A46);
  static const _beam = Color(0xFFFFE9A8);
  static const _paper = Color(0xFFF6F1E4);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final horizonY = h * 0.60;
    final buildIn = t.band(0.06, 0.24, curve: Curves.easeOutCubic);
    final alpha = buildIn;

    // ── Moon + gulls ──
    final moonC = Offset(w * .18, h * .16);
    canvas.drawCircle(
      moonC,
      26,
      Paint()..color = _moon.withValues(alpha: .18 * alpha),
    );
    canvas.drawCircle(
      moonC,
      14,
      Paint()..color = _moon.withValues(alpha: .9 * alpha),
    );
    canvas.drawCircle(
      moonC.translate(5, -3),
      11,
      Paint()..color = const Color(0xFF3A2F5E).withValues(alpha: .55 * alpha),
    );
    final gull = Paint()
      ..color = const Color(0xFF241A3E).withValues(alpha: alpha)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final flap = sway ? math.sin(time * math.pi * 2 * 3) * 2 : 0.0;
    canvas.drawPath(
      Path()
        ..moveTo(w * .42, h * .20)
        ..quadraticBezierTo(w * .42 + 6, h * .20 - 6 - flap, w * .42 + 12, h * .20)
        ..quadraticBezierTo(w * .42 + 18, h * .20 - 6 - flap, w * .42 + 24, h * .20),
      gull,
    );

    // ── Water ──
    canvas.drawRect(
      Rect.fromLTWH(0, horizonY, w, h - horizonY),
      Paint()..color = _water,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, horizonY, w, 3),
      Paint()..color = _waterLight.withValues(alpha: alpha),
    );
    // Animated shimmer dashes drifting.
    final shimmerPaint = Paint()..strokeCap = StrokeCap.round;
    final rnd = math.Random(19);
    final rows = isMobile ? 7 : 11;
    for (var i = 0; i < rows; i++) {
      final y = horizonY + 14 + i * ((h - horizonY - 20) / rows);
      final drift = ((time * (0.15 + i * .03) + rnd.nextDouble()) % 1.0);
      final x = drift * (w + 120) - 60;
      final len = 18.0 + rnd.nextDouble() * 30 + i * 3;
      shimmerPaint
        ..color = _shimmer.withValues(
            alpha: (.05 + .06 * math.sin((time * 2 + i) * math.pi * 2))
                    .clamp(0.0, 1.0) *
                alpha)
        ..strokeWidth = 2.0 + i * .2;
      canvas.drawLine(Offset(x, y), Offset(x + len, y), shimmerPaint);
    }
    // Moon reflection streak.
    for (var i = 0; i < 5; i++) {
      final y = horizonY + 10 + i * 14.0;
      final wob = sway ? math.sin((time * 2 + i) * math.pi * 2) * 5 : 0.0;
      canvas.drawLine(
        Offset(moonC.dx - 10 + wob, y),
        Offset(moonC.dx + 10 + wob, y),
        Paint()
          ..color = _moon.withValues(alpha: (.16 - i * .025) * alpha)
          ..strokeWidth = 3,
      );
    }

    // ── Lighthouse (right, on a rock) ──
    _lighthouse(canvas, Offset(w * .84, horizonY), h, alpha);

    // ── Dock (left) ──
    _dock(canvas, Offset(0, horizonY + 26), w * (isMobile ? .42 : .30), alpha);

    // ── Paper boats ──
    // Two idle boats bobbing near the dock.
    _paperBoat(
      canvas,
      Offset(w * .20, horizonY + 52 + _bob(0)),
      13,
      alpha,
    );
    _paperBoat(
      canvas,
      Offset(w * .30, horizonY + 74 + _bob(1.4)),
      16,
      alpha,
    );
    // The hero boat sails for the horizon with the scroll.
    final sail = t.band(0.30, 0.62, curve: Curves.easeInOut);
    if (sail > 0) {
      final bx = w * (.24 + .55 * sail);
      final by = horizonY + 60 - 44 * sail + _bob(2.2) * (1 - sail * .6);
      final scale = 18.0 * (1 - sail * .55);
      _paperBoat(canvas, Offset(bx, by), scale, alpha);
      // Wake.
      canvas.drawLine(
        Offset(bx - scale, by + 3),
        Offset(bx - scale - 26 * (1 - sail), by + 4),
        Paint()
          ..color = _shimmer.withValues(alpha: .2 * alpha * (1 - sail))
          ..strokeWidth = 2,
      );
    }
  }

  double _bob(double phase) =>
      sway ? math.sin((time * 2 + phase) * math.pi * 2) * 3 : 0.0;

  void _lighthouse(Canvas canvas, Offset base, double h, double alpha) {
    // Rock.
    canvas.drawOval(
      Rect.fromCenter(center: base.translate(0, 10), width: 90, height: 34),
      Paint()..color = const Color(0xFF241A3E).withValues(alpha: alpha),
    );
    // Tapered tower with bands.
    final towerH = h * .26;
    final top = base.dy - towerH;
    final tower = Path()
      ..moveTo(base.dx - 17, base.dy)
      ..lineTo(base.dx - 10, top)
      ..lineTo(base.dx + 10, top)
      ..lineTo(base.dx + 17, base.dy)
      ..close();
    canvas.drawPath(tower, Paint()..color = _lightTower.withValues(alpha: alpha));
    // Red bands.
    for (var i = 0; i < 2; i++) {
      final y0 = base.dy - towerH * (.30 + i * .34);
      final inset = 10 + 7 * ((base.dy - y0) / towerH);
      canvas.drawRect(
        Rect.fromLTRB(base.dx - inset, y0 - towerH * .12, base.dx + inset, y0),
        Paint()..color = _lightBand.withValues(alpha: alpha),
      );
    }
    // Lantern room + dome.
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(base.dx, top - 8), width: 22, height: 16),
      Paint()..color = const Color(0xFF241A3E).withValues(alpha: alpha),
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(base.dx, top - 16), width: 20, height: 16),
      math.pi,
      math.pi,
      true,
      Paint()..color = _lightBand.withValues(alpha: alpha),
    );

    // Sweeping beam.
    final beamAngle = sway
        ? math.sin(time * math.pi * 2) * .9
        : -0.4; // gentle sweep back and forth
    final lantern = Offset(base.dx, top - 8);
    final beamLen = h * .7;
    final beamHalf = .10;
    final beam = Path()
      ..moveTo(lantern.dx, lantern.dy)
      ..lineTo(
        lantern.dx + beamLen * math.cos(math.pi + beamAngle - beamHalf),
        lantern.dy + beamLen * math.sin(math.pi + beamAngle - beamHalf),
      )
      ..lineTo(
        lantern.dx + beamLen * math.cos(math.pi + beamAngle + beamHalf),
        lantern.dy + beamLen * math.sin(math.pi + beamAngle + beamHalf),
      )
      ..close();
    canvas.drawPath(
      beam,
      Paint()..color = _beam.withValues(alpha: .12 * alpha),
    );
    canvas.drawCircle(
      lantern,
      5,
      Paint()
        ..color = _beam.withValues(
            alpha: (.6 + .4 * math.sin(time * math.pi * 4)) * alpha),
    );
  }

  void _dock(Canvas canvas, Offset start, double dockW, double alpha) {
    final deckY = start.dy;
    // Posts into the water.
    final post = Paint()..color = _wood.withValues(alpha: alpha);
    for (var i = 0; i < 4; i++) {
      final x = start.dx + dockW * (.15 + i * .26);
      canvas.drawRect(Rect.fromLTWH(x - 3, deckY, 6, 42), post);
    }
    // Deck planks.
    canvas.drawRect(
      Rect.fromLTWH(start.dx, deckY - 8, dockW, 10),
      Paint()..color = _woodLight.withValues(alpha: alpha),
    );
    final gap = Paint()
      ..color = _wood.withValues(alpha: alpha)
      ..strokeWidth = 1.2;
    for (var x = start.dx + 12; x < start.dx + dockW; x += 14) {
      canvas.drawLine(Offset(x, deckY - 8), Offset(x, deckY + 2), gap);
    }
    // Bollard + rope coil.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(start.dx + dockW * .72, deckY - 20, 8, 13),
        const Radius.circular(3),
      ),
      post,
    );
    canvas.drawCircle(
      Offset(start.dx + dockW * .5, deckY - 12),
      6,
      Paint()
        ..color = _woodLight.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  void _paperBoat(Canvas canvas, Offset c, double s, double alpha) {
    // Hull: folded-paper trapezoid.
    final hull = Path()
      ..moveTo(c.dx - s, c.dy)
      ..lineTo(c.dx + s, c.dy)
      ..lineTo(c.dx + s * .55, c.dy + s * .5)
      ..lineTo(c.dx - s * .55, c.dy + s * .5)
      ..close();
    canvas.drawPath(hull, Paint()..color = _paper.withValues(alpha: alpha));
    // Sail fold.
    final sailPath = Path()
      ..moveTo(c.dx, c.dy)
      ..lineTo(c.dx, c.dy - s * .9)
      ..lineTo(c.dx + s * .6, c.dy)
      ..close();
    canvas.drawPath(sailPath, Paint()..color = _paper.withValues(alpha: alpha));
    canvas.drawPath(
      Path()
        ..moveTo(c.dx, c.dy)
        ..lineTo(c.dx, c.dy - s * .9)
        ..lineTo(c.dx - s * .5, c.dy)
        ..close(),
      Paint()..color = const Color(0xFFD8CFBA).withValues(alpha: alpha),
    );
    // Reflection.
    canvas.drawOval(
      Rect.fromCenter(
          center: c.translate(0, s * .8), width: s * 1.6, height: s * .3),
      Paint()..color = _paper.withValues(alpha: .12 * alpha),
    );
  }

  @override
  bool shouldRepaint(HarborPainter old) =>
      old.t != t ||
      old.time != time ||
      old.sway != sway ||
      old.isMobile != isMobile;
}
