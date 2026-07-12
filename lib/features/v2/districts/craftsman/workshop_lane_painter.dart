import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/progress_utils.dart';

/// Craftsman's Lane — a warm artisan street, fully procedural:
/// shopfront facades with striped awnings, hanging signs that flicker on
/// one by one, a gear train cranked by the visitor's scroll, lanterns
/// swaying on a wire, chimney smoke, and cobblestones.
///
/// * [t] district progress — drives build-in, sign bands, gear rotation.
/// * [time] loops 0..1 — lantern sway, flicker jitter, smoke drift.
class WorkshopLanePainter extends CustomPainter {
  WorkshopLanePainter({
    required this.t,
    required this.time,
    required this.sway,
    required this.isMobile,
  });

  final double t;
  final double time;
  final bool sway;
  final bool isMobile;

  static const _walls = [
    Color(0xFFA64B33),
    Color(0xFF5C6E4A),
    Color(0xFF8A3B5E),
    Color(0xFF7D5A3C),
  ];
  static const _trim = Color(0xFFEAE0C8);
  static const _board = Color(0xFF3D2A1E);
  static const _amber = Color(0xFFFFB84D);
  static const _glow = Color(0xFFFFD98A);
  static const _street = Color(0xFF2A1B2E);
  static const _stone = Color(0xFF3D2A44);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final streetY = h * 0.86;
    final buildIn = t.band(0.06, 0.26, curve: Curves.easeOutCubic);
    final dim = t.band(0.88, 1.0);

    final shops = isMobile ? 3 : 4;
    final gap = w * 0.02;
    final shopW = (w - gap * (shops + 1)) / shops;
    final shopH = h * 0.36;

    // ── Facades (rise slightly as they fade in) ──
    for (var i = 0; i < shops; i++) {
      final inT = ((buildIn - i * 0.12) / (1 - i * 0.12)).clamp(0.0, 1.0);
      if (inT <= 0) continue;
      final x = gap + i * (shopW + gap);
      final top = streetY - shopH * inT;
      _facade(canvas, Rect.fromLTWH(x, top, shopW, shopH * inT), i, inT, dim);
    }

    // ── Gear train above shop 2, cranked by scroll ──
    if (buildIn > 0.5 && shops >= 2) {
      final gx = gap + 1 * (shopW + gap) + shopW * .5;
      final gy = streetY - shopH - 26;
      final spin = t * math.pi * 6;
      final gearAlpha = ((buildIn - .5) * 2).clamp(0.0, 1.0) * (1 - dim * .6);
      _gear(canvas, Offset(gx - 30, gy), 20, spin, 8, gearAlpha);
      _gear(canvas, Offset(gx + 4, gy - 14), 15, -spin * 20 / 15, 7, gearAlpha);
      _gear(canvas, Offset(gx + 34, gy + 2), 18, spin * 20 / 18, 8, gearAlpha);
    }

    // ── Lantern wire across the lane ──
    final lanternIn = t.band(0.12, 0.22);
    if (lanternIn > 0) {
      final wireY = h * 0.30;
      final wire = Path()
        ..moveTo(0, wireY)
        ..quadraticBezierTo(w / 2, wireY + 34, w, wireY);
      canvas.drawPath(
        wire,
        Paint()
          ..color = _trim.withValues(alpha: .4 * lanternIn)
          ..strokeWidth = 1.4
          ..style = PaintingStyle.stroke,
      );
      final count = isMobile ? 4 : 6;
      for (var i = 0; i < count; i++) {
        final u = (i + 1) / (count + 1);
        final lx = w * u;
        final ly = wireY + 34 * 4 * u * (1 - u) * .5 + 6;
        final swing = sway ? math.sin(time * math.pi * 2 + i * 1.3) * 5 : 0.0;
        _lantern(canvas, Offset(lx + swing, ly), i, lanternIn * (1 - dim * .3));
      }
    }

