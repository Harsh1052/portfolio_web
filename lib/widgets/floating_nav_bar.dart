import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import '../utils/design_constants.dart';
import '../widgets/theme_toggle_button.dart';

/// Floating Navigation Bar that appears on scroll
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return Obx(
      () => AnimatedSlide(
        duration: DesignConstants.animationNormal,
        curve: DesignConstants.curveEmphasized,
        offset: navController.showFloatingNav.value
            ? Offset.zero
            : const Offset(0, -2),
        child: AnimatedOpacity(
          duration: DesignConstants.animationNormal,
          opacity: navController.showFloatingNav.value ? 1.0 : 0.0,
          child: Container(
            margin: EdgeInsets.all(
              isMobile
                  ? DesignConstants.spacingSmall
                  : DesignConstants.spacingMedium,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withAlpha(((0.95) * 255).toInt()),
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusLarge),
              boxShadow: AppShadows.large,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withAlpha(((0.1) * 255).toInt()),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusLarge),
              child: isMobile
                  ? _buildMobileNav(context)
                  : _buildDesktopNav(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopNav(BuildContext context) {
    final navController = Get.find<NavigationController>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignConstants.spacingLarge,
        vertical: DesignConstants.spacingSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo/Name
          InkWell(
            onTap: () => navController.scrollToTop(),
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusSmall),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignConstants.spacingSmall,
                vertical: DesignConstants.spacingSmall,
              ),
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.primaryGradient.createShader(bounds),
                child: Text(
                  'Portfolio',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),

          const SizedBox(width: DesignConstants.spacingLarge),

          // Navigation items
          _buildNavItem(context, 'Home', 'home'),
          _buildNavItem(context, 'About', 'about'),
          _buildNavItem(context, 'Skills', 'skills'),
          _buildNavItem(context, 'Experience', 'experience'),
          _buildNavItem(context, 'Projects', 'projects'),
          _buildNavItem(context, 'Contact', 'contact'),

          const SizedBox(width: DesignConstants.spacingMedium),

          // Theme toggle
          const FancyThemeToggleButton(),
        ],
      ),
    );
  }

  Widget _buildMobileNav(BuildContext context) {
    final navController = Get.find<NavigationController>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignConstants.spacingMedium,
        vertical: DesignConstants.spacingSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          InkWell(
            onTap: () => navController.scrollToTop(),
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: Text(
                'Portfolio',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
          ),

          // Menu button
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FancyThemeToggleButton(),
              const SizedBox(width: DesignConstants.spacingSmall),
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _showMobileMenu(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, String section) {
    final navController = Get.find<NavigationController>();

    return Obx(
      () {
        final isActive = navController.activeSection.value == section;

        return Semantics(
          label: '$label navigation button',
          button: true,
          selected: isActive,
          onTapHint: 'Scroll to $label section',
          child: AnimatedContainer(
            duration: DesignConstants.animationFast,
            decoration: BoxDecoration(
              gradient: isActive ? AppColors.primaryGradient : null,
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusSmall),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => navController.scrollToSection(section),
                borderRadius:
                    BorderRadius.circular(DesignConstants.borderRadiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignConstants.spacingMedium,
                    vertical: DesignConstants.spacingSmall,
                  ),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w500,
                          color: isActive
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(DesignConstants.borderRadiusXLarge),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(DesignConstants.spacingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: DesignConstants.spacingLarge),

                // Menu items
                _buildMobileMenuItem(context, 'Home', Icons.home, 'home'),
                _buildMobileMenuItem(context, 'About', Icons.person, 'about'),
                _buildMobileMenuItem(context, 'Skills', Icons.code, 'skills'),
                _buildMobileMenuItem(
                    context, 'Experience', Icons.work, 'experience'),
                _buildMobileMenuItem(
                    context, 'Projects', Icons.folder, 'projects'),
                _buildMobileMenuItem(
                    context, 'Contact', Icons.email, 'contact'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileMenuItem(
    BuildContext context,
    String label,
    IconData icon,
    String section,
  ) {
    final navController = Get.find<NavigationController>();

    return Obx(
      () {
        final isActive = navController.activeSection.value == section;

        return Semantics(
          label: '$label navigation button',
          button: true,
          selected: isActive,
          onTapHint: 'Scroll to $label section',
          child: Container(
            margin: const EdgeInsets.only(bottom: DesignConstants.spacingSmall),
            decoration: BoxDecoration(
              gradient: isActive ? AppColors.primaryGradient : null,
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusMedium),
            ),
            child: ListTile(
              leading: Icon(
                icon,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
              title: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              onTap: () {
                Navigator.pop(context);
                navController.scrollToSection(section);
              },
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(DesignConstants.borderRadiusMedium),
              ),
            ),
          ),
        );
      },
    );
  }
}
