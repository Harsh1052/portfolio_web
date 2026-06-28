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

    for (int i = 0; i < locations.length; i++) {
      final loc = locations[i];

      // Normalized coordinates mapped to India's geographical bounding box
      final normX = (loc.longitude - 68.184010) / 29.234136;
      final normY = (37.084109 - loc.latitude) / 30.33045;

      // Project onto the current canvas size
      final x = normX * size.width;
      final y = normY * size.height;

      const double markerRadius = 4.5;

      // Pulse animation for the latest (most recent) visitor
      if (i == 0) {
        // Sharp digital blink at 2Hz (4 full blinks per 2-second cycle)
        // 250ms ON, 250ms OFF. Perfect for attracting attention.
        final bool isOn = (pulseValue * 8).toInt() % 2 == 0;
        baseLocationPaint.color = AppColors.accent.withValues(alpha: isOn ? 1.0 : 0.15);
      } else {
        baseLocationPaint.color = AppColors.accent.withValues(alpha: 0.75);
      }

      // Plot actual marker dot
      canvas.drawCircle(Offset(x, y), markerRadius, baseLocationPaint);
    }
  }

  @override
  bool shouldRepaint(covariant VisitorMapPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || oldDelegate.locations != locations;
  }
}
