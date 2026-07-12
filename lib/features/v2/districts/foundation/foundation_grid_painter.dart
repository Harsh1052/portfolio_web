import 'package:flutter/material.dart';

/// Drafting-paper overlay for Foundation Square — a faint blueprint grid
/// with a margin frame and corner ticks, sweeping in with [reveal] like a
/// sheet being unrolled.
class FoundationGridPainter extends CustomPainter {
  FoundationGridPainter({required this.reveal});

  final double reveal;

  static const _line = Color(0xFFBFDCFF);

  @override
  void paint(Canvas canvas, Size size) {
    if (reveal <= 0.01) return;
    final w = size.width * reveal;
    final h = size.height;

    final minor = Paint()
      ..color = _line.withValues(alpha: .07)
      ..strokeWidth = 1;
    final major = Paint()
      ..color = _line.withValues(alpha: .14)
      ..strokeWidth = 1;

    const cell = 44.0;
    for (var x = 0.0; x <= w; x += cell) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, h),
        (x / cell) % 4 == 0 ? major : minor,
      );
    }
    for (var y = 0.0; y <= h; y += cell) {
      canvas.drawLine(
        Offset(0, y),
        Offset(w, y),
        (y / cell) % 4 == 0 ? major : minor,
      );
    }

    // Margin frame + corner ticks — the drafting-sheet border.
    final frame = Paint()
      ..color = _line.withValues(alpha: .30 * reveal)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final margin = Rect.fromLTWH(
      18,
      18,
      (size.width - 36) * reveal,
      h - 36,
    );
    canvas.drawRect(margin, frame);

    const tick = 10.0;
    for (final corner in [
      margin.topLeft,
      margin.topRight,
      margin.bottomLeft,
      margin.bottomRight,
    ]) {
      canvas.drawLine(
          corner.translate(-tick / 2, 0), corner.translate(tick / 2, 0), frame);
      canvas.drawLine(
          corner.translate(0, -tick / 2), corner.translate(0, tick / 2), frame);
    }
  }

  @override
  bool shouldRepaint(FoundationGridPainter old) => old.reveal != reveal;
}
