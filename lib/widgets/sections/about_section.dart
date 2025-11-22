import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/navigation_controller.dart';
import '../../models/personal_info.dart';
import '../../utils/design_constants.dart';

/// About Section - Bio and personal information with photo
class AboutSection extends StatefulWidget {
  final PersonalInfo personalInfo;

  const AboutSection({
    super.key,
    required this.personalInfo,
  });

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        key: navController.sectionKeys['about'],
        color: Theme.of(context).colorScheme.surface,
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
                _buildSectionTitle(context, 'About Me')
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: DesignConstants.spacing2XLarge),

                // Content
                isMobile
                    ? _buildMobileLayout(context)
                    : _buildDesktopLayout(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Photo
        Expanded(
          flex: 4,
          child: _buildPhoto(context)
              .animate(target: _isVisible ? 1 : 0)
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideX(begin: -0.3, end: 0),
        ),

        const SizedBox(width: DesignConstants.spacing2XLarge),

        // Content
        Expanded(
          flex: 6,
          child: _buildContent(context)
              .animate(target: _isVisible ? 1 : 0)
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideX(begin: 0.3, end: 0),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildPhoto(context)
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
        const SizedBox(height: DesignConstants.spacing2XLarge),
        _buildContent(context)
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(duration: 600.ms, delay: 400.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildPhoto(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusLarge),
            boxShadow: AppShadows.large,
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusLarge),
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusLarge),
              child: Icon(
                Icons.person,
                size: 200,
                color: Theme.of(context).colorScheme.primary.withAlpha(((0.2) * 255).toInt()),
              ),
              // Replace with actual image:
              // Image.network(
              //   widget.personalInfo.photo,
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi there! 👋',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),

        const SizedBox(height: DesignConstants.spacingLarge),

        Text(
          widget.personalInfo.bio,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.8,
              ),
        ),

        const SizedBox(height: DesignConstants.spacingXLarge),

        // Info cards
        Wrap(
          spacing: DesignConstants.spacingMedium,
          runSpacing: DesignConstants.spacingMedium,
          children: [
            _buildInfoCard(
              context,
              Icons.email_outlined,
              'Email',
              widget.personalInfo.email,
            ),
            if (widget.personalInfo.phone != null)
              _buildInfoCard(
                context,
                Icons.phone_outlined,
                'Phone',
                widget.personalInfo.phone!,
              ),
            if (widget.personalInfo.location != null)
              _buildInfoCard(
                context,
                Icons.location_on_outlined,
                'Location',
                widget.personalInfo.location!,
              ),
          ],
        ),

        const SizedBox(height: DesignConstants.spacingXLarge),

        // Social links
        _buildSocialLinks(context),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(DesignConstants.spacingSmall),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusSmall),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: DesignConstants.spacingSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks(BuildContext context) {
    final socialLinksMap = widget.personalInfo.socialLinks.toMap();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect with me',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: DesignConstants.spacingMedium),
        Wrap(
          spacing: DesignConstants.spacingSmall,
          runSpacing: DesignConstants.spacingSmall,
          children: socialLinksMap.entries.map((entry) {
            return _buildSocialButton(context, entry.key, entry.value);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSocialButton(BuildContext context, String platform, String url) {
    IconData icon;
    Color color;

    switch (platform.toLowerCase()) {
      case 'github':
        icon = Icons.code;
        color = const Color(0xFF333333);
        break;
      case 'linkedin':
        icon = Icons.work;
        color = const Color(0xFF0077B5);
        break;
      case 'twitter':
        icon = Icons.tag;
        color = const Color(0xFF1DA1F2);
        break;
      default:
        icon = Icons.link;
        color = AppColors.primaryBlue;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withAlpha(((0.8) * 255).toInt())],
        ),
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusSmall),
        boxShadow: AppShadows.small,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Open URL
          },
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusSmall),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignConstants.spacingMedium,
              vertical: DesignConstants.spacingSmall,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: DesignConstants.spacingSmall),
                Text(
                  platform,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Text(
            title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: DesignConstants.spacingSmall),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
