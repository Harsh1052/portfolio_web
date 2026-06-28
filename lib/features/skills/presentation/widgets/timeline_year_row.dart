import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../domain/entities/timeline_year.dart';
import 'skill_tag_with_tooltip.dart';

/// A single year row in the skills timeline.
///
/// Layout (desktop):
///   [year label] ──── [dot] ──────────── [skill tags wrap]
///
/// Layout (mobile):
///   [year label]
///   [skill tags wrap]
///
/// The row slides in via [FadeSlideIn] with a stagger [delay].
class TimelineYearRow extends StatelessWidget {
  const TimelineYearRow({
    super.key,
    required this.yearData,
    required this.isMobile,
    required this.delay,
    required this.isLast,
  });

  final TimelineYear yearData;
  final bool isMobile;
  final Duration delay;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      delay: delay,
      child: isMobile
          ? _MobileRow(yearData: yearData, isLast: isLast)
          : _DesktopRow(yearData: yearData, isLast: isLast),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Desktop layout
// ──────────────────────────────────────────────────────────────────────────────

class _DesktopRow extends StatelessWidget {
  const _DesktopRow({required this.yearData, required this.isLast});

  final TimelineYear yearData;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Year label — fixed width so all years align
          SizedBox(
            width: 52,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                yearData.year.toString(),
                style: _yearStyle(context),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Timeline spine + dot
          _TimelineSpine(isLast: isLast),
          const SizedBox(width: 24),
          // Skills wrap
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: _SkillsWrap(skills: yearData.skills),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Mobile layout
// ──────────────────────────────────────────────────────────────────────────────

class _MobileRow extends StatelessWidget {
  const _MobileRow({required this.yearData, required this.isLast});

  final TimelineYear yearData;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(yearData.year.toString(), style: _yearStyle(context)),
          const SizedBox(height: 12),
          _SkillsWrap(skills: yearData.skills),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Shared components
// ──────────────────────────────────────────────────────────────────────────────

/// Vertical line + circle dot forming the visual timeline spine.
class _TimelineSpine extends StatelessWidget {
  const _TimelineSpine({required this.isLast});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Circle dot at top
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
        ),
        // Vertical connecting line (hidden for last row)
        if (!isLast)
          Expanded(
            child: Container(
              width: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
      ],
    );
  }
}

/// Wrapping row of [SkillTagWithTooltip] tags.
class _SkillsWrap extends StatelessWidget {
  const _SkillsWrap({required this.skills});

  final List<dynamic> skills;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills
          .map((s) => SkillTagWithTooltip(skill: s))
          .toList(),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Shared text style — derived from context so it picks up theme color
// ──────────────────────────────────────────────────────────────────────────────

TextStyle _yearStyle(BuildContext context) => GoogleFonts.spaceGrotesk(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
      letterSpacing: 0.2,
    );
