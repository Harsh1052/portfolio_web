import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/navigation_controller.dart';
import '../../models/skill.dart';
import '../../utils/design_constants.dart';

/// Enhanced Skills Section with a professional, clean UI
class EnhancedSkillsSection extends StatefulWidget {
  final List<SkillCategory> skills;

  const EnhancedSkillsSection({
    super.key,
    required this.skills,
  });

  @override
  State<EnhancedSkillsSection> createState() => _EnhancedSkillsSectionState();
}

class _EnhancedSkillsSectionState extends State<EnhancedSkillsSection> {
  bool _isVisible = false;
  String _selectedCategory = 'All';

  List<String> get _categories {
    return [
      'All',
      ...widget.skills.map((cat) => cat.name).toSet(),
    ];
  }

  List<SkillCategory> get _filteredSkills {
    if (_selectedCategory == 'All') {
      return widget.skills;
    }
    return widget.skills.where((cat) => cat.name == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('enhanced-skills-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        key: navController.sectionKeys['skills'],
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          // Add a subtle background pattern or gradient if desired here
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
                // Section title
                _buildSectionTitle(context)
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: DesignConstants.spacingLarge),

                // Category filters
                _buildCategoryFilters(context)
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: DesignConstants.spacing2XLarge),

                // Skills grid
                ...(_filteredSkills.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: DesignConstants.spacing2XLarge,
                    ),
                    child: _buildCategorySection(
                            context, category, index, isMobile)
                        .animate(target: _isVisible ? 1 : 0)
                        .fadeIn(
                          duration: 600.ms,
                          delay: (400 + (index * 150)).ms,
                        )
                        .slideY(begin: 0.3, end: 0),
                  );
                }).toList()),
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
        Text(
          'Technical Expertise',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: DesignConstants.spacingSmall),
        Text(
          'A curated list of technologies I use to build scalable solutions.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(((0.6) * 255).toInt()),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCategoryFilters(BuildContext context) {
    return Wrap(
      spacing: DesignConstants.spacingSmall,
      runSpacing: DesignConstants.spacingSmall,
      alignment: WrapAlignment.center,
      children: _categories.map((category) {
        final isSelected = category == _selectedCategory;
        return InkWell(
          onTap: () {
            setState(() => _selectedCategory = category);
          },
          borderRadius: BorderRadius.circular(DesignConstants.borderRadiusFull),
          child: AnimatedContainer(
            duration: DesignConstants.animationFast,
            padding: const EdgeInsets.symmetric(
              horizontal: DesignConstants.spacingMedium,
              vertical: DesignConstants.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusFull),
              boxShadow: isSelected ? AppShadows.small : null,
            ),
            child: Text(
              category,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    SkillCategory category,
    int categoryIndex,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        Padding(
          padding: const EdgeInsets.only(bottom: DesignConstants.spacingMedium),
          child: Row(
            children: [
              Icon(
                _getIconForCategory(category.name),
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: DesignConstants.spacingSmall),
              Text(
                category.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),

        // Skills Grid
        LayoutBuilder(
          builder: (context, constraints) {
            // Adaptive column count for glass cards
            final crossAxisCount =
                isMobile ? 2 : (constraints.maxWidth > 900 ? 5 : 4);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.2, // Square-ish cards
                crossAxisSpacing: DesignConstants.spacingMedium,
                mainAxisSpacing: DesignConstants.spacingMedium,
              ),
              itemCount: category.skills.length,
              itemBuilder: (context, index) {
                final skill = category.skills[index];
                return _buildGlassSkillCard(context, skill);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildGlassSkillCard(BuildContext context, Skill skill) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: HoverBuilder(
        builder: (context, isHovered) {
          // Determine colors based on theme
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final glassColor =
              isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5);
          final borderColor = isHovered
              ? Theme.of(context).colorScheme.primary.withAlpha(150)
              : Theme.of(context).colorScheme.outline.withAlpha(50);

          return ClipRRect(
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusMedium),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AnimatedContainer(
                duration: DesignConstants.animationFast,
                transform: Matrix4.identity()
                  ..translate(0, isHovered ? -4.0 : 0.0), // Use double literals
                decoration: BoxDecoration(
                  color: glassColor,
                  borderRadius:
                      BorderRadius.circular(DesignConstants.borderRadiusMedium),
                  border: Border.all(
                    color: borderColor,
                    width: isHovered ? 1.5 : 1,
                  ),
                  boxShadow: isHovered ? AppShadows.primary : [],
                  gradient: isHovered
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            glassColor,
                            Theme.of(context).colorScheme.primary.withAlpha(20),
                          ],
                        )
                      : null,
                ),
                padding: const EdgeInsets.all(DesignConstants.spacingMedium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon logic (if available) or just first letter styled nicely
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        skill.icon != null
                            ? Icons.code
                            : _getIconForCategory(skill.category),
                        // Fallback to category icon if skill icon missing
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      skill.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryContainer
                            .withAlpha(100),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        skill.level,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    final categoryLower = category.toLowerCase();
    if (categoryLower.contains('core') || categoryLower.contains('mobile')) {
      return Icons.smartphone;
    }
    if (categoryLower.contains('architecture') ||
        categoryLower.contains('state')) {
      return Icons.layers;
    }
    if (categoryLower.contains('backend') || categoryLower.contains('cloud')) {
      return Icons.cloud;
    }
    if (categoryLower.contains('testing') || categoryLower.contains('tools')) {
      return Icons.build;
    }
    if (categoryLower.contains('design')) {
      return Icons.palette;
    }
    return Icons.code;
  }
}

/// Helper widget to handle hover state
class HoverBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool isHovered) builder;

  const HoverBuilder({super.key, required this.builder});

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: widget.builder(context, _isHovered),
    );
  }
}
