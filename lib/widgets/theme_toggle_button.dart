import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../utils/design_constants.dart';

/// Theme Toggle Button Widget
/// Provides an animated button to switch between light and dark themes
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => IconButton(
        icon: AnimatedSwitcher(
          duration: DesignConstants.animationNormal,
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            key: ValueKey(themeController.isDarkMode),
          ),
        ),
        onPressed: () => themeController.toggleTheme(),
        tooltip: themeController.isDarkMode
            ? 'Switch to Light Mode'
            : 'Switch to Dark Mode',
      ),
    );
  }
}

/// Fancy Theme Toggle Button with gradient background
class FancyThemeToggleButton extends StatelessWidget {
  const FancyThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          gradient: themeController.isDarkMode
              ? AppColors.darkGradient
              : AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(DesignConstants.borderRadiusFull),
          boxShadow: themeController.isDarkMode
              ? AppShadows.mediumDark
              : AppShadows.primary,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => themeController.toggleTheme(),
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusFull),
            child: Padding(
              padding: const EdgeInsets.all(DesignConstants.spacingSmall),
              child: AnimatedSwitcher(
                duration: DesignConstants.animationNormal,
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  themeController.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  key: ValueKey(themeController.isDarkMode),
                  color: Colors.white,
                  size: DesignConstants.iconSizeMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Theme Mode Selector - Dropdown to select Light, Dark, or System
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => PopupMenuButton<ThemeMode>(
        icon: Icon(
          _getIconForThemeMode(themeController.themeMode),
        ),
        tooltip: 'Select Theme Mode',
        onSelected: (ThemeMode mode) {
          themeController.setThemeMode(mode);
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: ThemeMode.light,
            child: Row(
              children: [
                const Icon(Icons.light_mode),
                const SizedBox(width: DesignConstants.spacingSmall),
                const Text('Light'),
                if (themeController.themeMode == ThemeMode.light)
                  const Padding(
                    padding: EdgeInsets.only(left: DesignConstants.spacingSmall),
                    child: Icon(Icons.check, size: 16),
                  ),
              ],
            ),
          ),
          PopupMenuItem(
            value: ThemeMode.dark,
            child: Row(
              children: [
                const Icon(Icons.dark_mode),
                const SizedBox(width: DesignConstants.spacingSmall),
                const Text('Dark'),
                if (themeController.themeMode == ThemeMode.dark)
                  const Padding(
                    padding: EdgeInsets.only(left: DesignConstants.spacingSmall),
                    child: Icon(Icons.check, size: 16),
                  ),
              ],
            ),
          ),
          PopupMenuItem(
            value: ThemeMode.system,
            child: Row(
              children: [
                const Icon(Icons.brightness_auto),
                const SizedBox(width: DesignConstants.spacingSmall),
                const Text('System'),
                if (themeController.themeMode == ThemeMode.system)
                  const Padding(
                    padding: EdgeInsets.only(left: DesignConstants.spacingSmall),
                    child: Icon(Icons.check, size: 16),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
