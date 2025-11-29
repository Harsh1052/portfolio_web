import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/navigation_controller.dart';
import '../../models/skill.dart';
import '../../utils/design_constants.dart';

/// Skills Section - Animated skill cards organized by category
class SkillsSection extends StatefulWidget {
  final List<SkillCategory> skills;

  const SkillsSection({
    super.key,
    required this.skills,
  });

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();

    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        key: navController.sectionKeys['skills'],
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withAlpha(((0.3) * 255).toInt()),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getContainerPadding(context),
          vertical: ResponsiveHelper.getSectionSpacing(context),
        ),
        child: Center(
          child: Container(
            constraints:
                const BoxConstraints(maxWidth: DesignConstants.maxContentWidth),
            child: Column(
              children: [
                _buildSectionTitle(context, 'Skills & Technologies')
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: DesignConstants.spacing2XLarge),
                ...widget.skills.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: DesignConstants.spacing2XLarge,
                    ),
                    child: _buildSkillCategory(context, category, index)
                        .animate(target: _isVisible ? 1 : 0)
                        .fadeIn(
                          duration: 600.ms,
                          delay: (200 + (index * 100)).ms,
                        )
                        .slideY(begin: 0.3, end: 0),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillCategory(
    BuildContext context,
    SkillCategory category,
    int categoryIndex,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignConstants.spacingSmall),
              decoration: BoxDecoration(
                gradient: _getGradientForCategory(categoryIndex),
                borderRadius:
                    BorderRadius.circular(DesignConstants.borderRadiusSmall),
              ),
              child: Icon(
                _getIconForCategory(category.name),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: DesignConstants.spacingMedium),
            Text(
              category.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),

        const SizedBox(height: DesignConstants.spacingLarge),

        // Skills grid
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                isMobile ? 2 : (constraints.maxWidth > 800 ? 4 : 3);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.85,
                crossAxisSpacing: DesignConstants.spacingMedium,
                mainAxisSpacing: DesignConstants.spacingMedium,
              ),
              itemCount: category.skills.length,
              itemBuilder: (context, index) {
                final skill = category.skills[index];
                return _buildSkillCard(context, skill, categoryIndex);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSkillCard(BuildContext context, Skill skill, int categoryIndex) {
    final proficiency =
        skill.proficiency ?? (_getLevelValue(skill.level) * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusLarge),
        boxShadow: AppShadows.medium,
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outline
              .withAlpha(((0.1) * 255).toInt()),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(DesignConstants.spacingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon container at top
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getColorForLevel(skill.level)
                            .withAlpha(((0.2) * 255).toInt()),
                        _getColorForLevel(skill.level)
                            .withAlpha(((0.1) * 255).toInt()),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(
                        DesignConstants.borderRadiusMedium),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.code,
                      color: _getColorForLevel(skill.level),
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(height: DesignConstants.spacingMedium),

                // Skill name - larger and more prominent
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        skill.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: DesignConstants.spacingXSmall),
                      // Level badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignConstants.spacingSmall,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getColorForLevel(skill.level)
                              .withAlpha(((0.15) * 255).toInt()),
                          borderRadius: BorderRadius.circular(
                            DesignConstants.borderRadiusSmall,
                          ),
                        ),
                        child: Text(
                          skill.level,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _getColorForLevel(skill.level),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: DesignConstants.spacingMedium),

                // Horizontal progress bar at bottom
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Proficiency',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(((0.6) * 255).toInt()),
                                    fontSize: 11,
                                  ),
                        ),
                        Text(
                          '$proficiency%',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _getColorForLevel(skill.level),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          DesignConstants.borderRadiusFull),
                      child: LinearProgressIndicator(
                        value: proficiency / 100,
                        minHeight: 6,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .outline
                            .withAlpha(((0.2) * 255).toInt()),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getColorForLevel(skill.level),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

  IconData _getIconForCategory(String category) {
    final categoryLower = category.toLowerCase();
    if (categoryLower.contains('language')) return Icons.code;
    if (categoryLower.contains('framework')) return Icons.dashboard;
    if (categoryLower.contains('tool')) return Icons.build;
    if (categoryLower.contains('database')) return Icons.storage;
    if (categoryLower.contains('cloud')) return Icons.cloud;
    return Icons.star;
  }

  Gradient _getGradientForCategory(int index) {
    final gradients = [
      AppColors.primaryGradient,
      AppColors.secondaryGradient,
      AppColors.accentGradient,
    ];
    return gradients[index % gradients.length];
  }

  double _getLevelValue(String level) {
    switch (level.toLowerCase()) {
      case 'expert':
        return 1.0;
      case 'advanced':
        return 0.8;
      case 'intermediate':
        return 0.6;
      case 'beginner':
        return 0.4;
      default:
        return 0.5;
    }
  }

  Color _getColorForLevel(String level) {
    switch (level.toLowerCase()) {
      case 'expert':
        return AppColors.successGreen;
      case 'advanced':
        return AppColors.primaryBlue;
      case 'intermediate':
        return AppColors.accentPurple;
      case 'beginner':
        return AppColors.accentTeal;
      default:
        return AppColors.primaryBlue;
    }
  }
}
