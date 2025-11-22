import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/contact_form_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../models/personal_info.dart';
import '../../utils/design_constants.dart';

/// Enhanced Contact Section with animated social links and contact form
class EnhancedContactSection extends StatefulWidget {
  final PersonalInfo personalInfo;

  const EnhancedContactSection({
    super.key,
    required this.personalInfo,
  });

  @override
  State<EnhancedContactSection> createState() => _EnhancedContactSectionState();
}

class _EnhancedContactSectionState extends State<EnhancedContactSection> {
  bool _isVisible = false;
  final _formKey = GlobalKey<FormState>();
  late ContactFormController _contactController;

  @override
  void initState() {
    super.initState();
    _contactController = Get.put(ContactFormController());
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('enhanced-contact-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        key: navController.sectionKeys['contact'],
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              AppColors.primaryBlue.withAlpha(((0.02) * 255).toInt()),
              AppColors.accentPurple.withAlpha(((0.03) * 255).toInt()),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getContainerPadding(context),
          vertical: ResponsiveHelper.getSectionSpacing(context),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                // Section Title
                _buildSectionTitle(context)
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: DesignConstants.spacing2XLarge),

                // Main content - Form and Contact Info
                isMobile
                    ? _buildMobileLayout(context)
                    : _buildDesktopLayout(context),

                const SizedBox(height: DesignConstants.spacing3XLarge),

                // Social Links with animations
                _buildAnimatedSocialLinks(context)
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

  Widget _buildSectionTitle(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Text(
            'Get In Touch',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: DesignConstants.spacingSmall),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: DesignConstants.spacingMedium),
        Text(
          'Have a project in mind? Let\'s work together to bring your ideas to life!',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.7) * 255).toInt()),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact Form - Left Side
        Expanded(
          flex: 3,
          child: _buildContactForm(context)
              .animate(target: _isVisible ? 1 : 0)
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideX(begin: -0.3, end: 0),
        ),

        const SizedBox(width: DesignConstants.spacing2XLarge),

        // Contact Info - Right Side
        Expanded(
          flex: 2,
          child: _buildContactInfo(context)
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
        // Contact Info
        _buildContactInfo(context)
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: 0.3, end: 0),

        const SizedBox(height: DesignConstants.spacing2XLarge),

        // Contact Form
        _buildContactForm(context)
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(duration: 600.ms, delay: 400.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusLarge),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(((0.1) * 255).toInt()),
        ),
        boxShadow: AppShadows.large,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Title
            Text(
              'Send me a message',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: DesignConstants.spacingSmall),
            Text(
              'Fill out the form below and I\'ll get back to you as soon as possible.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(((0.7) * 255).toInt()),
                  ),
            ),

            const SizedBox(height: DesignConstants.spacingLarge),

            // Name Field
            _buildTextField(
              controller: _contactController.nameController,
              label: 'Your Name',
              hint: 'John Doe',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            const SizedBox(height: DesignConstants.spacingMedium),

            // Email Field
            _buildTextField(
              controller: _contactController.emailController,
              label: 'Email Address',
              hint: 'john@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!GetUtils.isEmail(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: DesignConstants.spacingMedium),

            // Subject Field
            _buildTextField(
              controller: _contactController.subjectController,
              label: 'Subject',
              hint: 'Project Inquiry',
              icon: Icons.subject_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),

            const SizedBox(height: DesignConstants.spacingMedium),

            // Message Field
            _buildTextField(
              controller: _contactController.messageController,
              label: 'Message',
              hint: 'Tell me about your project...',
              icon: Icons.message_outlined,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a message';
                }
                if (value.length < 10) {
                  return 'Message should be at least 10 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: DesignConstants.spacingLarge),

            // Submit Button
            Obx(() => _buildSubmitButton(context)),

            // Success/Error Message
            Obx(() {
              if (_contactController.successMessage.isNotEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.only(top: DesignConstants.spacingMedium),
                  child: _buildSuccessMessage(context),
                );
              }
              if (_contactController.errorMessage.isNotEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.only(top: DesignConstants.spacingMedium),
                  child: _buildErrorMessage(context),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: DesignConstants.spacingXSmall),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusMedium),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusMedium),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(((0.1) * 255).toInt()),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusMedium),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(DesignConstants.borderRadiusMedium),
              borderSide: const BorderSide(
                color: AppColors.errorRed,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.all(DesignConstants.spacingMedium),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius:
              BorderRadius.circular(DesignConstants.borderRadiusMedium),
          boxShadow: AppShadows.primary,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _contactController.isLoading.value
                ? null
                : () => _submitForm(context),
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusMedium),
            child: Center(
              child: _contactController.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: DesignConstants.spacingSmall),
                        Text(
                          'Send Message',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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

  Widget _buildSuccessMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withAlpha(((0.1) * 255).toInt()),
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMedium),
        border: Border.all(
          color: AppColors.successGreen.withAlpha(((0.3) * 255).toInt()),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.successGreen,
          ),
          const SizedBox(width: DesignConstants.spacingSmall),
          Expanded(
            child: Text(
              _contactController.successMessage.value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.successGreen,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.2, end: 0)
        .shimmer(duration: 1000.ms, color: Colors.white.withAlpha(((0.3) * 255).toInt()));
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withAlpha(((0.1) * 255).toInt()),
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMedium),
        border: Border.all(
          color: AppColors.errorRed.withAlpha(((0.3) * 255).toInt()),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.errorRed,
          ),
          const SizedBox(width: DesignConstants.spacingSmall),
          Expanded(
            child: Text(
              _contactController.errorMessage.value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.errorRed,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.2, end: 0)
        .shake(duration: 500.ms);
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact Info Title
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: DesignConstants.spacingSmall),
        Text(
          'Feel free to reach out through any of these channels',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.7) * 255).toInt()),
              ),
        ),

        const SizedBox(height: DesignConstants.spacingLarge),

        // Email
        _buildContactInfoCard(
          context,
          Icons.email_outlined,
          'Email',
          widget.personalInfo.email,
          () => _launchUrl('mailto:${widget.personalInfo.email}'),
        ),

        if (widget.personalInfo.phone != null) ...[
          const SizedBox(height: DesignConstants.spacingMedium),
          _buildContactInfoCard(
            context,
            Icons.phone_outlined,
            'Phone',
            widget.personalInfo.phone!,
            () => _launchUrl('tel:${widget.personalInfo.phone}'),
          ),
        ],

        if (widget.personalInfo.location != null) ...[
          const SizedBox(height: DesignConstants.spacingMedium),
          _buildContactInfoCard(
            context,
            Icons.location_on_outlined,
            'Location',
            widget.personalInfo.location!,
            null,
          ),
        ],

        const SizedBox(height: DesignConstants.spacingLarge),

        // Quick Links
        _buildQuickLinks(context),
      ],
    );
  }

  Widget _buildContactInfoCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    VoidCallback? onTap,
  ) {
    return MouseRegion(
      cursor:
          onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(DesignConstants.spacingMedium),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(((0.5) * 255).toInt()),
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusMedium),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withAlpha(((0.1) * 255).toInt()),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius:
                      BorderRadius.circular(DesignConstants.borderRadiusSmall),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: DesignConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(((0.6) * 255).toInt()),
                          ),
                    ),
                    const SizedBox(height: DesignConstants.spacingXSmall),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.4) * 255).toInt()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: DesignConstants.spacingMedium),
        _buildQuickLinkItem(context, 'Home', () {
          Get.find<NavigationController>().scrollToSection('home');
        }),
        _buildQuickLinkItem(context, 'About', () {
          Get.find<NavigationController>().scrollToSection('about');
        }),
        _buildQuickLinkItem(context, 'Projects', () {
          Get.find<NavigationController>().scrollToSection('projects');
        }),
        _buildQuickLinkItem(context, 'Experience', () {
          Get.find<NavigationController>().scrollToSection('experience');
        }),
      ],
    );
  }

  Widget _buildQuickLinkItem(
      BuildContext context, String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: DesignConstants.spacingSmall,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: DesignConstants.spacingSmall),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSocialLinks(BuildContext context) {
    final socialLinksMap = widget.personalInfo.socialLinks.toMap();

    return Column(
      children: [
        Text(
          'Connect on Social Media',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: DesignConstants.spacingMedium),
        Text(
          'Let\'s stay connected!',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(((0.7) * 255).toInt()),
              ),
        ),
        const SizedBox(height: DesignConstants.spacingLarge),
        Wrap(
          spacing: DesignConstants.spacingMedium,
          runSpacing: DesignConstants.spacingMedium,
          alignment: WrapAlignment.center,
          children:
              socialLinksMap.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final socialEntry = entry.value;
            return _buildAnimatedSocialButton(
              context,
              socialEntry.key,
              socialEntry.value,
              index,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnimatedSocialButton(
    BuildContext context,
    String platform,
    String url,
    int index,
  ) {
    final config = _getSocialConfig(platform);

    return _SocialButton(
      platform: platform,
      url: url,
      icon: config['icon'] as IconData,
      gradient: config['gradient'] as Gradient,
      onTap: () => _launchUrl(url),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .shimmer(
          duration: 2000.ms,
          delay: Duration(milliseconds: 200 * index),
          color: Colors.white.withAlpha(((0.2) * 255).toInt()),
        );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Theme.of(context).colorScheme.outline.withAlpha(((0.3) * 255).toInt()),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: DesignConstants.spacingLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Built with ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 18,
              ),
            ).animate(onPlay: (controller) => controller.repeat()).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                  duration: 1000.ms,
                ),
            Text(
              ' and Flutter',
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

  Map<String, dynamic> _getSocialConfig(String platform) {
    switch (platform.toLowerCase()) {
      case 'github':
        return {
          'icon': Icons.code_rounded,
          'gradient': const LinearGradient(
            colors: [Color(0xFF24292e), Color(0xFF586069)],
          ),
        };
      case 'linkedin':
        return {
          'icon': Icons.business_center_rounded,
          'gradient': const LinearGradient(
            colors: [Color(0xFF0077B5), Color(0xFF00A0DC)],
          ),
        };
      case 'twitter':
      case 'x':
        return {
          'icon': Icons.tag_rounded,
          'gradient': const LinearGradient(
            colors: [Color(0xFF1DA1F2), Color(0xFF0C85D0)],
          ),
        };
      case 'instagram':
        return {
          'icon': Icons.camera_alt_rounded,
          'gradient': const LinearGradient(
            colors: [Color(0xFFC13584), Color(0xFFE1306C), Color(0xFFFD1D1D)],
          ),
        };
      case 'youtube':
        return {
          'icon': Icons.play_circle_outline_rounded,
          'gradient': const LinearGradient(
            colors: [Color(0xFFFF0000), Color(0xFFCC0000)],
          ),
        };
      case 'dribbble':
        return {
          'icon': Icons.sports_basketball_rounded,
          'gradient': const LinearGradient(
            colors: [Color(0xFFEA4C89), Color(0xFFC32361)],
          ),
        };
      default:
        return {
          'icon': Icons.link_rounded,
          'gradient': AppColors.primaryGradient,
        };
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      await _contactController.submitForm();
    }
  }
}

/// Animated Social Button Widget
class _SocialButton extends StatefulWidget {
  final String platform;
  final String url;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _SocialButton({
    required this.platform,
    required this.url,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DesignConstants.animationNormal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: DesignConstants.curveEmphasized,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: DesignConstants.curveEmphasized,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotateAnimation.value,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: widget.gradient,
                  borderRadius:
                      BorderRadius.circular(DesignConstants.borderRadiusMedium),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: AppColors.primaryBlue.withAlpha(((0.4) * 255).toInt()),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : AppShadows.medium,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(
                        DesignConstants.borderRadiusMedium),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.icon,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: DesignConstants.spacingSmall),
                        Text(
                          widget.platform,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
