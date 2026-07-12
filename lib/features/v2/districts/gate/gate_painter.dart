import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// The monumental gate itself — stone towers, arch, and two great doors
/// that swing open with scroll.
///
/// * [open] 0..1 — doors swing outward, warm city light spills through.
/// * [part] 0..1 — endgame: towers slide off to the edges and the arch
///   fades, letting the visitor pass into the city.
///
/// Palette matches the hero-illustration family (cream stone, maroon wood,
/// warm window light) so painted geometry and raster art read as one style.
class GatePainter extends CustomPainter {
  GatePainter({
    required this.open,
    required this.part,
    required this.isMobile,
  });

  final double open;
  final double part;
  final bool isMobile;

  static const _stone = Color(0xFFEAE0C8);
  static const _stoneShade = Color(0xFFCFC09A);
  static const _stoneDark = Color(0xFFB3A379);
  static const _wood = Color(0xFF5C2A1E);
  static const _woodDark = Color(0xFF3D1A10);
  static const _roof = Color(0xFF7D2B2B);
  static const _light = Color(0xFFFFD98A);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final gy = h * 0.86; // ground line
    final gapHalf = w * (isMobile ? 0.20 : 0.13);
    final towerW = w * (isMobile ? 0.17 : 0.11);
    final towerH = h * 0.52;
    final archTop = gy - towerH * 0.82;
    final slide = part * (w * 0.42 + towerW);

    // ── Light spill through the opening (behind the doors) ──
    if (open > 0.01) {
      final spillW = gapHalf * 2 * open;
      final center = Offset(cx, archTop + (gy - archTop) * .55);
      canvas.drawRect(
        Rect.fromCenter(center: center, width: spillW, height: gy - archTop),
        Paint()
          ..shader = ui.Gradient.radial(
            center,
            (gy - archTop) * .9,
            [
              _light.withValues(alpha: 0.55 * open * (1 - part)),
              _light.withValues(alpha: 0.0),
            ],
          ),
      );
    }

    // ── Doors (drawn before towers so jambs overlap them) ──
    final doorTop = archTop + (gy - archTop) * 0.08;
    final doorAlpha = (1 - part).clamp(0.0, 1.0);
    if (doorAlpha > 0) {
      _drawDoor(canvas, cx, doorTop, gy, gapHalf, left: true, alpha: doorAlpha);
      _drawDoor(canvas, cx, doorTop, gy, gapHalf, left: false, alpha: doorAlpha);
    }

    // ── Towers ──
    _drawTower(
      canvas,
      Rect.fromLTWH(cx - gapHalf - towerW - slide, gy - towerH, towerW, towerH),
      seedOffset: 0,
    );
    _drawTower(
      canvas,
      Rect.fromLTWH(cx + gapHalf + slide, gy - towerH, towerW, towerH),
      seedOffset: 3,
    );

    // ── Arch spanning the opening (fades as towers part) ──
    final archAlpha = (1 - part * 1.6).clamp(0.0, 1.0);
    if (archAlpha > 0) {
      _drawArch(canvas, cx, archTop, gapHalf, towerW, archAlpha);
    }

