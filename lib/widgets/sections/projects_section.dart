import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/navigation_controller.dart';
import '../../models/project.dart';
import '../../utils/design_constants.dart';

/// Projects Section - Grid layout of portfolio projects
class ProjectsSection extends StatefulWidget {
  final List<Project> projects;

  const ProjectsSection({
    super.key,
    required this.projects,
  });

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('projects-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        key: navController.sectionKeys['projects'],
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(((0.3) * 255).toInt()),
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
                _buildSectionTitle(context, 'Featured Projects')
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: DesignConstants.spacing2XLarge),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount =
                        isMobile ? 1 : (constraints.maxWidth > 900 ? 3 : 2);

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: DesignConstants.spacingLarge,
                        mainAxisSpacing: DesignConstants.spacingLarge,
                      ),
                      itemCount: widget.projects.length,
                      itemBuilder: (context, index) {
                        return _buildProjectCard(
                                context, widget.projects[index], index)
                            .animate(target: _isVisible ? 1 : 0)
                            .fadeIn(
                              duration: 600.ms,
                              delay: (200 + (index * 100)).ms,
                            )
                            .scale(begin: const Offset(0.8, 0.8));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusLarge),
        boxShadow: AppShadows.medium,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(((0.1) * 255).toInt()),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project image/placeholder
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: _getGradientForIndex(index),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(DesignConstants.borderRadiusLarge),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.code,
                        size: 64,
                        color: Colors.white.withAlpha(((0.3) * 255).toInt()),
                      ),
                    ),
                    // Featured badge
                    if (project.isFeatured)
                      Positioned(
                        top: DesignConstants.spacingMedium,
                        right: DesignConstants.spacingMedium,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignConstants.spacingSmall,
                            vertical: DesignConstants.spacingXSmall,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              DesignConstants.borderRadiusSmall,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  size: 14, color: Colors.amber),
                              const SizedBox(width: DesignConstants.spacingXSmall),
                              Text(
                                'Featured',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(DesignConstants.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        project.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: DesignConstants.spacingSmall),

                      // Description
                      Expanded(
                        child: Text(
                          project.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    height: 1.5,
                                  ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: DesignConstants.spacingMedium),

                      // Technologies
                      Wrap(
                        spacing: DesignConstants.spacingXSmall,
                        runSpacing: DesignConstants.spacingXSmall,
                        children: project.technologies.take(3).map((tech) {
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: DesignConstants.spacingMedium),

                      // Links
                      Row(
                        children: [
                          if (project.githubUrl != null)
                            Expanded(
                              child: _buildIconButton(
                                context,
                                Icons.code,
                                'Code',
                                () {},
                              ),
                            ),
                          if (project.githubUrl != null &&
                              project.liveUrl != null)
                            const SizedBox(width: DesignConstants.spacingSmall),
                          if (project.liveUrl != null)
                            Expanded(
                              child: _buildIconButton(
                                context,
                                Icons.open_in_new,
                                'Demo',
                                () {},
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignConstants.spacingSmall,
          vertical: DesignConstants.spacingSmall,
        ),
        textStyle: Theme.of(context).textTheme.bodySmall,
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

  Gradient _getGradientForIndex(int index) {
    final gradients = [
      AppColors.primaryGradient,
      AppColors.secondaryGradient,
      AppColors.accentGradient,
    ];
    return gradients[index % gradients.length];
  }
}
