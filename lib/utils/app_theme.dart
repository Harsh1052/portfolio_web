import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_constants.dart';

/// App Theme Configuration with Material 3 Design System
/// Provides light and dark themes with custom color schemes, typography, and component styles
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  // ==================== COLOR SCHEMES ====================

  /// Light theme color scheme with vibrant gradients
  static const ColorScheme lightColorScheme = ColorScheme.light(
    // Primary colors - Modern blue palette
    primary: AppColors.primaryBlue,
    primaryContainer: AppColors.primaryBlueLight,
    onPrimary: Colors.white,
    onPrimaryContainer: AppColors.primaryBlueDark,

    // Secondary colors - Accent purple palette
    secondary: AppColors.accentPurple,
    secondaryContainer: AppColors.accentPurpleLight,
    onSecondary: Colors.white,
    onSecondaryContainer: AppColors.accentPurpleDark,

    // Tertiary colors - Complementary teal
    tertiary: AppColors.accentTeal,
    tertiaryContainer: AppColors.accentTealLight,
    onTertiary: Colors.white,
    onTertiaryContainer: AppColors.accentTealDark,

    // Surface colors
    surface: AppColors.surfaceLight,
    surfaceContainerHighest: AppColors.surfaceVariantLight,
    onSurface: AppColors.textPrimaryLight,
    onSurfaceVariant: AppColors.textSecondaryLight,

    // Error colors
    error: AppColors.errorRed,
    onError: Colors.white,

    // Outline
    outline: AppColors.outlineLight,
    outlineVariant: AppColors.outlineVariantLight,
  );

  /// Dark theme color scheme with sophisticated gradients
  static const ColorScheme darkColorScheme = ColorScheme.dark(
    // Primary colors - Lighter shades for dark mode
    primary: AppColors.primaryBlueLight,
    primaryContainer: AppColors.primaryBlueDark,
    onPrimary: AppColors.backgroundDark,
    onPrimaryContainer: AppColors.primaryBlueLight,

    // Secondary colors
    secondary: AppColors.accentPurpleLight,
    secondaryContainer: AppColors.accentPurpleDark,
    onSecondary: AppColors.backgroundDark,
    onSecondaryContainer: AppColors.accentPurpleLight,

    // Tertiary colors
    tertiary: AppColors.accentTealLight,
    tertiaryContainer: AppColors.accentTealDark,
    onTertiary: AppColors.backgroundDark,
    onTertiaryContainer: AppColors.accentTealLight,

    // Surface colors
    surface: AppColors.surfaceDark,
    surfaceContainerHighest: AppColors.surfaceVariantDark,
    onSurface: AppColors.textPrimaryDark,
    onSurfaceVariant: AppColors.textSecondaryDark,

    // Error colors
    error: AppColors.errorRedLight,
    onError: AppColors.backgroundDark,

    // Outline
    outline: AppColors.outlineDark,
    outlineVariant: AppColors.outlineVariantDark,
  );

  // ==================== TEXT THEMES ====================

  /// Light theme text theme using Inter for body and Space Grotesk for headings
  static TextTheme get lightTextTheme {
    return TextTheme(
      // Display styles - Space Grotesk for impact
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.25,
        color: AppColors.textPrimaryLight,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        color: AppColors.textPrimaryLight,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.spaceGrotesk(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        color: AppColors.textPrimaryLight,
        height: 1.22,
      ),

      // Headline styles - Space Grotesk for hierarchy
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        color: AppColors.textPrimaryLight,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        color: AppColors.textPrimaryLight,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.textPrimaryLight,
        height: 1.33,
      ),

      // Title styles - Poppins for balance
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.textPrimaryLight,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: AppColors.textPrimaryLight,
        height: 1.5,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimaryLight,
        height: 1.43,
      ),

      // Body styles - Inter for readability
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.textPrimaryLight,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.textSecondaryLight,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.textSecondaryLight,
        height: 1.33,
      ),

      // Label styles - Inter for UI elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.textPrimaryLight,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textSecondaryLight,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textSecondaryLight,
        height: 1.45,
      ),
    );
  }

  /// Dark theme text theme
  static TextTheme get darkTextTheme {
    return TextTheme(
      // Display styles
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.25,
        color: AppColors.textPrimaryDark,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        color: AppColors.textPrimaryDark,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.spaceGrotesk(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        color: AppColors.textPrimaryDark,
        height: 1.22,
      ),

      // Headline styles
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        color: AppColors.textPrimaryDark,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        color: AppColors.textPrimaryDark,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.textPrimaryDark,
        height: 1.33,
      ),

      // Title styles
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.textPrimaryDark,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: AppColors.textPrimaryDark,
        height: 1.5,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimaryDark,
        height: 1.43,
      ),

      // Body styles
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.textPrimaryDark,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.textSecondaryDark,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.textSecondaryDark,
        height: 1.33,
      ),

      // Label styles
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.textPrimaryDark,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textSecondaryDark,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textSecondaryDark,
        height: 1.45,
      ),
    );
  }

  // ==================== LIGHT THEME ====================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      textTheme: lightTextTheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLight,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusLarge),
        ),
        color: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignConstants.spacingLarge,
            vertical: DesignConstants.spacingMedium,
          ),
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusMedium),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignConstants.spacingLarge,
            vertical: DesignConstants.spacingMedium,
          ),
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusMedium),
          ),
          side: const BorderSide(color: AppColors.primaryBlue, width: 2),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignConstants.spacingLarge,
            vertical: DesignConstants.spacingMedium,
          ),
          minimumSize: const Size(80, 48),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusMedium),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantLight,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignConstants.spacingMedium,
          vertical: DesignConstants.spacingMedium,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondaryLight,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantLight,
        selectedColor: AppColors.primaryBlueLight,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignConstants.spacingMedium,
          vertical: DesignConstants.spacingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariantLight,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryLight,
        size: 24,
      ),
    );
  }

  // ==================== DARK THEME ====================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      textTheme: darkTextTheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusLarge),
        ),
        color: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignConstants.spacingLarge,
            vertical: DesignConstants.spacingMedium,
          ),
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusMedium),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignConstants.spacingLarge,
            vertical: DesignConstants.spacingMedium,
          ),
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusMedium),
          ),
          side: const BorderSide(color: AppColors.primaryBlueLight, width: 2),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignConstants.spacingLarge,
            vertical: DesignConstants.spacingMedium,
          ),
          minimumSize: const Size(80, 48),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusMedium),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          borderSide:
              const BorderSide(color: AppColors.primaryBlueLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          borderSide:
              const BorderSide(color: AppColors.errorRedLight, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          borderSide:
              const BorderSide(color: AppColors.errorRedLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignConstants.spacingMedium,
          vertical: DesignConstants.spacingMedium,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondaryDark,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantDark,
        selectedColor: AppColors.primaryBlueDark,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryDark,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignConstants.spacingMedium,
          vertical: DesignConstants.spacingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariantDark,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
        size: 24,
      ),
    );
  }
}
