import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// All sizes in logical px from the spec's rem values (1rem = 16px).
// Letter-spacing computed as: -0.02em * fontSize.
abstract final class AppTextStyles {
  // h1 — name: Space Grotesk 600, 4.5rem, lh 1.05, tracking -0.02em
  static final TextStyle h1 = GoogleFonts.spaceGrotesk(
    fontSize: 72,
    fontWeight: FontWeight.w600,
    height: 1.05,
    letterSpacing: -1.44,
    color: AppColors.textPrimary,
  );

  // h1 mobile — same weight/tracking, scaled down for 375px viewport
  static final TextStyle h1Mobile = GoogleFonts.spaceGrotesk(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    height: 1.1,
    letterSpacing: -0.8,
    color: AppColors.textPrimary,
  );

  // h2 — section heading: Space Grotesk 600, 2.5rem, lh 1.15, tracking -0.02em
  static final TextStyle h2 = GoogleFonts.spaceGrotesk(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    height: 1.15,
    letterSpacing: -0.8,
    color: AppColors.textPrimary,
  );

  static final TextStyle h2Mobile = GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.56,
    color: AppColors.textPrimary,
  );

  // h3 — project title: Space Grotesk 500, 1.5rem, lh 1.3
  static final TextStyle h3 = GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // body: Inter 400, 1.0625rem, lh 1.65 — max 65ch
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.65,
    color: AppColors.textPrimary,
  );

  // caption: Inter 500, 0.875rem, lh 1.5
  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  // link — medium-weight body; accent applied on hover via copyWith
  static final TextStyle link = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.65,
    color: AppColors.textPrimary,
  );

  // tag — tech tag label
  static final TextStyle tag = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // metric — e.g. "15K+ farmers"; textPrimary keeps WCAG AA contrast
  static final TextStyle metric = GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // caseSectionHeading — "The problem", "The approach", etc. within case studies
  static final TextStyle caseSectionHeading = GoogleFonts.spaceGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );
}
