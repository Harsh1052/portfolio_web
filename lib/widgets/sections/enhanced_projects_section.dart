import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/navigation_controller.dart';
import '../../models/project.dart';
import '../../utils/design_constants.dart';
import '../project_card.dart';

/// Enhanced Projects Section with filtering and grid layout
class EnhancedProjectsSection extends StatefulWidget {
  final List<Project> projects;

  const EnhancedProjectsSection({
    super.key,
    required this.projects,
  });

  @override
  State<EnhancedProjectsSection> createState() =>
      _EnhancedProjectsSectionState();
}

class _EnhancedProjectsSectionState extends State<EnhancedProjectsSection> {
  bool _isVisible = false;
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    _extractCategories();
  }

  void _extractCategories() {
    final categoriesSet = <String>{'All'};
    for (final project in widget.projects) {
      if (project.category != null) {
        categoriesSet.add(project.category!);
      }
    }
    _categories = categoriesSet.toList();
  }

  List<Project> get _filteredProjects {
    if (_selectedCategory == 'All') {
      return widget.projects;
    }
    return widget.projects
        .where((project) => project.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    int crossAxisCount = 1;
    if (!isMobile && !isTablet) {
      crossAxisCount = 3;
    } else if (isTablet) {
      crossAxisCount = 2;
    }

    return VisibilityDetector(
      key: const Key('enhanced-projects-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        key: navController.sectionKeys['projects'],
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.surface,
              AppColors.accentTeal.withAlpha(((0.02) * 255).toInt()),
              AppColors.successGreen.withAlpha(((0.03) * 255).toInt()),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getContainerPadding(context),
          vertical: ResponsiveHelper.getSectionSpacing(context),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              children: [
                // Section Title
                _buildSectionTitle(context)
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: DesignConstants.spacing2XLarge),

                // Category Filter Buttons
                _buildCategoryFilters(context)
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: DesignConstants.spacing2XLarge),

                // Projects Grid
                AnimatedSwitcher(
                  duration: DesignConstants.animationNormal,
                  switchInCurve: DesignConstants.curveEmphasized,
                  switchOutCurve: DesignConstants.curveEmphasized,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.95, end: 1.0)
                            .animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _buildProjectsGrid(
                    context,
                    crossAxisCount,
                    key: ValueKey(_selectedCategory),
                  ),
                ),
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
            'Featured Projects',
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
          'Showcasing my best work',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.7) * 255).toInt()),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCategoryFilters(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignConstants.spacingXSmall,
            ),
            child: AnimatedContainer(
              duration: DesignConstants.animationNormal,
              curve: DesignConstants.curveEmphasized,
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected
                    ? null
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius:
                    BorderRadius.circular(DesignConstants.borderRadiusFull),
                boxShadow: isSelected ? AppShadows.primary : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  borderRadius:
                      BorderRadius.circular(DesignConstants.borderRadiusFull),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignConstants.spacingLarge,
                      vertical: DesignConstants.spacingSmall,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          size: 18,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(width: DesignConstants.spacingXSmall),
                        Text(
                          category,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'all':
        return Icons.apps_rounded;
      case 'web':
        return Icons.web_rounded;
      case 'mobile':
        return Icons.phone_android_rounded;
      case 'ai':
      case 'ml':
      case 'machine learning':
        return Icons.psychology_rounded;
      case 'backend':
        return Icons.storage_rounded;
      case 'frontend':
        return Icons.palette_rounded;
      case 'fullstack':
      case 'full stack':
        return Icons.layers_rounded;
      case 'design':
        return Icons.design_services_rounded;
      case 'game':
        return Icons.sports_esports_rounded;
      default:
        return Icons.folder_rounded;
    }
  }

  Widget _buildProjectsGrid(
    BuildContext context,
    int crossAxisCount, {
    Key? key,
  }) {
    final filteredProjects = _filteredProjects;

    if (filteredProjects.isEmpty) {
      return SizedBox(
        key: key,
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(DesignConstants.spacingLarge),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlue.withAlpha(((0.1) * 255).toInt()),
                      AppColors.accentPurple.withAlpha(((0.1) * 255).toInt()),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.3) * 255).toInt()),
                ),
              ),
              const SizedBox(height: DesignConstants.spacingLarge),
              Text(
                'No projects found',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: DesignConstants.spacingSmall),
              Text(
                'Try selecting a different category',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(((0.6) * 255).toInt()),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      key: key,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: DesignConstants.spacingLarge,
        mainAxisSpacing: DesignConstants.spacingLarge,
        childAspectRatio: 1.2,
      ),
      itemCount: filteredProjects.length,
      itemBuilder: (context, index) {
        final project = filteredProjects[index];
        return ProjectCard(
          project: project,
          index: index,
          onTap: () => _showProjectDetails(context, project),
        )
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(
              duration: 600.ms,
              delay: (300 + (index * 100)).ms,
            )
            .slideY(begin: 0.3, end: 0);
      },
    );
  }

  void _showProjectDetails(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusLarge),
            boxShadow: AppShadows.xLarge,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Container(
                padding: const EdgeInsets.all(DesignConstants.spacingLarge),
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(DesignConstants.borderRadiusLarge),
                    topRight:
                        Radius.circular(DesignConstants.borderRadiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(DesignConstants.spacingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project image
                      if (project.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              DesignConstants.borderRadiusMedium),
                          child: Image.network(
                            project.imageUrl!,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),

                      const SizedBox(height: DesignConstants.spacingLarge),

                      // Description
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: DesignConstants.spacingSmall),
                      Text(
                        project.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                            ),
                      ),

                      const SizedBox(height: DesignConstants.spacingLarge),

                      // Technologies
                      Text(
                        'Technologies',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: DesignConstants.spacingSmall),
                      Wrap(
                        spacing: DesignConstants.spacingSmall,
                        runSpacing: DesignConstants.spacingSmall,
                        children: project.technologies.map((tech) {
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
                                  DesignConstants.borderRadiusSmall),
                              border: Border.all(
                                color: AppColors.primaryBlue.withAlpha(((0.2) * 255).toInt()),
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

                      const SizedBox(height: DesignConstants.spacingLarge),

                      // Action buttons
                      Row(
                        children: [
                          if (project.githubUrl != null)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Open GitHub URL
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: DesignConstants.spacingMedium,
                                  ),
                                ),
                                icon: const Icon(Icons.code_rounded),
                                label: const Text('View Code'),
                              ),
                            ),
                          if (project.githubUrl != null &&
                              project.liveUrl != null)
                            const SizedBox(width: DesignConstants.spacingMedium),
                          if (project.liveUrl != null)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Open live URL
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: DesignConstants.spacingMedium,
                                  ),
                                ),
                                icon: const Icon(Icons.open_in_new_rounded),
                                label: const Text('Live Demo'),
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
}
