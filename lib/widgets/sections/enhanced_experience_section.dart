import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/navigation_controller.dart';
import '../../models/experience.dart';
import '../../utils/design_constants.dart';

/// Enhanced Experience Section with timeline and expandable cards
class EnhancedExperienceSection extends StatefulWidget {
  final List<Experience> experiences;

  const EnhancedExperienceSection({
    super.key,
    required this.experiences,
  });

  @override
  State<EnhancedExperienceSection> createState() =>
      _EnhancedExperienceSectionState();
}

class _EnhancedExperienceSectionState extends State<EnhancedExperienceSection> {
  bool _isVisible = false;
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('enhanced-experience-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        key: navController.sectionKeys['experience'],
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              AppColors.accentPurple.withAlpha(((0.02) * 255).toInt()),
              AppColors.primaryBlue.withAlpha(((0.03) * 255).toInt()),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getContainerPadding(context),
          vertical: ResponsiveHelper.getSectionSpacing(context),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                _buildSectionTitle(context)
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: DesignConstants.spacing2XLarge),

                // Timeline
                if (isMobile)
                  _buildMobileTimeline(context)
                else
                  _buildDesktopTimeline(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Text(
            'Work Experience',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: DesignConstants.spacingSmall),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: DesignConstants.spacingMedium),
        Text(
          'My professional journey',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.7) * 255).toInt()),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDesktopTimeline(BuildContext context) {
    return Column(
      children: widget.experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final experience = entry.value;
        final isEven = index % 2 == 0;

        return _buildTimelineItem(
          context,
          experience,
          index,
          isEven,
          false,
        )
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(
              duration: 600.ms,
              delay: (200 + (index * 150)).ms,
            )
            .slideX(
              begin: isEven ? -0.3 : 0.3,
              end: 0,
            );
      }).toList(),
    );
  }

  Widget _buildMobileTimeline(BuildContext context) {
    return Column(
      children: widget.experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final experience = entry.value;

        return _buildTimelineItem(
          context,
          experience,
          index,
          true,
          true,
        )
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(
              duration: 600.ms,
              delay: (200 + (index * 150)).ms,
            )
            .slideY(begin: 0.3, end: 0);
      }).toList(),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    Experience experience,
    int index,
    bool alignLeft,
    bool isMobile,
  ) {
    final isExpanded = _expandedIndex == index;
    final isLast = index == widget.experiences.length - 1;

    return Padding(
      padding:
          EdgeInsets.only(bottom: isLast ? 0 : DesignConstants.spacing2XLarge),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          _buildTimelineLine(context, isLast, index),

          const SizedBox(width: DesignConstants.spacingLarge),

          // Content card
          Expanded(
            child: _buildExperienceCard(
              context,
              experience,
              index,
              isExpanded,
              isMobile,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineLine(BuildContext context, bool isLast, int index) {
    return Column(
      children: [
        // Animated dot
        AnimatedContainer(
          duration: DesignConstants.animationNormal,
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppShadows.primary,
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
              width: 4,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.work_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 2000.ms,
              delay: Duration(milliseconds: 200 * index),
            ),

        // Vertical line
        if (!isLast)
          Container(
            width: 2,
            height: 150,
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
          ).animate(target: _isVisible ? 1 : 0).scaleY(
                begin: 0,
                end: 1,
                duration: 800.ms,
                delay: (400 + (index * 150)).ms,
              ),
      ],
    );
  }

  Widget _buildExperienceCard(
    BuildContext context,
    Experience experience,
    int index,
    bool isExpanded,
    bool isMobile,
  ) {
    return AnimatedContainer(
      duration: DesignConstants.animationNormal,
      curve: DesignConstants.curveEmphasized,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusLarge),
        boxShadow: isExpanded ? AppShadows.xLarge : AppShadows.medium,
        border: Border.all(
          color: isExpanded
              ? AppColors.primaryBlue.withAlpha(((0.3) * 255).toInt())
              : Theme.of(context).colorScheme.outline.withAlpha(((0.1) * 255).toInt()),
          width: isExpanded ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _expandedIndex = isExpanded ? null : index;
            });
          },
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(DesignConstants.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company logo placeholder
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(
                          DesignConstants.borderRadiusMedium,
                        ),
                        boxShadow: AppShadows.small,
                      ),
                      child: Center(
                        child: Text(
                          experience.company.substring(0, 1).toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(width: DesignConstants.spacingMedium),

                    // Title and company
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            experience.position,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: DesignConstants.spacingXSmall),
                          Row(
                            children: [
                              const Icon(
                                Icons.business_rounded,
                                size: 18,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: DesignConstants.spacingXSmall),
                              Expanded(
                                child: Text(
                                  experience.company,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Expand icon
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: DesignConstants.animationNormal,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: DesignConstants.spacingMedium),

                // Date and location
                Wrap(
                  spacing: DesignConstants.spacingMedium,
                  runSpacing: DesignConstants.spacingSmall,
                  children: [
                    _buildInfoChip(
                      context,
                      Icons.calendar_today_rounded,
                      '${experience.startDate} - ${experience.endDate}',
                    ),
                    _buildInfoChip(
                      context,
                      Icons.location_on_rounded,
                      experience.location,
                    ),
                    if (experience.employmentType != null)
                      _buildInfoChip(
                        context,
                        Icons.work_outline_rounded,
                        experience.employmentType!,
                      ),
                  ],
                ),

                // Expandable content
                AnimatedSize(
                  duration: DesignConstants.animationNormal,
                  curve: DesignConstants.curveEmphasized,
                  child: isExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: DesignConstants.spacingLarge),

                            // Divider
                            Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withAlpha(((0.1) * 255).toInt()),
                                    Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withAlpha(((0.3) * 255).toInt()),
                                    Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withAlpha(((0.1) * 255).toInt()),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: DesignConstants.spacingLarge),

                            // Responsibilities
                            Text(
                              'Key Responsibilities',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),

                            const SizedBox(height: DesignConstants.spacingMedium),

                            ...experience.responsibilities.map((resp) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: DesignConstants.spacingSmall,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(
                                        width: DesignConstants.spacingSmall),
                                    Expanded(
                                      child: Text(
                                        resp,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(height: 1.6),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            // Technologies
                            if (experience.technologies != null &&
                                experience.technologies!.isNotEmpty) ...[
                              const SizedBox(height: DesignConstants.spacingLarge),
                              Text(
                                'Technologies Used',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: DesignConstants.spacingMedium),
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
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primaryBlue.withAlpha(((0.1) * 255).toInt()),
                                          AppColors.accentPurple.withAlpha(((0.1) * 255).toInt()),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        DesignConstants.borderRadiusSmall,
                                      ),
                                      border: Border.all(
                                        color: AppColors.primaryBlue
                                            .withAlpha(((0.2) * 255).toInt()),
                                      ),
                                    ),
                                    child: Text(
                                      tech,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryBlue,
                                          ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignConstants.spacingSmall,
        vertical: DesignConstants.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.6) * 255).toInt()),
          ),
          const SizedBox(width: DesignConstants.spacingXSmall),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