    // ── Street: cobblestones ──
    canvas.drawRect(
      Rect.fromLTWH(0, streetY, w, h - streetY),
      Paint()..color = _street,
    );
    final stonePaint = Paint()..color = _stone;
    final rows = 3;
    for (var r = 0; r < rows; r++) {
      final y = streetY + 8 + r * 16.0;
      final offset = r.isOdd ? 14.0 : 0.0;
      for (var x = -10.0 + offset; x < w; x += 28) {
        canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y), width: 24, height: 10),
          stonePaint,
        );
      }
    }

    // Warm pools of lantern light on the street.
    if (lanternIn > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, streetY, w, h - streetY),
        Paint()
          ..color = _glow.withValues(alpha: .05 * lanternIn * (1 - dim)),
      );
    }
  }

  void _facade(Canvas canvas, Rect r, int i, double inT, double dim) {
    final wall = Color.lerp(
      _walls[i % _walls.length],
      const Color(0xFF1A1024),
      dim * .5,
    )!;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        r,
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      ),
      Paint()..color = wall.withValues(alpha: inT),
    );
    // Roofline trim.
    canvas.drawRect(
      Rect.fromLTWH(r.left - 3, r.top, r.width + 6, 6),
      Paint()..color = _trim.withValues(alpha: .9 * inT),
    );
    // Chimney + smoke on the first shop.
    if (i == 0) {
      canvas.drawRect(
        Rect.fromLTWH(r.left + r.width * .68, r.top - 20, 12, 20),
        Paint()..color = _board.withValues(alpha: inT),
      );
      for (var p = 0; p < 3; p++) {
        final drift = ((time * (0.6 + p * .2)) % 1.0);
        canvas.drawCircle(
          Offset(
            r.left + r.width * .68 + 6 + math.sin((drift + p) * math.pi * 2) * 6,
            r.top - 24 - drift * 36,
          ),
          4 + p * 1.5,
          Paint()
            ..color =
                _trim.withValues(alpha: (1 - drift) * .25 * inT),
        );
      }
    }

    // Awning: striped canopy over the window.
    final awningY = r.top + r.height * .34;
    final stripeW = r.width / 6;
    for (var s = 0; s < 6; s++) {
      canvas.drawRect(
        Rect.fromLTWH(r.left + s * stripeW, awningY, stripeW, 14),
        Paint()
          ..color = (s.isEven ? _trim : _walls[(i + 2) % _walls.length])
              .withValues(alpha: .95 * inT),
      );
    }

    // Window — lights up with its sign.
    final signT = _signBand(i);
    final winRect = Rect.fromLTWH(
      r.left + r.width * .14,
      awningY + 20,
      r.width * .44,
      r.height * .30,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(winRect, const Radius.circular(3)),
      Paint()
        ..color = Color.lerp(
          const Color(0xFF241530),
          _glow,
          signT * .85,
        )!
            .withValues(alpha: inT),
    );
    // Mullions.
    final mullion = Paint()
      ..color = _board.withValues(alpha: inT)
      ..strokeWidth = 2;
    canvas.drawLine(winRect.topCenter, winRect.bottomCenter, mullion);
    canvas.drawLine(winRect.centerLeft, winRect.centerRight, mullion);

    // Door.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          r.left + r.width * .66,
          r.bottom - r.height * .42,
          r.width * .2,
          r.height * .42,
        ),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      ),
      Paint()..color = _board.withValues(alpha: inT),
    );

    // Hanging sign with glyph — flickers on.
    final bracketX = r.left + r.width * .5;
    final signTop = r.top + 12;
    final flicker = signT > 0 && signT < 1
        ? (0.45 + 0.55 * math.sin(time * math.pi * 2 * 9 + i * 2))
            .clamp(0.0, 1.0)
        : 1.0;
    final signAlpha = (signT * flicker * inT).clamp(0.0, 1.0);
    canvas.drawLine(
      Offset(bracketX, signTop),
      Offset(bracketX, signTop + 10),
      Paint()
        ..color = _trim.withValues(alpha: .7 * inT)
        ..strokeWidth = 2,
    );
    final board = Rect.fromCenter(
      center: Offset(bracketX, signTop + 26),
      width: 34,
      height: 28,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(board, const Radius.circular(4)),
      Paint()..color = _board.withValues(alpha: inT),
    );
    if (signAlpha > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(board.inflate(3), const Radius.circular(6)),
        Paint()..color = _amber.withValues(alpha: .25 * signAlpha),
      );
      _glyph(canvas, board.center, i, _amber.withValues(alpha: signAlpha));
    }
  }

  /// Per-shop sign band: they turn on one by one through 0.20–0.50.
  double _signBand(int i) => t.band(0.20 + i * 0.07, 0.28 + i * 0.07);

  /// Little craft glyphs: phone, gear, database, bolt.
  void _glyph(Canvas canvas, Offset c, int kind, Color color) {
    final stroke = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final fill = Paint()..color = color;
    switch (kind % 4) {
      case 0: // phone
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: c, width: 12, height: 18),
            const Radius.circular(3),
          ),
          stroke,
        );
        canvas.drawCircle(c.translate(0, 6), 1.4, fill);
      case 1: // gear
        _gear(canvas, c, 8, time * math.pi * 2, 7, 1, color: color);
      case 2: // database
        canvas.drawOval(
          Rect.fromCenter(center: c.translate(0, -5), width: 14, height: 6),
          stroke,
        );
        canvas.drawLine(c.translate(-7, -5), c.translate(-7, 5), stroke);
        canvas.drawLine(c.translate(7, -5), c.translate(7, 5), stroke);
        canvas.drawArc(
          Rect.fromCenter(center: c.translate(0, 5), width: 14, height: 6),
          0,
          math.pi,
          false,
          stroke,
        );
      case 3: // bolt
        final bolt = Path()
          ..moveTo(c.dx + 2, c.dy - 9)
          ..lineTo(c.dx - 5, c.dy + 2)
          ..lineTo(c.dx - 1, c.dy + 2)
          ..lineTo(c.dx - 2, c.dy + 9)
          ..lineTo(c.dx + 5, c.dy - 2)
          ..lineTo(c.dx + 1, c.dy - 2)
          ..close();
        canvas.drawPath(bolt, fill);
    }
  }

  void _gear(
    Canvas canvas,
    Offset c,
    double radius,
    double angle,
    int teeth,
    double alpha, {
    Color? color,
  }) {
    final body = (color ?? _amber).withValues(alpha: alpha.clamp(0.0, 1.0));
    final paint = Paint()..color = body;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle);
    canvas.drawCircle(Offset.zero, radius * .82, paint);
    for (var i = 0; i < teeth; i++) {
      canvas.save();
      canvas.rotate(i * math.pi * 2 / teeth);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(radius * .92, 0),
          width: radius * .38,
          height: radius * .3,
        ),
        paint,
      );
      canvas.restore();
    }
    canvas.drawCircle(
      Offset.zero,
      radius * .3,
      Paint()..color = _board.withValues(alpha: alpha),
    );
    canvas.restore();
  }

  void _lantern(Canvas canvas, Offset c, int i, double alpha) {
    if (alpha <= 0) return;
    final pulse =
        .6 + .4 * math.sin(time * math.pi * 2 * 1.5 + i * 2.1);
    // Glow.
    canvas.drawCircle(
      c.translate(0, 10),
      13,
      Paint()..color = _glow.withValues(alpha: .22 * alpha * pulse),
    );
    // Cord.
    canvas.drawLine(
      c.translate(0, -6),
      c.translate(0, 2),
      Paint()
        ..color = _board.withValues(alpha: alpha)
        ..strokeWidth = 1.4,
    );
    // Body.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: c.translate(0, 10), width: 11, height: 15),
        const Radius.circular(4),
      ),
      Paint()..color = _amber.withValues(alpha: .95 * alpha),
    );
    canvas.drawRect(
      Rect.fromCenter(center: c.translate(0, 2), width: 13, height: 3),
      Paint()..color = _board.withValues(alpha: alpha),
    );
    canvas.drawRect(
      Rect.fromCenter(center: c.translate(0, 18), width: 13, height: 3),
      Paint()..color = _board.withValues(alpha: alpha),
    );
  }

  @override
  bool shouldRepaint(WorkshopLanePainter old) =>
      old.t != t ||
      old.time != time ||
      old.sway != sway ||
      old.isMobile != isMobile;
}
