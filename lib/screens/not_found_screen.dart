import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import '../utils/design_constants.dart';

/// Simple 404 / not found screen with navigation back home.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NavigationController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(DesignConstants.spacing2XLarge),
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusXLarge),
              boxShadow: AppShadows.large,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.search_off_rounded,
                  size: 80,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(height: DesignConstants.spacingLarge),
                Text(
                  'Page Not Found',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DesignConstants.spacingSmall),
                Text(
                  'The page you are looking for does not exist or has been moved.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DesignConstants.spacingXLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Get.offAllNamed('/'),
                      icon: const Icon(Icons.home_rounded),
                      label: const Text('Back to Home'),
                    ),
                    const SizedBox(width: DesignConstants.spacingMedium),
                    OutlinedButton.icon(
                      onPressed: () => Get.back<void>(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Go Back'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
