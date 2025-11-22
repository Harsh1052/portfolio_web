import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/navigation_controller.dart';
import '../../models/personal_info.dart';
import '../../utils/design_constants.dart';

/// Contact Section - Social links and contact information
class ContactSection extends StatefulWidget {
  final PersonalInfo personalInfo;

  const ContactSection({
    super.key,
    required this.personalInfo,
  });

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('contact-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        key: navController.sectionKeys['contact'],
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
                _buildSectionTitle(context, 'Get In Touch')
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: DesignConstants.spacingLarge),

                Text(
                  'Have a project in mind? Let\'s work together!',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                )
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: DesignConstants.spacing2XLarge),

                // Contact cards
                isMobile
                    ? _buildMobileContactCards(context)
                    : _buildDesktopContactCards(context),

                const SizedBox(height: DesignConstants.spacing3XLarge),

                // Social links
                _buildSocialLinks(context)
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8)),

                const SizedBox(height: DesignConstants.spacing3XLarge),

                // Footer
                _buildFooter(context)
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms, delay: 800.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopContactCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildContactCard(
            context,
            Icons.email_outlined,
            'Email',
            widget.personalInfo.email,
            'Send me an email',
            0,
          ),
        ),
        if (widget.personalInfo.phone != null) ...[
          const SizedBox(width: DesignConstants.spacingLarge),
          Expanded(
            child: _buildContactCard(
              context,
              Icons.phone_outlined,
              'Phone',
              widget.personalInfo.phone!,
              'Give me a call',
              1,
            ),
          ),
        ],
        if (widget.personalInfo.location != null) ...[
          const SizedBox(width: DesignConstants.spacingLarge),
          Expanded(
            child: _buildContactCard(
              context,
              Icons.location_on_outlined,
              'Location',
              widget.personalInfo.location!,
              'Visit or meet',
              2,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMobileContactCards(BuildContext context) {
    return Column(
      children: [
        _buildContactCard(
          context,
          Icons.email_outlined,
          'Email',
          widget.personalInfo.email,
          'Send me an email',
          0,
        ),
        if (widget.personalInfo.phone != null) ...[
          const SizedBox(height: DesignConstants.spacingMedium),
          _buildContactCard(
            context,
            Icons.phone_outlined,
            'Phone',
            widget.personalInfo.phone!,
            'Give me a call',
            1,
          ),
        ],
        if (widget.personalInfo.location != null) ...[
          const SizedBox(height: DesignConstants.spacingMedium),
          _buildContactCard(
            context,
            Icons.location_on_outlined,
            'Location',
            widget.personalInfo.location!,
            'Visit or meet',
            2,
          ),
        ],
      ],
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    String subtitle,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(((0.5) * 255).toInt()),
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusLarge),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(((0.1) * 255).toInt()),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: _getGradientForIndex(index),
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusMedium),
              boxShadow: AppShadows.primary,
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: DesignConstants.spacingMedium),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: DesignConstants.spacingSmall),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignConstants.spacingXSmall),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.6) * 255).toInt()),
                ),
          ),
        ],
      ),
    )
        .animate(target: _isVisible ? 1 : 0)
        .fadeIn(duration: 600.ms, delay: (300 + (index * 100)).ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildSocialLinks(BuildContext context) {
    final socialLinksMap = widget.personalInfo.socialLinks.toMap();

    return Column(
      children: [
        Text(
          'Connect on social media',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: DesignConstants.spacingLarge),
        Wrap(
          spacing: DesignConstants.spacingMedium,
          runSpacing: DesignConstants.spacingMedium,
          alignment: WrapAlignment.center,
          children: socialLinksMap.entries.map((entry) {
            return _buildSocialButton(
              context,
              entry.key,
              entry.value,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSocialButton(BuildContext context, String platform, String url) {
    final config = _getSocialConfig(platform);

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: config['gradient'] as Gradient,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMedium),
        boxShadow: AppShadows.medium,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                config['icon'] as IconData,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(height: DesignConstants.spacingSmall),
              Text(
                platform,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: DesignConstants.spacingLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Made with ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 16,
              ),
            ),
            Text(
              ' using Flutter',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: DesignConstants.spacingSmall),
        Text(
          '© ${DateTime.now().year} ${widget.personalInfo.name}. All rights reserved.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.6) * 255).toInt()),
              ),
          textAlign: TextAlign.center,
        ),
      ],
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

  Gradient _getGradientForIndex(int index) {
    final gradients = [
      AppColors.primaryGradient,
      AppColors.secondaryGradient,
      AppColors.accentGradient,
    ];
    return gradients[index % gradients.length];
  }

  Map<String, dynamic> _getSocialConfig(String platform) {
    switch (platform.toLowerCase()) {
      case 'github':
        return {
          'icon': Icons.code,
          'gradient': const LinearGradient(
            colors: [Color(0xFF24292e), Color(0xFF586069)],
          ),
        };
      case 'linkedin':
        return {
          'icon': Icons.work,
          'gradient': const LinearGradient(
            colors: [Color(0xFF0077B5), Color(0xFF00A0DC)],
          ),
        };
      case 'twitter':
        return {
          'icon': Icons.tag,
          'gradient': const LinearGradient(
            colors: [Color(0xFF1DA1F2), Color(0xFF0C85D0)],
          ),
        };
      default:
        return {
          'icon': Icons.link,
          'gradient': AppColors.primaryGradient,
        };
    }
  }
}
