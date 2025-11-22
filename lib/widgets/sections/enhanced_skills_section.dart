import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/navigation_controller.dart';
import '../../models/skill.dart';
import '../../utils/design_constants.dart';

/// Enhanced Skills Section with filters and impressive animations
class EnhancedSkillsSection extends StatefulWidget {
  final List<SkillCategory> skills;

  const EnhancedSkillsSection({
    super.key,
    required this.skills,
  });

  @override
  State<EnhancedSkillsSection> createState() => _EnhancedSkillsSectionState();
}

class _EnhancedSkillsSectionState extends State<EnhancedSkillsSection>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  String _selectedCategory = 'All';
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              AppColors.primaryBlue.withAlpha(((0.02) * 255).toInt()),
              AppColors.accentPurple.withAlpha(((0.03) * 255).toInt()),
            ],
          ),
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
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Text(
            'Skills & Expertise',
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
          'Technologies and tools I work with',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.7) * 255).toInt()),
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
        return AnimatedContainer(
          duration: DesignConstants.animationFast,
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
                setState(() => _selectedCategory = category);
              },
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusFull),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignConstants.spacingLarge,
                  vertical: DesignConstants.spacingSmall,
                ),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                ),
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
        // Category header with icon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignConstants.spacingMedium),
              decoration: BoxDecoration(
                gradient: _getGradientForCategory(categoryIndex),
                borderRadius:
                    BorderRadius.circular(DesignConstants.borderRadiusMedium),
                boxShadow: AppShadows.primary,
              ),
              child: Icon(
                _getIconForCategory(category.name),
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: DesignConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${category.skills.length} skills',
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
          ],
        ),

        const SizedBox(height: DesignConstants.spacingLarge),

        // Skills grid
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                isMobile ? 2 : (constraints.maxWidth > 900 ? 4 : 3);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.0,
                crossAxisSpacing: DesignConstants.spacingMedium,
                mainAxisSpacing: DesignConstants.spacingMedium,
              ),
              itemCount: category.skills.length,
              itemBuilder: (context, index) {
                final skill = category.skills[index];
                return _buildSkillCard(
                  context,
                  skill,
                  categoryIndex,
                  index,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSkillCard(
    BuildContext context,
    Skill skill,
    int categoryIndex,
    int skillIndex,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusLarge),
              boxShadow: [
                ...AppShadows.medium,
                BoxShadow(
                  color: _getColorForCategory(categoryIndex)
                      .withAlpha(((0.1 * _glowController.value) * 255).toInt()),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
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
                child: Padding(
                  padding: const EdgeInsets.all(DesignConstants.spacingMedium),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Circular progress indicator
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CustomPaint(
                              painter: CircularProgressPainter(
                                progress: (skill.proficiency ?? 50) / 100,
                                color: _getColorForCategory(categoryIndex),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withAlpha(((0.2) * 255).toInt()),
                              ),
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  _getColorForCategory(categoryIndex)
                                      .withAlpha(((0.2) * 255).toInt()),
                                  _getColorForCategory(categoryIndex)
                                      .withAlpha(((0.1) * 255).toInt()),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${skill.proficiency ?? 50}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          _getColorForCategory(categoryIndex),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: DesignConstants.spacingMedium),

                      // Skill name
                      Text(
                        skill.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: DesignConstants.spacingXSmall),

                      // Level badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignConstants.spacingSmall,
                          vertical: DesignConstants.spacingXSmall,
                        ),
                        decoration: BoxDecoration(
                          color: _getColorForCategory(categoryIndex)
                              .withAlpha(((0.1) * 255).toInt()),
                          borderRadius: BorderRadius.circular(
                            DesignConstants.borderRadiusSmall,
                          ),
                        ),
                        child: Text(
                          skill.level,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _getColorForCategory(categoryIndex),
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.02, 1.02),
          duration: 2000.ms,
          delay: Duration(milliseconds: 100 * skillIndex),
        );
  }

  IconData _getIconForCategory(String category) {
    final categoryLower = category.toLowerCase();
    if (categoryLower.contains('frontend') ||
        categoryLower.contains('web') ||
        categoryLower.contains('ui')) {
      return Icons.web;
    }
    if (categoryLower.contains('backend') || categoryLower.contains('server')) {
      return Icons.dns;
    }
    if (categoryLower.contains('mobile') || categoryLower.contains('app')) {
      return Icons.phone_android;
    }
    if (categoryLower.contains('database') || categoryLower.contains('data')) {
      return Icons.storage;
    }
    if (categoryLower.contains('tool') || categoryLower.contains('devops')) {
      return Icons.build_circle;
    }
    if (categoryLower.contains('design')) {
      return Icons.palette;
    }
    if (categoryLower.contains('language')) {
      return Icons.code;
    }
    return Icons.star;
  }

  Gradient _getGradientForCategory(int index) {
    final gradients = [
      AppColors.primaryGradient,
      AppColors.secondaryGradient,
      AppColors.accentGradient,
      const LinearGradient(
        colors: [AppColors.successGreen, AppColors.accentTeal],
      ),
    ];
    return gradients[index % gradients.length];
  }

  Color _getColorForCategory(int index) {
    final colors = [
      AppColors.primaryBlue,
      AppColors.accentPurple,
      AppColors.accentTeal,
      AppColors.successGreen,
    ];
    return colors[index % colors.length];
  }
}

/// Custom painter for circular progress indicator
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [color, color.withAlpha(((0.6) * 255).toInt())],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
