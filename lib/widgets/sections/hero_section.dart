import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../controllers/navigation_controller.dart';
import '../../models/personal_info.dart';
import '../../utils/design_constants.dart';

/// Hero Section - Animated introduction with name and title
class HeroSection extends StatelessWidget {
  final PersonalInfo personalInfo;

  const HeroSection({
    super.key,
    required this.personalInfo,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final navController = Get.find<NavigationController>();

    return Container(
      key: navController.sectionKeys['home'],
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface,
            AppColors.primaryBlue.withAlpha(((0.05) * 255).toInt()),
            AppColors.accentPurple.withAlpha(((0.05) * 255).toInt()),
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints:
              const BoxConstraints(maxWidth: DesignConstants.maxContentWidth),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getContainerPadding(context),
            vertical: ResponsiveHelper.getSectionSpacing(context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Greeting
              Text(
                '👋 Hello, I\'m',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: DesignConstants.spacingMedium),

              // Name with gradient
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.heroGradient.createShader(bounds),
                child: Text(
                  personalInfo.name,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontSize: isMobile ? 40 : 64,
                      ),
                  textAlign: TextAlign.center,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: DesignConstants.spacingLarge),

              // Animated Title
              SizedBox(
                height: isMobile ? 60 : 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'I\'m a ',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: isMobile ? 20 : 28,
                              ),
                    ),
                    AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(milliseconds: 2000),
                      animatedTexts: [
                        TypewriterAnimatedText(
                          personalInfo.title,
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: isMobile ? 20 : 28,
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
                                fontSize: isMobile ? 20 : 28,
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
                                fontSize: isMobile ? 20 : 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentTeal,
                              ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: DesignConstants.spacingXLarge),

              // Bio
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Text(
                  personalInfo.bio,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: isMobile ? 14 : 18,
                        height: 1.6,
                      ),
                  textAlign: TextAlign.center,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 800.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: DesignConstants.spacing2XLarge),

              // CTA Buttons
              Wrap(
                spacing: DesignConstants.spacingMedium,
                runSpacing: DesignConstants.spacingMedium,
                alignment: WrapAlignment.center,
                children: [
                  _buildGradientButton(
                    context,
                    label: 'View My Work',
                    icon: Icons.rocket_launch,
                    onPressed: () => navController.scrollToSection('projects'),
                  ),
                  _buildOutlinedButton(
                    context,
                    label: 'Contact Me',
                    icon: Icons.email_outlined,
                    onPressed: () => navController.scrollToSection('contact'),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 1000.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: DesignConstants.spacing3XLarge),

              // Scroll indicator
              _buildScrollIndicator(context)
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(duration: 600.ms, delay: 1200.ms)
                  .then()
                  .moveY(
                    begin: 0,
                    end: 10,
                    duration: 1500.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .moveY(
                    begin: 10,
                    end: 0,
                    duration: 1500.ms,
                    curve: Curves.easeInOut,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton(
    BuildContext context, {
    required String label,
    required IconData icon,
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
              horizontal: DesignConstants.spacingLarge,
              vertical: DesignConstants.spacingMedium,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: DesignConstants.spacingSmall),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

  Widget _buildOutlinedButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMedium),
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
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: DesignConstants.spacingSmall),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
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

  Widget _buildScrollIndicator(BuildContext context) {
    return Column(
      children: [
        Text(
          'Scroll to explore',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.6) * 255).toInt()),
              ),
        ),
        const SizedBox(height: DesignConstants.spacingSmall),
        Icon(
          Icons.keyboard_arrow_down,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.6) * 255).toInt()),
        ),
      ],
    );
  }
}
