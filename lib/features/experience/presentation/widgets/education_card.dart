import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../domain/entities/education_entry.dart';

/// Education entry rendered as the final item in the experience timeline.
///
/// Visually distinct from work entries: uses a 🎓 icon instead of the
/// standard timeline dot.
class EducationCard extends StatelessWidget {
  const EducationCard({
    super.key,
    required this.entry,
    required this.isMobile,
    required this.delay,
  });

  final EducationEntry entry;
  final bool isMobile;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      delay: delay,
      child: isMobile
          ? _MobileEducation(entry: entry)
          : _DesktopEducation(entry: entry),
    );
  }
}

// ─── Desktop ────────────────────────────────────────────────────────────────

class _DesktopEducation extends StatelessWidget {
  const _DesktopEducation({required this.entry});

  final EducationEntry entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date column — same width as experience cards
        SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.startYear, style: _dateStyle(context)),
                Text(
                  entry.endYear,
                  style: _dateStyle(context).copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Graduation cap icon (replaces dot)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: _GradIcon(),
        ),
        const SizedBox(width: 24),
        // Content
        Expanded(child: _EducationContent(entry: entry)),
      ],
    );
  }
}

// ─── Mobile ─────────────────────────────────────────────────────────────────

class _MobileEducation extends StatelessWidget {
  const _MobileEducation({required this.entry});

  final EducationEntry entry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${entry.startYear} — ${entry.endYear}',
              style: _dateStyle(context),
            ),
            const SizedBox(width: 8),
            _GradIcon(),
          ],
        ),
        const SizedBox(height: 12),
        _EducationContent(entry: entry),
      ],
    );
  }
}

// ─── Shared Content ─────────────────────────────────────────────────────────

class _EducationContent extends StatelessWidget {
  const _EducationContent({required this.entry});

  final EducationEntry entry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(entry.degree, style: AppTextStyles.h3),
        const SizedBox(height: 4),
        Text(
          '${entry.institution} · ${entry.location}',
          style: AppTextStyles.caption.copyWith(
            color: cs.onSurface.withValues(alpha: 0.55),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          entry.description,
          style: AppTextStyles.body.copyWith(
            fontSize: 15,
            color: cs.onSurface.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

// ─── Graduation Icon ────────────────────────────────────────────────────────

class _GradIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent.withValues(alpha: 0.12),
      ),
      child: const Center(
        child: Text('🎓', style: TextStyle(fontSize: 12)),
      ),
    );
  }
}

// ─── Shared Styles ──────────────────────────────────────────────────────────

TextStyle _dateStyle(BuildContext context) => GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
      letterSpacing: 0.2,
    );
