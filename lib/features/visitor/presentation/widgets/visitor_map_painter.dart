import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/visitor_location.dart';

class VisitorMapPainter extends CustomPainter {
  VisitorMapPainter({
    required this.locations,
    required this.pulseValue,
  });

  final List<VisitorLocation> locations;
  final double pulseValue;

  @override
  void paint(Canvas canvas, Size size) {
    if (locations.isEmpty) return;

    final baseLocationPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.accent;

    final pulsePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.accent.withValues(alpha: 0.25 * (1.0 - pulseValue));

    for (int i = 0; i < locations.length; i++) {
      final loc = locations[i];

      // Normalized coordinates mapped to India's geographical bounding box
      final normX = (loc.longitude - 68.184010) / 29.234136;
      final normY = (37.084109 - loc.latitude) / 30.33045;

      // Project onto the current canvas size (which is aspect-ratio locked by its parent)
      final x = normX * size.width;
      final y = normY * size.height;

      // Pulse animation for the latest (most recent) visitor
      if (i == 0) {
        canvas.drawCircle(Offset(x, y), 14.0 * pulseValue, pulsePaint);
        canvas.drawCircle(Offset(x, y), 8.0 * pulseValue, pulsePaint);
        baseLocationPaint.color = AppColors.accent;
      } else {
        baseLocationPaint.color = AppColors.accent.withValues(alpha: 0.7);
      }

      // Plot actual marker dot
      canvas.drawCircle(Offset(x, y), 4.5, baseLocationPaint);
    }
  }

  @override
  bool shouldRepaint(covariant VisitorMapPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || oldDelegate.locations != locations;
  }
}
