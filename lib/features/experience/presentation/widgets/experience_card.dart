import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../domain/entities/experience_entry.dart';

/// A single role card in the experience timeline.
///
/// Desktop: [date range] ── [dot+spine] ── [card content]
/// Mobile:  stacked vertically (no spine)
///
/// Shows top 3 responsibilities with an expandable "Show more" toggle.
class ExperienceCard extends StatelessWidget {
  const ExperienceCard({
    super.key,
    required this.entry,
    required this.isMobile,
    required this.delay,
    required this.isLast,
  });

  final ExperienceEntry entry;
  final bool isMobile;
  final Duration delay;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      delay: delay,
      child: isMobile
          ? _MobileCard(entry: entry, isLast: isLast)
          : _DesktopCard(entry: entry, isLast: isLast),
    );
  }
}

// ─── Desktop Layout ─────────────────────────────────────────────────────────

class _DesktopCard extends StatelessWidget {
  const _DesktopCard({required this.entry, required this.isLast});

  final ExperienceEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date range column — fixed width
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.startDate,
                    style: _dateStyle(context),
                  ),
                  Text(
                    entry.endDate,
                    style: _dateStyle(context).copyWith(
                      color: entry.isCurrent
                          ? AppColors.accent
                          : Theme.of(context)
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
          // Timeline spine
          _TimelineSpine(isLast: isLast, isCurrent: entry.isCurrent),
          const SizedBox(width: 24),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: _CardContent(entry: entry),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mobile Layout ──────────────────────────────────────────────────────────

class _MobileCard extends StatelessWidget {
  const _MobileCard({required this.entry, required this.isLast});

  final ExperienceEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${entry.startDate} — ${entry.endDate}',
                style: _dateStyle(context).copyWith(
                  color: entry.isCurrent
                      ? AppColors.accent
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.55),
                ),
              ),
              if (entry.isCurrent) ...[
                const SizedBox(width: 8),
                _CurrentBadge(),
              ],
            ],
          ),
          const SizedBox(height: 12),
          _CardContent(entry: entry),
        ],
      ),
    );
  }
}

// ─── Card Content (shared) ──────────────────────────────────────────────────

class _CardContent extends StatelessWidget {
  const _CardContent({required this.entry});

  final ExperienceEntry entry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Position title
        Row(
          children: [
            Expanded(
              child: Text(entry.position, style: AppTextStyles.h3),
            ),
            if (entry.isCurrent) _CurrentBadge(),
          ],
        ),
        const SizedBox(height: 4),
        // Company + Location
        Text(
          '${entry.company} · ${entry.location}',
          style: AppTextStyles.caption.copyWith(
            color: cs.onSurface.withValues(alpha: 0.55),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        // Responsibilities
        _ResponsibilitiesList(items: entry.responsibilities),
        // Tech tags
        if (entry.technologies.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: entry.technologies
                .map((t) => _TechChip(label: t))
                .toList(),
          ),
        ],
      ],
    );
  }
}

// ─── Responsibilities (expandable) ──────────────────────────────────────────

class _ResponsibilitiesList extends StatefulWidget {
  const _ResponsibilitiesList({required this.items});

  final List<String> items;

  @override
  State<_ResponsibilitiesList> createState() => _ResponsibilitiesListState();
}

class _ResponsibilitiesListState extends State<_ResponsibilitiesList> {
  bool _expanded = false;

  static const int _initialCount = 3;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final canExpand = widget.items.length > _initialCount;
    final visible = _expanded
        ? widget.items
        : widget.items.take(_initialCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in visible)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 15,
                      color: cs.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (canExpand)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'Show less ↑' : 'Show more ↓',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Timeline Spine ─────────────────────────────────────────────────────────

class _TimelineSpine extends StatelessWidget {
  const _TimelineSpine({required this.isLast, required this.isCurrent});

  final bool isLast;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 7),
          decoration: BoxDecoration(
            color: isCurrent ? AppColors.accent : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accent,
              width: 2,
            ),
          ),
        ),
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

// ─── Current Badge ──────────────────────────────────────────────────────────

class _CurrentBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Current',
        style: AppTextStyles.tag.copyWith(
          color: AppColors.accent,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Tech Chip ──────────────────────────────────────────────────────────────

class _TechChip extends StatelessWidget {
  const _TechChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: AppTextStyles.tag),
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
