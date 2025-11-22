import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../controllers/navigation_controller.dart';
import '../../models/personal_info.dart';
import '../../utils/design_constants.dart';
import '../animated_background.dart';
import '../animations/parallax_effect.dart';

/// Enhanced Hero Section with impressive animations and effects
class EnhancedHeroSection extends StatefulWidget {
  final PersonalInfo personalInfo;

  const EnhancedHeroSection({
    super.key,
    required this.personalInfo,
  });

  @override
  State<EnhancedHeroSection> createState() => _EnhancedHeroSectionState();
}

class _EnhancedHeroSectionState extends State<EnhancedHeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final navController = Get.find<NavigationController>();
    final isDesktop = !isMobile && !isTablet;

    // Listen to scroll for parallax effect
    navController.scrollController.addListener(() {
      if (mounted) {
        setState(() {
          _scrollOffset = navController.scrollController.offset;
        });
      }
    });

    return MouseFollowerGradient(
      enabled: isDesktop,
      gradientColors: [
        AppColors.primaryBlue.withAlpha(((0.15) * 255).toInt()),
        AppColors.accentPurple.withAlpha(((0.12) * 255).toInt()),
        Colors.transparent,
      ],
      radius: 400,
      opacity: 0.4,
      child: AnimatedBackground(
        child: Container(
          key: navController.sectionKeys['home'],
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 80,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                  maxWidth: DesignConstants.maxContentWidth),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getContainerPadding(context),
                vertical: ResponsiveHelper.getSectionSpacing(context),
              ),
              child: isMobile || isTablet
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side - Text content
        Expanded(
          flex: 6,
          child: _buildTextContent(context, false),
        ),

        const SizedBox(width: DesignConstants.spacing3XLarge),

        // Right side - Avatar
        Expanded(
          flex: 4,
          child: _buildAvatar(context, false),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar first on mobile
        _buildAvatar(context, true),

        const SizedBox(height: DesignConstants.spacing2XLarge),

        // Text content
        _buildTextContent(context, true),
      ],
    );
  }

  Widget _buildTextContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Greeting with parallax
        Transform.translate(
          offset: Offset(0, -_scrollOffset * 0.1),
          child: Text(
            '👋 Hello, I\'m',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.3, end: 0),
        ),

        const SizedBox(height: DesignConstants.spacingMedium),

        // Name with gradient and parallax
        Transform.translate(
          offset: Offset(0, -_scrollOffset * 0.15),
          child: ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.heroGradient.createShader(bounds),
            child: Text(
              widget.personalInfo.name,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontSize: isMobile ? 40 : 72,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 400.ms)
              .slideY(begin: 0.3, end: 0)
              .then()
              .shimmer(
                duration: 2000.ms,
                color: Colors.white.withAlpha(((0.3) * 255).toInt()),
              ),
        ),

        const SizedBox(height: DesignConstants.spacingLarge),

        // Animated typewriter text with parallax
        Transform.translate(
          offset: Offset(0, -_scrollOffset * 0.2),
          child: Container(
            height: isMobile ? 80 : 100,
            alignment: isMobile ? Alignment.center : Alignment.centerLeft,
            child: Row(
              mainAxisAlignment:
                  isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'I\'m a ',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: isMobile ? 22 : 32,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Flexible(
                  child: AnimatedTextKit(
                    repeatForever: true,
                    pause: const Duration(milliseconds: 2000),
                    animatedTexts: [
                      TypewriterAnimatedText(
                        widget.personalInfo.title,
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: isMobile ? 22 : 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                        speed: const Duration(milliseconds: 100),
                      ),
                      TypewriterAnimatedText(
                        'Problem Solver',
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: isMobile ? 22 : 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentPurple,
                            ),
                        speed: const Duration(milliseconds: 100),
                      ),
                      TypewriterAnimatedText(
                        'Tech Enthusiast',
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: isMobile ? 22 : 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentTeal,
                            ),
                        speed: const Duration(milliseconds: 100),
                      ),
                      TypewriterAnimatedText(
                        'Innovation Driver',
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: isMobile ? 22 : 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.successGreen,
                            ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 800.ms)
              .slideY(begin: 0.3, end: 0),
        ),

        const SizedBox(height: DesignConstants.spacingXLarge),

        // Bio with parallax
        Transform.translate(
          offset: Offset(0, -_scrollOffset * 0.25),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              widget.personalInfo.bio,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: isMobile ? 16 : 20,
                    height: 1.8,
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(((0.8) * 255).toInt()),
                  ),
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 1000.ms)
              .slideY(begin: 0.3, end: 0),
        ),

        const SizedBox(height: DesignConstants.spacing2XLarge),

        // CTA Buttons with hover effects
        Transform.translate(
          offset: Offset(0, -_scrollOffset * 0.3),
          child: Wrap(
            spacing: DesignConstants.spacingMedium,
            runSpacing: DesignConstants.spacingMedium,
            alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
            children: [
              _buildPrimaryButton(
                context,
                label: 'Download Resume',
                icon: Icons.download_rounded,
                onPressed: () {
                  // TODO: Implement resume download
                },
              ),
              _buildSecondaryButton(
                context,
                label: 'View My Work',
                icon: Icons.rocket_launch_rounded,
                onPressed: () {
                  Get.find<NavigationController>().scrollToSection('projects');
                },
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 1200.ms)
              .slideY(begin: 0.3, end: 0),
        ),

        const SizedBox(height: DesignConstants.spacing3XLarge),

        // Social links
        if (!isMobile)
          Transform.translate(
            offset: Offset(0, -_scrollOffset * 0.35),
            child: _buildSocialLinks(context)
                .animate()
                .fadeIn(duration: 600.ms, delay: 1400.ms)
                .slideY(begin: 0.3, end: 0),
          ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, bool isMobile) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            _floatAnimation.value - (_scrollOffset * 0.4),
          ),
          child: Transform.scale(
            scale: 1.0 - (_scrollOffset * 0.0003),
            child: child,
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? 300 : 450,
          maxHeight: isMobile ? 300 : 450,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              // Glowing background
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryBlue.withAlpha(((0.3) * 255).toInt()),
                        AppColors.accentPurple.withAlpha(((0.2) * 255).toInt()),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.2, 1.2),
                      duration: 3000.ms,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.2, 1.2),
                      end: const Offset(1, 1),
                      duration: 3000.ms,
                    ),
              ),

              // Gradient border
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.heroGradient,
                    boxShadow: AppShadows.xLarge,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: ClipOval(
                      child: widget.personalInfo.avatarUrl != null
                          ? Image.network(
                              widget.personalInfo.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildAvatarPlaceholder(context),
                            )
                          : _buildAvatarPlaceholder(context),
                    ),
                  ),
                ),
              ),

              // Rotating ring
              Positioned.fill(
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _floatController,
                      curve: Curves.linear,
                    ),
                  ),
                  child: CustomPaint(
                    painter: RingPainter(
                      color: AppColors.primaryBlue.withAlpha(((0.3) * 255).toInt()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms, delay: 600.ms)
            .scale(begin: const Offset(0.8, 0.8)),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Icon(
        Icons.person,
        size: 150,
        color: Colors.white.withAlpha(((0.5) * 255).toInt()),
      ),
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: DesignConstants.animationFast,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
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
                horizontal: DesignConstants.spacingLarge,
                vertical: DesignConstants.spacingMedium,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  const SizedBox(width: DesignConstants.spacingSmall),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: 3000.ms,
          delay: 2000.ms,
          color: Colors.white.withAlpha(((0.3) * 255).toInt()),
        );
  }

  Widget _buildSecondaryButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusMedium),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignConstants.spacingLarge,
                vertical: DesignConstants.spacingMedium,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: DesignConstants.spacingSmall),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLinks(BuildContext context) {
    final socialLinks = widget.personalInfo.socialLinks.toMap();
    if (socialLinks.isEmpty) return const SizedBox.shrink();

    return Row(
      children:
          socialLinks.entries.take(4).toList().asMap().entries.map((entry) {
        final index = entry.key;
        final socialEntry = entry.value;
        return Padding(
          padding: const EdgeInsets.only(right: DesignConstants.spacingSmall),
          child: _buildSocialIcon(
              context, socialEntry.key, socialEntry.value, index),
        );
      }).toList(),
    );
  }

  Widget _buildSocialIcon(
      BuildContext context, String platform, String url, int index) {
    IconData icon;
    switch (platform.toLowerCase()) {
      case 'github':
        icon = Icons.code;
        break;
      case 'linkedin':
        icon = Icons.work;
        break;
      case 'twitter':
        icon = Icons.tag;
        break;
      default:
        icon = Icons.link;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusSmall),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withAlpha(((0.2) * 255).toInt()),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // TODO: Open URL
            },
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusSmall),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat())
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.1, 1.1),
            duration: 2000.ms,
            delay: Duration(milliseconds: 200 * index),
          )
          .then()
          .scale(
            begin: const Offset(1.1, 1.1),
            end: const Offset(1, 1),
            duration: 2000.ms,
          ),
    );
  }
}

/// Custom painter for rotating ring effect
class RingPainter extends CustomPainter {
  final Color color;

  RingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw arc segments
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      1.5,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14,
      1.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
