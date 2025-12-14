import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TerminalTheme {
  // Colors
  static const Color voidBlack = Color(0xFF050505);
  static const Color neonGreen = Color(0xFF00FF41);
  static const Color cyberBlue = Color(0xFF00F0FF);
  static const Color warningYellow = Color(0xFFFFD700);
  static const Color errorRed = Color(0xFFFF0033);
  static const Color dimText = Color(0xFF4A5568);

  // Text Styles
  static TextStyle get terminalText => GoogleFonts.jetBrainsMono(
        color: neonGreen,
        fontSize: 14,
        height: 1.5,
      );

  static TextStyle get terminalHeader => GoogleFonts.jetBrainsMono(
        color: cyberBlue,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.2,
      );

  static TextStyle get terminalWarning => GoogleFonts.jetBrainsMono(
        color: warningYellow,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get terminalError => GoogleFonts.jetBrainsMono(
        color: errorRed,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get terminalDim => GoogleFonts.jetBrainsMono(
        color: dimText,
        fontSize: 12,
        fontStyle: FontStyle.italic,
      );

  // Theme Data
  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: voidBlack,
        primaryColor: neonGreen,
        colorScheme: const ColorScheme.dark(
          primary: neonGreen,
          secondary: cyberBlue,
          surface: voidBlack,
          error: errorRed,
          onPrimary: voidBlack,
          onSecondary: voidBlack,
          onSurface: neonGreen,
          onError: voidBlack,
        ),
        textTheme: TextTheme(
          bodyMedium: terminalText,
          bodySmall: terminalDim,
          titleLarge: terminalHeader,
        ),
        dividerColor: neonGreen.withValues(alpha: 0.2),
        iconTheme: const IconThemeData(
          color: neonGreen,
          size: 20,
        ),
      );
}
