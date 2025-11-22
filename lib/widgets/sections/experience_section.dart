import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/navigation_controller.dart';
import '../../models/experience.dart';
import '../../utils/design_constants.dart';

/// Experience Section - Timeline view of work experience
class ExperienceSection extends StatefulWidget {
  final List<Experience> experiences;

  const ExperienceSection({
    super.key,
    required this.experiences,
  });

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();

    return VisibilityDetector(
      key: const Key('experience-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        key: navController.sectionKeys['experience'],
        color: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getContainerPadding(context),
          vertical: ResponsiveHelper.getSectionSpacing(context),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                _buildSectionTitle(context, 'Work Experience')
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: DesignConstants.spacing2XLarge),
                ...widget.experiences.asMap().entries.map((entry) {
                  final index = entry.key;
                  final experience = entry.value;
                  return _buildTimelineItem(context, experience, index)
                      .animate(target: _isVisible ? 1 : 0)
                      .fadeIn(
                        duration: 600.ms,
                        delay: (200 + (index * 150)).ms,
                      )
                      .slideX(begin: index % 2 == 0 ? -0.3 : 0.3, end: 0);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    Experience experience,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignConstants.spacing2XLarge),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.primary,
                ),
                child: const Icon(
                  Icons.work,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              if (index < widget.experiences.length - 1)
                Container(
                  width: 2,
                  height: 120,
                  margin: const EdgeInsets.symmetric(
                    vertical: DesignConstants.spacingSmall,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryBlue,
                        AppColors.primaryBlue.withAlpha(((0.3) * 255).toInt()),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: DesignConstants.spacingLarge),

          // Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(DesignConstants.spacingLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    BorderRadius.circular(DesignConstants.borderRadiusLarge),
                boxShadow: AppShadows.medium,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withAlpha(((0.1) * 255).toInt()),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Company
                  Text(
                    experience.position,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: DesignConstants.spacingSmall),

                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: DesignConstants.spacingXSmall),
                      Expanded(
                        child: Text(
                          experience.company,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: DesignConstants.spacingSmall),

                  // Date and location
                  Wrap(
                    spacing: DesignConstants.spacingMedium,
                    runSpacing: DesignConstants.spacingSmall,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(((0.6) * 255).toInt()),
                          ),
                          const SizedBox(width: DesignConstants.spacingXSmall),
                          Text(
                            '${experience.startDate} - ${experience.endDate}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(((0.6) * 255).toInt()),
                          ),
                          const SizedBox(width: DesignConstants.spacingXSmall),
                          Text(
                            experience.location,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: DesignConstants.spacingMedium),

                  // Description
                  Text(
                    experience.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                  ),

                  if (experience.highlights.isNotEmpty) ...[
                    const SizedBox(height: DesignConstants.spacingMedium),

                    // Highlights
                    ...experience.highlights.map((highlight) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: DesignConstants.spacingSmall,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: DesignConstants.spacingSmall),
                            Expanded(
                              child: Text(
                                highlight,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  if (experience.technologies != null &&
                      experience.technologies!.isNotEmpty) ...[
                    const SizedBox(height: DesignConstants.spacingMedium),

                    // Technologies
                    Wrap(
                      spacing: DesignConstants.spacingSmall,
                      runSpacing: DesignConstants.spacingSmall,
                      children: experience.technologies!.map((tech) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignConstants.spacingSmall,
                            vertical: DesignConstants.spacingXSmall,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withAlpha(((0.3) * 255).toInt()),
                            borderRadius: BorderRadius.circular(
                              DesignConstants.borderRadiusSmall,
                            ),
                          ),
                          child: Text(
                            tech,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Text(
            title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: DesignConstants.spacingSmall),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
