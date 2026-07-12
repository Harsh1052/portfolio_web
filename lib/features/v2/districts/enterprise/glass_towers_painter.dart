import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/progress_utils.dart';

/// Enterprise Heights — blue-hour glass towers, all procedural:
/// staggered rising skyscrapers with glass sheen, elevator cabs traveling
/// the shafts, blinking rooftop beacons — and two signature moments:
/// windows on the widest tower light up to spell **50K**, and a
/// crash-rate chart draws itself falling as the visitor scrolls.
///
/// * [t] district progress — build-in, matrix reveal, graph draw, exit dim.
/// * [time] loops 0..1 — elevators, beacons, matrix shimmer.
class GlassTowersPainter extends CustomPainter {
  GlassTowersPainter({
    required this.t,
    required this.time,
    required this.isMobile,
  });

  final double t;
  final double time;
  final bool isMobile;

  static const _glassDark = Color(0xFF16263F);
  static const _glassLight = Color(0xFF23405F);
  static const _sheen = Color(0xFF7DD3FC);
  static const _window = Color(0xFFA8D8F0);
  static const _matrixLit = Color(0xFFFFD98A);
  static const _ground = Color(0xFF0A1526);
  static const _graphLine = Color(0xFF7DD3FC);
  static const _graphBad = Color(0xFFEF4444);