    // ── Ground ──
    canvas.drawRect(
      Rect.fromLTWH(0, gy, w, h - gy),
      Paint()..color = const Color(0xFF1A0F2E),
    );
    // Path of warm light on the ground, growing as doors open.
    if (open > 0.01) {
      final pathW = gapHalf * 1.7 * open;
      final path = Path()
        ..moveTo(cx - pathW * .4, gy)
        ..lineTo(cx + pathW * .4, gy)
        ..lineTo(cx + pathW, h)
        ..lineTo(cx - pathW, h)
        ..close();
      canvas.drawPath(
        path,
        Paint()
          ..color = _light.withValues(alpha: 0.14 * open * (1 - part * .7)),
      );
    }
  }

  void _drawDoor(
    Canvas canvas,
    double cx,
    double top,
    double bottom,
    double gapHalf, {
    required bool left,
    required double alpha,
  }) {
    final dir = left ? -1.0 : 1.0;
    final jambX = cx + dir * gapHalf; // hinge side
    // Inner edge travels from center to the jamb as the door opens.
    final innerX = cx + dir * gapHalf * open.clamp(0.0, 1.0);
    if ((innerX - jambX).abs() < 1) return; // fully open

    // Fake perspective: the moving edge shortens as it swings away.
    final inset = 14.0 * open;
    final face = Path()
      ..moveTo(jambX, top)
      ..lineTo(innerX, top + inset)
      ..lineTo(innerX, bottom - inset * .4)
      ..lineTo(jambX, bottom)
      ..close();

    final shade = Color.lerp(_wood, _woodDark, open * .8)!;
    canvas.drawPath(face, Paint()..color = shade.withValues(alpha: alpha));

    // Plank lines + iron studs.
    final detail = Paint()
      ..color = _woodDark.withValues(alpha: alpha * .9)
      ..strokeWidth = 1.4;
    final span = innerX - jambX;
    for (var i = 1; i < 4; i++) {
      final x = jambX + span * (i / 4);
      final yInset = inset * (i / 4);
      canvas.drawLine(
        Offset(x, top + yInset + 4),
        Offset(x, bottom - yInset * .4 - 4),
        detail,
      );
    }
    final stud = Paint()..color = _light.withValues(alpha: alpha * .5);
    canvas.drawCircle(
      Offset(jambX + span * .82, top + (bottom - top) * .52),
      2.6,
      stud,
    );
  }

  void _drawTower(Canvas canvas, Rect r, {required int seedOffset}) {
    // Body with side shading.
    canvas.drawRect(r, Paint()..color = _stone);
    canvas.drawRect(
      Rect.fromLTWH(r.left, r.top, r.width * .22, r.height),
      Paint()..color = _stoneShade,
    );

    // Crenellations.
    final merlonW = r.width / 5;
    final cren = Paint()..color = _stone;
    for (var i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          r.left + merlonW * (i * 2 * 0.9),
          r.top - merlonW * .9,
          merlonW,
          merlonW,
        ),
        cren,
      );
    }

    // Roof cap.
    final roof = Path()
      ..moveTo(r.left - r.width * .12, r.top - merlonW * .9)
      ..lineTo(r.center.dx, r.top - r.height * .18 - merlonW)
      ..lineTo(r.right + r.width * .12, r.top - merlonW * .9)
      ..close();
    canvas.drawPath(roof, Paint()..color = _roof);

    // Stone courses.
    final course = Paint()
      ..color = _stoneDark.withValues(alpha: .45)
      ..strokeWidth = 1;
    for (var i = 1; i < 6; i++) {
      final y = r.top + r.height * (i / 6);
      canvas.drawLine(Offset(r.left, y), Offset(r.right, y), course);
    }

    // Arched windows, warm-lit.
    final winW = r.width * .24;
    final winPaint = Paint()..color = _light.withValues(alpha: .9);
    for (var i = 0; i < 2; i++) {
      final wy = r.top + r.height * (.24 + .34 * i) + (seedOffset % 2) * 6;
      final rect = Rect.fromCenter(
        center: Offset(r.center.dx, wy),
        width: winW,
        height: winW * 1.7,
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: Radius.circular(winW / 2),
          topRight: Radius.circular(winW / 2),
        ),
        winPaint,
      );
    }
  }

  void _drawArch(
    Canvas canvas,
    double cx,
    double archTop,
    double gapHalf,
    double towerW,
    double alpha,
  ) {
    final stone = Paint()..color = _stone.withValues(alpha: alpha);
    final shade = Paint()..color = _stoneShade.withValues(alpha: alpha);

    // Lintel band above the opening.
    final bandH = towerW * .55;
    canvas.drawRect(
      Rect.fromLTWH(cx - gapHalf - 8, archTop - bandH, (gapHalf + 8) * 2, bandH),
      stone,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - gapHalf - 8, archTop - bandH, (gapHalf + 8) * 2, bandH * .3),
      shade,
    );

    // Semicircular arch over the doorway.
    final arch = Path()
      ..moveTo(cx - gapHalf, archTop + gapHalf * .6)
      ..arcTo(
        Rect.fromCircle(center: Offset(cx, archTop + gapHalf * .6), radius: gapHalf),
        math.pi,
        math.pi,
        false,
      )
      ..lineTo(cx + gapHalf, archTop - 2)
      ..lineTo(cx - gapHalf, archTop - 2)
      ..close();
    canvas.drawPath(arch, stone);

    // Keystone.
    final ks = Path()
      ..moveTo(cx - 9, archTop - bandH)
      ..lineTo(cx + 9, archTop - bandH)
      ..lineTo(cx + 6, archTop - bandH + bandH * .55)
      ..lineTo(cx - 6, archTop - bandH + bandH * .55)
      ..close();
    canvas.drawPath(ks, Paint()..color = _stoneDark.withValues(alpha: alpha));
  }

  @override
  bool shouldRepaint(GatePainter old) =>
      old.open != open || old.part != part || old.isMobile != isMobile;
}
