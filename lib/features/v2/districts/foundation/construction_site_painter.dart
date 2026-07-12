import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Foundation Square's construction site: dashed blueprint outlines become
/// steel frames floor by floor, a tower crane lowers a glowing beam onto
/// the tallest frame, and the first finished tower lights its windows.
///
/// * [outline] 0..1 — blueprint outlines dash-draw themselves.
/// * [build] 0..1 — solid frames rise bottom-up, replacing the plans.
/// * [complete] 0..1 — the first tower gets walls + lit windows.
/// * [craneDrop] 0..1 — hook lowers the beam onto the tall frame.
/// * [time] loops 0..1 — trolley drifts, hook bobs, beacon blinks.
class ConstructionSitePainter extends CustomPainter {
  ConstructionSitePainter({
    required this.outline,
    required this.build,
    required this.complete,
    required this.craneDrop,
    required this.time,
    required this.isMobile,
  });

  final double outline;
  final double build;
  final double complete;
  final double craneDrop;
  final double time;
  final bool isMobile;

  static const _blueprint = Color(0xFFBFDCFF);
  static const _steel = Color(0xFFE8912E);
  static const _steelDark = Color(0xFF8A5510);
  static const _crane = Color(0xFFF5B93E);
  static const _wall = Color(0xFFEAE0C8);
  static const _window = Color(0xFFFFD98A);
  static const _ground = Color(0xFF122641);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final gy = h * 0.86;

    // Building slots: left (finished tower), center (tall frame), right
    // (scaffolded mid-rise). Mobile drops the right building.
    final slots = <Rect>[
      Rect.fromLTWH(w * .10, gy - h * .30, w * .16, h * .30),
      Rect.fromLTWH(w * .42, gy - h * .46, w * .17, h * .46),
      if (!isMobile) Rect.fromLTWH(w * .74, gy - h * .24, w * .15, h * .24),
    ];

    for (var b = 0; b < slots.length; b++) {
      final r = slots[b];
      final stagger = b * 0.18;
      final o = ((outline - stagger) / (1 - stagger)).clamp(0.0, 1.0);
      final s = ((build - stagger) / (1 - stagger)).clamp(0.0, 1.0);

      if (o > 0 && s < 1) _blueprintOutline(canvas, r, o);
      if (s > 0) _steelFrame(canvas, r, s);
      if (b == 0 && complete > 0) _finishTower(canvas, r, complete);
      if (b == 2 && s > 0.3) _scaffold(canvas, r, ((s - .3) / .7));
    }

    // Crane beside the tall frame.
    _crane_(canvas, size, slots[1]);

