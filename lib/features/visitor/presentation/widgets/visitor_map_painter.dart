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
  /// Size: 24 rows x 64 columns.
  static const List<String> _worldGrid = [
    "                  1111110000000000000000000000000000000000000000", // Row 0
    "              11111111111100000000000000000000000111111111100000", // Row 1
    "           1111111111111111100000000111111110001111111111111111", // Row 2: North America / Asia north
    "        1111111111111111111111000001111111111111111111111111111", // Row 3
    "       11111111111111111111111100011111111111111111111111111110", // Row 4: USA / Europe / Asia middle
    "       01111111111111111111111000111111111111111111111111111100", // Row 5: Central America / India / China
    "        0011111111111111111110000111111111111111111111111110000", // Row 6: South America north / India / SE Asia
    "         001111111111111111100000011111111111111111111111110000", // Row 7
    "          00011111111111111000000011111111111111111111111100000", // Row 8
    "           0001111111111100000000011111111111111111111100000000", // Row 9: South America middle / Africa / Indonesia
    "            000111111110000000000001111111111111111111000000000", // Row 10
    "             00011111000000000000001111111111111111110000000000", // Row 11
    "              0001111000000000000000111111111111111100000000000", // Row 12: South America south / Madagascar
    "               001111000000000000000111111111111111000000000000", // Row 13
    "               001111100000000000000011111111111100000000000000", // Row 14
    "                01111100000000000000001111111111000000111111000", // Row 15: Australia north
    "                00111100000000000000001111111100000001111111100", // Row 16: Australia middle
    "                00011100000000000000000111111000000000111111000", // Row 17: Australia south
    "                 0011100000000000000000011110000000000011100000", // Row 18
    "                 0011100000000000000000001100000000000000000000", // Row 19
    "                  001100000000000000000000000000000000000000000", // Row 20
    "                  001100000000000000000000000000000000000000000", // Row 21
    "                   01100000000000000000000000000000000000000000", // Row 22
    "                   00000000000000000000000000000000000000000000"  // Row 23
  ];

  static const int _gridRows = 24;
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
      final rowStr = _worldGrid[r].padRight(_gridCols, '0');
      for (int c = 0; c < _gridCols; c++) {
        if (rowStr[c] == '1') {
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
