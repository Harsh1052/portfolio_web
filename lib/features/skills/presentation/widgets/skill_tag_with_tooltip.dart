import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/skill_entry.dart';

/// A skill tag that shows a tooltip with recruiter context on hover.
///
/// On desktop: the tooltip appears above the tag on mouse hover.
/// On touch: the tooltip appears on long-press (Flutter default).
///
/// Design matches the existing [_TechTag] in project_card.dart but
/// extends it with an interactive tooltip layer.
class SkillTagWithTooltip extends StatefulWidget {
  const SkillTagWithTooltip({super.key, required this.skill});

  final SkillEntry skill;

  @override
  State<SkillTagWithTooltip> createState() => _SkillTagWithTooltipState();
}

class _SkillTagWithTooltipState extends State<SkillTagWithTooltip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.skill.tooltip,
      preferBelow: false,
      verticalOffset: 12,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTextStyles.caption.copyWith(
        color: AppColors.surface,
        fontWeight: FontWeight.w400,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.help,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.08)
                : Colors.transparent,
            border: Border.all(
              color: _hovered ? AppColors.accent : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.skill.label,
            style: AppTextStyles.tag.copyWith(
              color: _hovered ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
