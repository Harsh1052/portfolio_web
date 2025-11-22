import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.accent,
      secondaryContainer: AppColors.accentLight,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(textStyle: AppTextStyles.displayLarge),
      displayMedium:
          GoogleFonts.poppins(textStyle: AppTextStyles.displayMedium),
      displaySmall: GoogleFonts.poppins(textStyle: AppTextStyles.displaySmall),
      headlineLarge:
          GoogleFonts.poppins(textStyle: AppTextStyles.headlineLarge),
      headlineMedium:
          GoogleFonts.poppins(textStyle: AppTextStyles.headlineMedium),
      headlineSmall:
          GoogleFonts.poppins(textStyle: AppTextStyles.headlineSmall),
      titleLarge: GoogleFonts.poppins(textStyle: AppTextStyles.titleLarge),
      titleMedium: GoogleFonts.poppins(textStyle: AppTextStyles.titleMedium),
      titleSmall: GoogleFonts.poppins(textStyle: AppTextStyles.titleSmall),
      bodyLarge: GoogleFonts.roboto(textStyle: AppTextStyles.bodyLarge),
      bodyMedium: GoogleFonts.roboto(textStyle: AppTextStyles.bodyMedium),
      bodySmall: GoogleFonts.roboto(textStyle: AppTextStyles.bodySmall),
      labelLarge: GoogleFonts.roboto(textStyle: AppTextStyles.labelLarge),
      labelMedium: GoogleFonts.roboto(textStyle: AppTextStyles.labelMedium),
      labelSmall: GoogleFonts.roboto(textStyle: AppTextStyles.labelSmall),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      color: AppColors.surface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.all(AppConstants.spacingM),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primary,
      labelStyle: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      primaryContainer: AppColors.primaryDark,
      secondary: AppColors.accentLight,
      secondaryContainer: AppColors.accentDark,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
      onPrimary: AppColors.backgroundDark,
      onSecondary: AppColors.backgroundDark,
      onSurface: AppColors.textPrimaryDark,
      onError: AppColors.backgroundDark,
    ),
    textTheme:
        GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.poppins(
        textStyle: AppTextStyles.displayLarge
            .copyWith(color: AppColors.textPrimaryDark),
      ),
      displayMedium: GoogleFonts.poppins(
        textStyle: AppTextStyles.displayMedium
            .copyWith(color: AppColors.textPrimaryDark),
      ),
      displaySmall: GoogleFonts.poppins(
        textStyle: AppTextStyles.displaySmall
            .copyWith(color: AppColors.textPrimaryDark),
      ),
      headlineLarge: GoogleFonts.poppins(
        textStyle: AppTextStyles.headlineLarge
            .copyWith(color: AppColors.textPrimaryDark),
      ),
      headlineMedium: GoogleFonts.poppins(
        textStyle: AppTextStyles.headlineMedium
            .copyWith(color: AppColors.textPrimaryDark),
      ),
      headlineSmall: GoogleFonts.poppins(
        textStyle: AppTextStyles.headlineSmall
            .copyWith(color: AppColors.textPrimaryDark),
      ),
      titleLarge: GoogleFonts.poppins(
        textStyle:
            AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimaryDark),
      ),
      titleMedium: GoogleFonts.poppins(
        textStyle: AppTextStyles.titleMedium
            .copyWith(color: AppColors.textPrimaryDark),
      ),
      titleSmall: GoogleFonts.poppins(
        textStyle:
            AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimaryDark),
      ),
      bodyLarge: GoogleFonts.roboto(
        textStyle:
            AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
      ),
      bodyMedium: GoogleFonts.roboto(
        textStyle: AppTextStyles.bodyMedium
            .copyWith(color: AppColors.textSecondaryDark),
      ),
      bodySmall: GoogleFonts.roboto(
        textStyle: AppTextStyles.bodySmall
            .copyWith(color: AppColors.textSecondaryDark),
      ),
      labelLarge: GoogleFonts.roboto(
        textStyle:
            AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryDark),
      ),
      labelMedium: GoogleFonts.roboto(
        textStyle: AppTextStyles.labelMedium
            .copyWith(color: AppColors.textSecondaryDark),
      ),
      labelSmall: GoogleFonts.roboto(
        textStyle: AppTextStyles.labelSmall
            .copyWith(color: AppColors.textSecondaryDark),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      color: AppColors.surfaceDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.all(AppConstants.spacingM),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedColor: AppColors.primaryLight,
      labelStyle: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
    ),
  );
}
