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

    // Primary pulse wave - fades out as it expands
    final pulsePaint1 = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.accent.withValues(alpha: 0.45 * (1.0 - pulseValue));

    for (int i = 0; i < locations.length; i++) {
      final loc = locations[i];

      // Normalized coordinates mapped to India's geographical bounding box
      final normX = (loc.longitude - 68.184010) / 29.234136;
      final normY = (37.084109 - loc.latitude) / 30.33045;

      // Project onto the current canvas size
      final x = normX * size.width;
      final y = normY * size.height;

      double markerRadius = 4.5;

      // Pulse animation for the latest (most recent) visitor
      if (i == 0) {
        // Outer expanding ripple 1
        canvas.drawCircle(Offset(x, y), 4.5 + 24.0 * pulseValue, pulsePaint1);

        // Delayed secondary ripple 2 (starts when ripple 1 is halfway)
        if (pulseValue > 0.5) {
          final double secondPulseVal = (pulseValue - 0.5) * 2.0;
          final pulsePaint2 = Paint()
            ..style = PaintingStyle.fill
            ..color = AppColors.accent.withValues(alpha: 0.3 * (1.0 - secondPulseVal));
          canvas.drawCircle(Offset(x, y), 4.5 + 16.0 * secondPulseVal, pulsePaint2);
        }

        // Slightly larger pulsating base dot
        markerRadius = 6.0 + 1.5 * (1.0 - pulseValue);
        baseLocationPaint.color = AppColors.accent;
      } else {
        baseLocationPaint.color = AppColors.accent.withValues(alpha: 0.75);
      }

      // Plot actual marker dot
      canvas.drawCircle(Offset(x, y), markerRadius, baseLocationPaint);

      // Draw a glowing white core in the center of the active visitor dot
      if (i == 0) {
        final whiteCorePaint = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white;
        canvas.drawCircle(Offset(x, y), 2.0, whiteCorePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant VisitorMapPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || oldDelegate.locations != locations;
  }
}
