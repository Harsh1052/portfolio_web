import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import '../controllers/resume_controller.dart';
import '../utils/design_constants.dart';
import '../widgets/floating_nav_bar.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/enhanced_contact_section.dart';
import '../widgets/sections/enhanced_experience_section.dart';
import '../widgets/sections/enhanced_hero_section.dart';
import '../widgets/sections/enhanced_projects_section.dart';
import '../widgets/sections/enhanced_skills_section.dart';

/// Home Screen - Main container for the portfolio with smooth scrolling
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResumeController resumeController = Get.put(ResumeController());
    final NavigationController navController = Get.put(NavigationController());

    return Scaffold(
      body: Obx(() {
        if (resumeController.isLoading.value) {
          return const _AnimatedSplashScreen();
        }

        if (resumeController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(DesignConstants.spacingLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(DesignConstants.spacingLarge),
                    decoration: BoxDecoration(
                      color: AppColors.errorRed.withAlpha(10),
                      borderRadius: BorderRadius.circular(
                        DesignConstants.borderRadiusLarge,
                      ),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.errorRed,
                    ),
                  ),
                  const SizedBox(height: DesignConstants.spacingLarge),
                  Text(
                    'Error Loading Portfolio',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: DesignConstants.spacingSmall),
                  Text(
                    resumeController.errorMessage.value,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DesignConstants.spacingLarge),
                  ElevatedButton.icon(
                    onPressed: () => resumeController.loadResume(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final resume = resumeController.resume.value;
        if (resume == null) {
          return const Center(
            child: Text('No data available'),
          );
        }

        return Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              controller: navController.scrollController,
              child: Column(
                children: [
                  Semantics(
                    label: 'Hero section with introduction',
                    child:
                        EnhancedHeroSection(personalInfo: resume.personalInfo),
                  ),
                  Semantics(
                    label: 'About section',
                    child: AboutSection(personalInfo: resume.personalInfo),
                  ),
                  Semantics(
                    label: 'Skills section',
                    child: EnhancedSkillsSection(skills: resume.skills),
                  ),
                  Semantics(
                    label: 'Experience section',
                    child:
                        EnhancedExperienceSection(experiences: resume.experience),
                  ),
                  Semantics(
                    label: 'Projects section',
                    child: EnhancedProjectsSection(projects: resume.projects),
                  ),
                  Semantics(
                    label: 'Contact section',
                    child: EnhancedContactSection(
                      personalInfo: resume.personalInfo,
                    ),
                  ),
                ],
              ),
            ),

            // Floating Navigation Bar
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: FloatingNavBar(),
            ),

            // Scroll progress indicator
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _ScrollProgressBar(navController: navController),
            ),

            // Scroll to top button
            Obx(
              () => AnimatedPositioned(
                duration: DesignConstants.animationNormal,
                right: DesignConstants.spacingMedium,
                bottom: navController.showFloatingNav.value
                    ? DesignConstants.spacingMedium
                    : -100,
                child: _buildScrollToTopButton(context, navController),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildScrollToTopButton(
    BuildContext context,
    NavigationController navController,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusFull),
        boxShadow: AppShadows.large,
      ),
      child: Semantics(
        label: 'Back to top',
        hint: 'Scrolls to the beginning of the page',
        button: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => navController.scrollToTop(),
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusFull),
            child: Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated splash screen shown during data load
class _AnimatedSplashScreen extends StatelessWidget {
  const _AnimatedSplashScreen();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading portfolio content',
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(DesignConstants.borderRadiusLarge),
                  boxShadow: AppShadows.primary,
                  gradient: AppColors.primaryGradient,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(DesignConstants.spacingLarge),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 1200.ms, color: Colors.white.withAlpha(60)),
              const SizedBox(height: DesignConstants.spacingLarge),
              Text(
                'Preparing your experience...',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .fadeIn(duration: 800.ms)
                  .then()
                  .fadeOut(duration: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thin progress indicator showing scroll position
class _ScrollProgressBar extends StatelessWidget {
  final NavigationController navController;

  const _ScrollProgressBar({required this.navController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        duration: DesignConstants.animationFast,
        opacity: navController.scrollProgress.value > 0 ? 1.0 : 0.0,
        child: LinearProgressIndicator(
          value: navController.scrollProgress.value == 0
              ? null
              : navController.scrollProgress.value,
          minHeight: 4,
          backgroundColor: Theme.of(context)
              .colorScheme
              .surface
              .withAlpha(((0.6) * 255).toInt()),
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          semanticsLabel: 'Scroll progress indicator',
        ),
      ),
    );
  }
}
