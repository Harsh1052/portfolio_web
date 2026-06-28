import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  // ─── Light ────────────────────────────────────────────────────────────────
  static ThemeData get light => _build(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.accent,
          surface: AppColors.surface,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
          outline: AppColors.border,
        ),
        scaffoldBg: AppColors.bg,
        cardColor: AppColors.surface,
        dividerColor: AppColors.border,
        baseTextTheme: ThemeData.light().textTheme,
      );

  // ─── Dark ─────────────────────────────────────────────────────────────────
  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          surface: AppColors.surfaceDark,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimaryDark,
          outline: AppColors.borderDark,
        ),
        scaffoldBg: AppColors.bgDark,
        cardColor: AppColors.surfaceDark,
        dividerColor: AppColors.borderDark,
        baseTextTheme: ThemeData.dark().textTheme,
      );

  // ─── Shared builder ───────────────────────────────────────────────────────
  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBg,
    required Color cardColor,
    required Color dividerColor,
    required TextTheme baseTextTheme,
  }) {
    final isLight = brightness == Brightness.light;
    final textPrimary =
        isLight ? AppColors.textPrimary : AppColors.textPrimaryDark;
    final textSecondary =
        isLight ? AppColors.textSecondary : AppColors.textSecondaryDark;
    final border = isLight ? AppColors.border : AppColors.borderDark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      // Inter as the base; Space Grotesk headings applied via AppTextStyles
      textTheme: GoogleFonts.interTextTheme(baseTextTheme).copyWith(
        // Make the default text colour follow the active theme
        bodyLarge: GoogleFonts.inter(color: textPrimary),
        bodyMedium: GoogleFonts.inter(color: textPrimary),
        bodySmall: GoogleFonts.inter(color: textSecondary),
        labelSmall: GoogleFonts.inter(color: textSecondary),
        titleLarge: GoogleFonts.spaceGrotesk(color: textPrimary),
        titleMedium: GoogleFonts.spaceGrotesk(color: textPrimary),
        titleSmall: GoogleFonts.spaceGrotesk(color: textPrimary),
        headlineLarge: GoogleFonts.spaceGrotesk(color: textPrimary),
        headlineMedium: GoogleFonts.spaceGrotesk(color: textPrimary),
        headlineSmall: GoogleFonts.spaceGrotesk(color: textPrimary),
        displayLarge: GoogleFonts.spaceGrotesk(color: textPrimary),
        displayMedium: GoogleFonts.spaceGrotesk(color: textPrimary),
        displaySmall: GoogleFonts.spaceGrotesk(color: textPrimary),
      ),
      dividerColor: dividerColor,
      cardColor: cardColor,
      // Suppress ink effects — not used in this design
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      // Focus ring
      focusColor: AppColors.accent.withValues(alpha: 0.2),
      // ElevatedButton defaults
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      // OutlinedButton defaults
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      // Card defaults
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
