import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../domain/repositories/skills_repository.dart';
import 'timeline_year_row.dart';

/// Skills timeline section — shows Harsh's skill growth year-by-year.
///
/// Each year row animates in on scroll via [FadeSlideIn] (delegated to
/// [TimelineYearRow]). Hovering a skill tag reveals a short tooltip
/// explaining where and how the skill was used in a real project.
///
/// Desktop: vertical timeline with a spine (dot + line) between year
///          label and the skill tags.
/// Mobile:  stacked year blocks with no spine.
///
/// Data is fetched via dependency injection from [SkillsRepository].
class SkillsTimelineSection extends StatelessWidget {
  const SkillsTimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve SkillsRepository via DI
    final years = Get.find<SkillsRepository>().getTimeline();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < Breakpoints.mobile;
        return ContentWrapper(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: AppColors.border,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 64),
                Semantics(
                  header: true,
                  child: Text('Skills', style: AppTextStyles.h2),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hover a tag to see where it was used.',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 48),
                for (int i = 0; i < years.length; i++)
                  TimelineYearRow(
                    yearData: years[i],
                    isMobile: isMobile,
                    delay: Duration(milliseconds: 60 + i * 80),
                    isLast: i == years.length - 1,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