    // Ground: dirt band + a few planks.
    canvas.drawRect(
      Rect.fromLTWH(0, gy, w, h - gy),
      Paint()..color = _ground,
    );
    final plank = Paint()..color = _steelDark.withValues(alpha: .8);
    canvas.drawRect(Rect.fromLTWH(w * .30, gy + 8, w * .10, 4), plank);
    canvas.drawRect(Rect.fromLTWH(w * .63, gy + 16, w * .08, 4), plank);
  }

  /// Dashed blueprint rectangle + floor lines, drawn like plans.
  void _blueprintOutline(Canvas canvas, Rect r, double o) {
    final paint = Paint()
      ..color = _blueprint.withValues(alpha: .55 * o)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    // Perimeter dash-draws with o.
    final perimeter = [
      (r.bottomLeft, r.topLeft),
      (r.topLeft, r.topRight),
      (r.topRight, r.bottomRight),
    ];
    var budget = o * 3; // three edges
    for (final (a, b) in perimeter) {
      final seg = budget.clamp(0.0, 1.0);
      if (seg <= 0) break;
      _dashedLine(canvas, a, Offset.lerp(a, b, seg)!, paint);
      budget -= 1;
    }
    // Floor ticks once perimeter is mostly there.
    if (o > .7) {
      final floors = (r.height / 42).floor();
      for (var f = 1; f < floors; f++) {
        final y = r.bottom - f * 42.0;
        _dashedLine(canvas, Offset(r.left, y), Offset(r.right, y),
            paint..color = _blueprint.withValues(alpha: .3 * o));
      }
    }
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 6.0, gap = 5.0;
    final total = (b - a).distance;
    if (total < 1) return;
    final dir = (b - a) / total;
    var covered = 0.0;
    while (covered < total) {
      final len = math.min(dash, total - covered);
      canvas.drawLine(a + dir * covered, a + dir * (covered + len), paint);
      covered += dash + gap;
    }
  }

  /// Steel skeleton rising floor by floor.
  void _steelFrame(Canvas canvas, Rect r, double s) {
    final floors = math.max(3, (r.height / 42).floor());
    final risen = (floors * s).clamp(0.0, floors.toDouble());
    final beam = Paint()
      ..color = _steel
      ..strokeWidth = 3;
    final post = Paint()
      ..color = _steelDark
      ..strokeWidth = 4;

    const cols = 3;
    final colStep = r.width / (cols - 1);
    final floorH = r.height / floors;

    for (var f = 0; f < risen.ceil(); f++) {
      final fT = (risen - f).clamp(0.0, 1.0);
      final y1 = r.bottom - f * floorH;
      final y0 = y1 - floorH * fT;
      // Columns for this floor.
      for (var c = 0; c < cols; c++) {
        final x = r.left + c * colStep;
        canvas.drawLine(Offset(x, y1), Offset(x, y0), post);
      }
      // Completed floors get their beam + a diagonal brace.
      if (fT >= 1) {
        canvas.drawLine(Offset(r.left, y0), Offset(r.right, y0), beam);
        canvas.drawLine(
          Offset(r.left, y1),
          Offset(r.left + colStep, y0),
          Paint()
            ..color = _steel.withValues(alpha: .55)
            ..strokeWidth = 2,
        );
      }
    }
    // Base slab.
    canvas.drawRect(
      Rect.fromLTWH(r.left - 4, r.bottom, r.width + 8, 5),
      Paint()..color = _steelDark,
    );
  }

  /// The first tower: walls slide up over the frame, then windows light.
  void _finishTower(Canvas canvas, Rect r, double c) {
    final wallH = r.height * c.clamp(0.0, 1.0);
    canvas.drawRect(
      Rect.fromLTWH(r.left, r.bottom - wallH, r.width, wallH),
      Paint()..color = _wall.withValues(alpha: .95),
    );
    canvas.drawRect(
      Rect.fromLTWH(r.left, r.bottom - wallH, r.width * .2, wallH),
      Paint()..color = const Color(0xFFCFC09A),
    );
    if (c > .55) {
      final winAlpha = ((c - .55) / .45).clamp(0.0, 1.0);
      final winPaint = Paint()
        ..color = _window.withValues(alpha: .9 * winAlpha);
      final rnd = math.Random(31);
      final cols = (r.width / 16).floor();
      final rows = (r.height / 22).floor();
      for (var col = 0; col < cols; col++) {
        for (var row = 0; row < rows; row++) {
          if (rnd.nextDouble() > .5) continue;
          canvas.drawRect(
            Rect.fromLTWH(
              r.left + 6 + col * 16.0,
              r.bottom - r.height + 8 + row * 22.0,
              5.5,
              7.5,
            ),
            winPaint,
          );
        }
      }
    }
  }

  void _scaffold(Canvas canvas, Rect r, double s) {
    final paint = Paint()
      ..color = _crane.withValues(alpha: .6 * s)
      ..strokeWidth = 1.6;
    final right = r.right + 14;
    final top = r.bottom - r.height * s;
    canvas.drawLine(Offset(r.right + 4, r.bottom), Offset(r.right + 4, top), paint);
    canvas.drawLine(Offset(right, r.bottom), Offset(right, top), paint);
    final levels = math.max(1, ((r.bottom - top) / 30).floor());
    for (var i = 0; i <= levels; i++) {
      final y = r.bottom - i * 30.0;
      canvas.drawLine(Offset(r.right + 4, y), Offset(right, y), paint);
      if (i < levels) {
        canvas.drawLine(Offset(r.right + 4, y), Offset(right, y - 30), paint);
      }
    }
  }

  /// Tower crane with drifting trolley and a beam descending on the hook.
  void _crane_(Canvas canvas, Size size, Rect target) {
    final gy = size.height * 0.86;
    final mastX = target.right + size.width * .09;
    final mastTop = target.top - size.height * .10;
    final mast = Paint()
      ..color = _crane
      ..strokeWidth = 4;
    final lattice = Paint()
      ..color = _crane.withValues(alpha: .7)
      ..strokeWidth = 1.4;

    // Mast with cross-lattice.
    canvas.drawLine(Offset(mastX - 5, gy), Offset(mastX - 5, mastTop), mast);
    canvas.drawLine(Offset(mastX + 5, gy), Offset(mastX + 5, mastTop), mast);
    for (var y = gy; y > mastTop; y -= 18) {
      canvas.drawLine(Offset(mastX - 5, y), Offset(mastX + 5, y - 18), lattice);
      canvas.drawLine(Offset(mastX + 5, y), Offset(mastX - 5, y - 18), lattice);
    }

    // Jib (toward the frame) + counter-jib with weight.
    final jibLen = mastX - target.center.dx + 20;
    final jibY = mastTop;
    canvas.drawLine(
        Offset(mastX - jibLen, jibY), Offset(mastX + 46, jibY), mast);
    canvas.drawRect(
      Rect.fromLTWH(mastX + 30, jibY, 16, 14),
      Paint()..color = _steelDark,
    );
    // Apex + tie cables.
    final apex = Offset(mastX, jibY - 22);
    canvas.drawLine(Offset(mastX, jibY), apex, mast);
    canvas.drawLine(apex, Offset(mastX - jibLen * .9, jibY), lattice);
    canvas.drawLine(apex, Offset(mastX + 40, jibY), lattice);
    // Blinking beacon.
    final blink = (math.sin(time * math.pi * 2 * 5) + 1) / 2;
    canvas.drawCircle(
      apex.translate(0, -3),
      2.4,
      Paint()..color = const Color(0xFFEF4444).withValues(alpha: .3 + .7 * blink),
    );

    // Trolley drifts along the jib; hook drops the beam onto the frame.
    final trolleyX = mastX -
        jibLen * (.72 + .1 * math.sin(time * math.pi * 2)) ;
    final cableTop = Offset(trolleyX, jibY + 3);
    final dropSpan = (target.top - 18) - (jibY + 26);
    final hookY = jibY + 26 + dropSpan * Curves.easeInOut.transform(craneDrop) +
        math.sin(time * math.pi * 4) * 2;
    canvas.drawLine(
      cableTop,
      Offset(trolleyX, hookY),
      Paint()
        ..color = _blueprint.withValues(alpha: .8)
        ..strokeWidth = 1.2,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(trolleyX, jibY + 3), width: 12, height: 6),
      Paint()..color = _steelDark,
    );
    // The glowing beam being placed.
    final beamPaint = Paint()..color = _steel;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(trolleyX, hookY + 6), width: 34, height: 7),
      beamPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(trolleyX, hookY + 6), width: 34, height: 7),
      Paint()
        ..color = _crane.withValues(alpha: .35 * (1 - craneDrop))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(ConstructionSitePainter old) =>
      old.outline != outline ||
      old.build != build ||
      old.complete != complete ||
      old.craneDrop != craneDrop ||
      old.time != time ||
      old.isMobile != isMobile;
}