  /// 3×5 dot font for the "50K" window matrix.
  static const _font = <String, List<String>>{
    '5': ['111', '100', '111', '001', '111'],
    '0': ['111', '101', '101', '101', '111'],
    'K': ['101', '101', '110', '101', '101'],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final gy = h * 0.88;
    final buildIn = t.band(0.06, 0.30, curve: Curves.easeOutCubic);
    final matrixBand = t.band(0.34, 0.56);
    final graphBand = t.band(0.58, 0.80, curve: Curves.easeInOut);
    final dim = t.band(0.88, 1.0);

    // Tower layout: (xFrac, wFrac, hFrac); index 1 is the matrix tower.
    final specs = isMobile
        ? const [(0.06, 0.22, 0.34), (0.34, 0.42, 0.52), (0.80, 0.16, 0.28)]
        : const [
            (0.05, 0.13, 0.36),
            (0.38, 0.24, 0.56),
            (0.22, 0.12, 0.44),
            (0.66, 0.14, 0.40),
            (0.83, 0.11, 0.30),
          ];

    final rnd = math.Random(41);
    for (var i = 0; i < specs.length; i++) {
      final (xf, wf, hf) = specs[i];
      final stagger = i * 0.12;
      final rise = Curves.easeOutCubic
          .transform(((buildIn - stagger) / (1 - stagger)).clamp(0.0, 1.0));
      if (rise <= 0) continue;

      final tw = w * wf;
      final th = h * hf * rise;
      final r = Rect.fromLTWH(w * xf, gy - th, tw, th);
      _tower(
        canvas,
        r,
        rnd,
        rise: rise,
        dim: dim,
        isMatrixTower: i == 1,
        matrixBand: matrixBand,
        elevatorPhase: i * 0.37,
      );
    }

    // ── Crash-rate chart (desktop; mobile gets the counters instead) ──
    if (!isMobile && graphBand > 0.01) {
      _crashGraph(
        canvas,
        Rect.fromLTWH(w * .06, h * .30, w * .22, h * .20),
        graphBand,
        dim,
      );
    }

    // ── Ground ──
    canvas.drawRect(
      Rect.fromLTWH(0, gy, w, h - gy),
      Paint()..color = _ground,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, gy, w, 2),
      Paint()..color = _sheen.withValues(alpha: .25 * buildIn * (1 - dim)),
    );
  }

  void _tower(
    Canvas canvas,
    Rect r,
    math.Random rnd, {
    required double rise,
    required double dim,
    required bool isMatrixTower,
    required double matrixBand,
    required double elevatorPhase,
  }) {
    final alpha = rise * (1 - dim * .45);

    // Body + glass sheen column.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        r,
        topLeft: const Radius.circular(3),
        topRight: const Radius.circular(3),
      ),
      Paint()..color = _glassDark.withValues(alpha: alpha),
    );
    canvas.drawRect(
      Rect.fromLTWH(r.left + r.width * .12, r.top, r.width * .16, r.height),
      Paint()..color = _glassLight.withValues(alpha: alpha),
    );
    canvas.drawRect(
      Rect.fromLTWH(r.left + r.width * .16, r.top, 3, r.height),
      Paint()..color = _sheen.withValues(alpha: .30 * alpha),
    );

    // Rooftop beacon.
    final blink = (math.sin((time * 4 + elevatorPhase) * math.pi * 2) + 1) / 2;
    canvas.drawLine(
      r.topCenter,
      r.topCenter.translate(0, -12),
      Paint()
        ..color = _glassLight.withValues(alpha: alpha)
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      r.topCenter.translate(0, -14),
      2.4,
      Paint()
        ..color = const Color(0xFFEF4444).withValues(alpha: blink * alpha),
    );

    // Window grid.
    const sx = 13.0, sy = 15.0;
    final cols = math.max(1, ((r.width - 10) / sx).floor());
    final rows = math.max(1, ((r.height - 12) / sy).floor());

    // Matrix placement (centered, upper half of the tower).
    const matrixCols = 11; // 3+1+3+1+3
    const matrixRows = 5;
    final mc0 = ((cols - matrixCols) / 2).floor();
    const mr0 = 2;
    final showMatrix =
        isMatrixTower && matrixBand > 0 && cols >= matrixCols && rows >= 9;

    for (var c = 0; c < cols; c++) {
      for (var row = 0; row < rows; row++) {
        final inMatrix = showMatrix &&
            c >= mc0 &&
            c < mc0 + matrixCols &&
            row >= mr0 &&
            row < mr0 + matrixRows &&
            _matrixDot(c - mc0, row - mr0);

        double a;
        Color color;
        if (inMatrix) {
          // Cells sparkle on in a seeded order as the band advances.
          final threshold =
              math.Random(c * 31 + row * 7).nextDouble() * .85;
          final on = matrixBand > threshold;
          final shimmer =
              .8 + .2 * math.sin((time * 2 + c * .3 + row * .2) * math.pi * 2);
          a = on ? .95 * shimmer : .06;
          color = _matrixLit;
        } else {
          final litSeed = rnd.nextDouble();
          if (litSeed > .32) continue; // dark window
          a = .5 + litSeed;
          color = _window;
        }
        canvas.drawRect(
          Rect.fromLTWH(
            r.left + 6 + c * sx,
            r.top + 8 + row * sy,
            4.6,
            6.2,
          ),
          Paint()..color = color.withValues(alpha: (a * alpha).clamp(0.0, 1.0)),
        );
      }
    }

    // Elevator: a bright cab traveling the shaft (right edge).
    final cycle = (time * 1.4 + elevatorPhase) % 1.0;
    final upDown = cycle < .5 ? cycle * 2 : (1 - cycle) * 2;
    final cabY = r.bottom - 10 - (r.height - 24) * upDown;
    canvas.drawRect(
      Rect.fromLTWH(r.right - 9, r.top, 3, r.height),
      Paint()..color = _glassLight.withValues(alpha: .6 * alpha),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(r.right - 12, cabY, 9, 12),
        const Radius.circular(2),
      ),
      Paint()..color = _matrixLit.withValues(alpha: .9 * alpha),
    );
  }

  bool _matrixDot(int c, int row) {
    // Layout: 5 [gap] 0 [gap] K  → columns 0-2, 4-6, 8-10.
    String? ch;
    int local;
    if (c <= 2) {
      ch = '5';
      local = c;
    } else if (c >= 4 && c <= 6) {
      ch = '0';
      local = c - 4;
    } else if (c >= 8 && c <= 10) {
      ch = 'K';
      local = c - 8;
    } else {
      return false;
    }
    return _font[ch]![row][local] == '1';
  }

  void _crashGraph(Canvas canvas, Rect r, double band, double dim) {
    final alpha = (1 - dim).clamp(0.0, 1.0);
    // Frame + axes.
    final axis = Paint()
      ..color = _glassLight.withValues(alpha: .9 * alpha)
      ..strokeWidth = 1.4;
    canvas.drawLine(r.bottomLeft, r.bottomRight, axis);
    canvas.drawLine(r.bottomLeft, r.topLeft, axis);

    // Jagged crash-rate line descending 60% as the band draws it.
    final points = <Offset>[];
    final rnd = math.Random(9);
    const n = 9;
    for (var i = 0; i <= n; i++) {
      final u = i / n;
      final fall = Curves.easeInOut.transform(u) * .6;
      final jitter = (rnd.nextDouble() - .5) * .08;
      points.add(Offset(
        r.left + r.width * u,
        r.top + r.height * (.15 + fall + jitter).clamp(0.0, .95),
      ));
    }
    final visible = (points.length - 1) * band;
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      if (i > visible) break;
      path.lineTo(points[i].dx, points[i].dy);
    }
    // Partial segment for smooth drawing.
    final seg = visible.floor();
    if (seg < points.length - 1 && visible > seg) {
      final p = Offset.lerp(points[seg], points[seg + 1], visible - seg)!;
      path.lineTo(p.dx, p.dy);
      // Leading dot.
      canvas.drawCircle(
        p,
        3.4,
        Paint()..color = _graphLine.withValues(alpha: alpha),
      );
      canvas.drawCircle(
        p,
        7,
        Paint()..color = _graphLine.withValues(alpha: .25 * alpha),
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Color.lerp(_graphBad, _graphLine, band)!
            .withValues(alpha: alpha)
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(GlassTowersPainter old) =>
      old.t != t || old.time != time || old.isMobile != isMobile;
}
