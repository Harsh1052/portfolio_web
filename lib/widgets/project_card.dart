import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/project.dart';
import '../utils/design_constants.dart';

/// Interactive Project Card with hover effects and animations
class ProjectCard extends StatefulWidget {
  final Project project;
  final int index;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.index,
    required this.onTap,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DesignConstants.animationNormal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: DesignConstants.curveEmphasized,
    ));

    _elevationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: DesignConstants.curveEmphasized,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(DesignConstants.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(
                        10 + (0.2 * _elevationAnimation.value).toInt()),
                    blurRadius: 20 + (20 * _elevationAnimation.value),
                    offset: Offset(0, 5 + (10 * _elevationAnimation.value)),
                  ),
                  if (widget.project.isFeatured)
                    BoxShadow(
                      color: AppColors.primaryBlue
                          .withAlpha((30 * _elevationAnimation.value).toInt()),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(DesignConstants.borderRadiusLarge),
                child: Stack(
                  children: [
                    // Background image or gradient
                    _buildBackground(context),

                    // Glassmorphism overlay
                    _buildGlassmorphismOverlay(),

                    // Content
                    _buildContent(context, isMobile),

                    // Hover overlay with buttons
                    _buildHoverOverlay(context),

                    // Featured badge
                    if (widget.project.isFeatured) _buildFeaturedBadge(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    if (widget.project.imageUrl != null) {
      return Positioned.fill(
        child: Image.network(
          widget.project.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildGradientBackground(),
        ),
      );
    }
    return _buildGradientBackground();
  }

  Widget _buildGradientBackground() {
    final gradients = [
      AppColors.primaryGradient,
      AppColors.secondaryGradient,
      AppColors.accentGradient,
      const LinearGradient(
        colors: [AppColors.successGreen, AppColors.accentTeal],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: gradients[widget.index % gradients.length],
        ),
        child: Center(
          child: Icon(
            Icons.web,
            size: 100,
            color: Colors.white.withAlpha(20),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphismOverlay() {
    return AnimatedPositioned(
      duration: DesignConstants.animationNormal,
      curve: DesignConstants.curveEmphasized,
      bottom: _isHovered ? 0 : -100,
      left: 0,
      right: 0,
      height: 250,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withAlpha(70),
              Colors.black.withAlpha(90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isMobile) {
    return Positioned(
      left: DesignConstants.spacingMedium,
      right: DesignConstants.spacingMedium,
      bottom: DesignConstants.spacingMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            widget.project.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 10,
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: DesignConstants.spacingSmall),

          // Description
          AnimatedOpacity(
            opacity: _isHovered ? 1.0 : 0.0,
            duration: DesignConstants.animationNormal,
            child: Text(
              widget.project.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(90),
                    height: 1.5,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: DesignConstants.spacingMedium),

          // Tech stack badges
          _buildTechStack(context),
        ],
      ),
    );
  }

  Widget _buildTechStack(BuildContext context) {
    return AnimatedContainer(
      duration: DesignConstants.animationNormal,
      curve: DesignConstants.curveEmphasized,
      height: _isHovered ? null : 32,
      child: Wrap(
        spacing: DesignConstants.spacingXSmall,
        runSpacing: DesignConstants.spacingXSmall,
        children: widget.project.technologies.take(_isHovered ? 10 : 3).map(
          (tech) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignConstants.spacingSmall,
                vertical: DesignConstants.spacingXSmall,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius:
                    BorderRadius.circular(DesignConstants.borderRadiusSmall),
                border: Border.all(
                  color: Colors.white.withAlpha(30),
                  width: 1,
                ),
              ),
              child: Text(
                tech,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _buildHoverOverlay(BuildContext context) {
    return AnimatedPositioned(
      duration: DesignConstants.animationNormal,
      curve: DesignConstants.curveEmphasized,
      top: _isHovered ? DesignConstants.spacingMedium : -100,
      right: DesignConstants.spacingMedium,
      child: AnimatedOpacity(
        opacity: _isHovered ? 1.0 : 0.0,
        duration: DesignConstants.animationNormal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.project.githubUrl != null)
              _buildActionButton(
                context,
                icon: Icons.code_rounded,
                label: 'Code',
                onPressed: () {
                  // TODO: Open GitHub URL
                },
              ),
            if (widget.project.githubUrl != null &&
                widget.project.liveUrl != null)
              const SizedBox(width: DesignConstants.spacingSmall),
            if (widget.project.liveUrl != null)
              _buildActionButton(
                context,
                icon: Icons.open_in_new_rounded,
                label: 'Demo',
                onPressed: () {
                  // TODO: Open live URL
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMedium),
        boxShadow: AppShadows.primary,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignConstants.spacingMedium,
              vertical: DesignConstants.spacingSmall,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: DesignConstants.spacingXSmall),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedBadge(BuildContext context) {
    return Positioned(
      top: DesignConstants.spacingMedium,
      left: DesignConstants.spacingMedium,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignConstants.spacingSmall,
          vertical: DesignConstants.spacingXSmall,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.amber, Colors.orange],
          ),
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusSmall),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withAlpha(50),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.white, size: 14),
            const SizedBox(width: DesignConstants.spacingXSmall),
            Text(
              'Featured',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ).animate(onPlay: (controller) => controller.repeat()).shimmer(
            duration: 2000.ms,
            color: Colors.white.withAlpha(30),
          ),
    );
  }
}
