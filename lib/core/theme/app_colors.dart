import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color accent = Color(0xFF0EA5E9);
  static const Color bg = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF525252);
  static const Color border = Color(0xFFE5E5E5);

  // Used ONCE — hero name gradient only
  static const List<Color> nameGradient = [
    Color(0xFF0EA5E9),
    Color(0xFF6366F1),
  ];
}
