import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../domain/repositories/experience_repository.dart';
import 'experience_card.dart';
import 'education_card.dart';

/// Experience & Education section — vertical career timeline.
///
/// Shows work history (newest → oldest) followed by education.
/// Desktop uses a vertical spine (dot + line) between date labels
/// and content cards. Mobile stacks everything vertically.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Get.find<ExperienceRepository>();
    final experience = repo.getExperience();
    final education = repo.getEducation();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < Breakpoints.mobile;
        return ContentWrapper(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Theme.of(context).dividerColor,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 64),
                Semantics(
                  header: true,
                  child: Text('Experience', style: AppTextStyles.h2),
                ),
                const SizedBox(height: 48),
                // ── Work Experience ──
                for (int i = 0; i < experience.length; i++)
                  ExperienceCard(
                    entry: experience[i],
                    isMobile: isMobile,
                    delay: Duration(milliseconds: 60 + i * 100),
                    isLast: i == experience.length - 1 && education.isEmpty,
                  ),
                // ── Education ──
                if (education.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  for (int i = 0; i < education.length; i++)
                    EducationCard(
                      entry: education[i],
                      isMobile: isMobile,
                      delay: Duration(
                        milliseconds:
                            60 + (experience.length + i) * 100,
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
