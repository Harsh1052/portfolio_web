import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Accent (shared across both themes) ─────────────────────────────────────
  static const Color accent = Color(0xFF0EA5E9);

  // ── Light theme ─────────────────────────────────────────────────────────────
  static const Color bg = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF525252);
  static const Color border = Color(0xFFE5E5E5);

  // ── Dark theme ──────────────────────────────────────────────────────────────
  static const Color bgDark = Color(0xFF0A0A0A);
  static const Color surfaceDark = Color(0xFF141414);
  static const Color textPrimaryDark = Color(0xFFF3F4F6);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color borderDark = Color(0xFF1F2937);

  // ── Hero name gradient (shared) ─────────────────────────────────────────────
  static const List<Color> nameGradient = [
    Color(0xFF0EA5E9),
    Color(0xFF6366F1),
  ];
}
