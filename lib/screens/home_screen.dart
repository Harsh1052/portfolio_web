import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/resume_controller.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResumeController resumeController = Get.put(ResumeController());

    return Scaffold(
      body: Obx(() {
        if (resumeController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (resumeController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppConstants.spacingM),
                Text(
                  'Error Loading Portfolio',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppConstants.spacingS),
                Text(
                  resumeController.errorMessage.value,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingL),
                ElevatedButton.icon(
                  onPressed: () => resumeController.loadResume(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final resume = resumeController.resume.value;
        if (resume == null) {
          return const Center(
            child: Text('No data available'),
          );
        }

        return CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(
                resume.personalInfo.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('About'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Experience'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Projects'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Skills'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Contact'),
                ),
                const SizedBox(width: AppConstants.spacingM),
              ],
            ),

            // Hero Section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingXxl,
                  vertical: AppConstants.spacingXxl * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Hi, I\'m ${resume.personalInfo.name}',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    Text(
                      resume.personalInfo.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingL),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Text(
                        resume.personalInfo.bio,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          label: const Text('Download CV'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingXl,
                              vertical: AppConstants.spacingL,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingM),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.email),
                          label: const Text('Contact Me'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingXl,
                              vertical: AppConstants.spacingL,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Quick Stats
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingXxl),
                color: AppColors.surfaceVariant,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppConstants.spacingXl,
                  runSpacing: AppConstants.spacingL,
                  children: [
                    _buildStatCard(
                      context,
                      '4+',
                      'Years Experience',
                      Icons.work,
                    ),
                    _buildStatCard(
                      context,
                      '15+',
                      'Projects Delivered',
                      Icons.code,
                    ),
                    _buildStatCard(
                      context,
                      '75k+',
                      'Active Users',
                      Icons.people,
                    ),
                    _buildStatCard(
                      context,
                      '99.9%',
                      'Uptime',
                      Icons.trending_up,
                    ),
                  ],
                ),
              ),
            ),

            // Footer Placeholder
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingXxl),
                child: Center(
                  child: Text(
                    '© ${DateTime.now().year} ${resume.personalInfo.name}. All rights reserved.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
