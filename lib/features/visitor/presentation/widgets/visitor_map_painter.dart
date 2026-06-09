import 'dart:math' as math;
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

  /// A simplified, high-tech binary representation of the world map landmasses.
  /// 1 represents land (dots), 0 represents water (space).
  /// Size: 28 rows x 64 columns.
  static const List<String> _worldGrid = [
    "                   111111000000000000000000000000000000000000000",
    "               1111111111110000000000000000000000000000000000000",
    "            1111111111111111110000000011111111000000000000000000",
    "         1111111111111111111111000001111111111111100000000000000",
    "        11111111111111111111111100011111111111111111110000000000",
    "        0111111111111111111111100011111111111111111111110000000",
    "         001111111111111111111000011111111111111111111111100000",
    "          00111111111111111110000001111111111111111111111111000",
    "           000111111111111110000000111111111111111111111111110",
    "            000111111111110000000001111111111111111111111111110",
    "             00011111111000000000000111111111111111111111111100",
    "              0001111100000000000000111111111111111111111111000",
    "               000111100000000000000011111111111111111111110000",
    "                00111100000000000000011111111111111111111100000",
    "                00111110000000000000001111111111111111111000000",
    "                 0111110000000000000000111111111111111110000000",
    "                 0011110000000000000000111111111111111000000000",
    "                 0001110000000000000000011111111111110000000000",
    "                  001110000000000000000001111111111100000000000",
    "                  001110000000000000000000111111111000000000000",
    "                   00110000000000000000000011111110000000000000",
    "                   00110000000000000000000001111100000000000000",
    "                    0110000000000000000000000111100000000000000",
    "                    0010000000000000000000000011100011110000000",
    "                     010000000000000000000000001100111111000000",
    "                     00000000000000000000000000000111111100000",
    "                      0000000000000000000000000000111111110000",
    "                      0000000000000000000000000000011111100000"
  ];

  static const int _gridRows = 28;
  static const int _gridCols = 64;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Dotted Background Map
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.textSecondary.withValues(alpha: 0.1);

    final cellWidth = size.width / _gridCols;
    final cellHeight = size.height / _gridRows;
    final dotRadius = math.min(cellWidth, cellHeight) * 0.35;

    for (int r = 0; r < _gridRows; r++) {
      final rowStr = _worldGrid[r];
      for (int c = 0; c < _gridCols; c++) {
        // Safe check for row string length boundaries
        if (c < rowStr.length && rowStr[c] == '1') {
          final x = c * cellWidth + cellWidth / 2;
          final y = r * cellHeight + cellHeight / 2;
          canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
        }
      }
    }

    // 2. Plot visitor locations
    if (locations.isEmpty) return;

    final baseLocationPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.accent;

    final pulsePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.accent.withValues(alpha: 0.25 * (1.0 - pulseValue));

    for (int i = 0; i < locations.length; i++) {
      final loc = locations[i];

      // Coordinate projections (Equirectangular layout match)
      final x = ((loc.longitude + 180) / 360) * size.width;
      // Latitude project: 90 is top, -90 is bottom
      final y = ((90 - loc.latitude) / 180) * size.height;

      // Pulse animation for the latest (most recent) visitor
      if (i == 0) {
        canvas.drawCircle(Offset(x, y), 14.0 * pulseValue, pulsePaint);
        canvas.drawCircle(Offset(x, y), 8.0 * pulseValue, pulsePaint);
        baseLocationPaint.color = AppColors.accent;
      } else {
        baseLocationPaint.color = AppColors.accent.withValues(alpha: 0.7);
      }

      // Plot actual marker
      canvas.drawCircle(Offset(x, y), 3.5, baseLocationPaint);
    }
  }

  @override
  bool shouldRepaint(covariant VisitorMapPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || oldDelegate.locations != locations;
  }
}
