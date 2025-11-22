import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/contact_form_controller.dart';
import '../utils/design_constants.dart';

/// Engaging contact section with animated social links and optional contact form
class ContactSection extends StatefulWidget {
  final bool showContactForm;

  const ContactSection({
    super.key,
    this.showContactForm = true,
  });

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      color: colorScheme.surface,
      child: Column(
        children: [
          // Main Contact Content
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? DesignConstants.spacingMedium
                  : DesignConstants.spacingXLarge,
              vertical: DesignConstants.spacingXLarge * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Text(
                  'Get In Touch',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: DesignConstants.spacingSmall),
                Text(
                  "Let's work together on your next project",
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 100.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: DesignConstants.spacingXLarge),

                // Contact Content
                isMobile
                    ? Column(
                        children: [
                          _buildContactInfo(context),
                          const SizedBox(height: DesignConstants.spacingXLarge),
                          if (widget.showContactForm)
                            _buildContactForm(context),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: _buildContactInfo(context),
                          ),
                          const SizedBox(width: DesignConstants.spacingXLarge),
                          if (widget.showContactForm)
                            Expanded(
                              flex: 2,
                              child: _buildContactForm(context),
                            ),
                        ],
                      ),
              ],
            ),
          ),

          // Footer
          _buildFooter(context),
        ],
      ),
    );
  }

  /// Build contact information section with social links
  Widget _buildContactInfo(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email
        _ContactInfoItem(
          icon: Icons.email_outlined,
          label: 'Email',
          value: 'surejapatel@gmail.com',
          onTap: () => _launchUrl('mailto:surejapatel@gmail.com'),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: DesignConstants.spacingMedium),

        // Phone
        _ContactInfoItem(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: '+91 9879776369',
          onTap: () => _launchUrl('tel:+919879776369'),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 300.ms)
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: DesignConstants.spacingMedium),

        // Location
        const _ContactInfoItem(
          icon: Icons.location_on_outlined,
          label: 'Location',
          value: 'Surat, Gujarat, India',
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 400.ms)
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: DesignConstants.spacingXLarge),

        // Social Links Section
        Text(
          'Connect with me',
          style: textTheme.titleMedium,
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 500.ms)
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: DesignConstants.spacingMedium),

        // Social Media Icons
        Wrap(
          spacing: DesignConstants.spacingMedium,
          runSpacing: DesignConstants.spacingMedium,
          children: [
            _SocialIconButton(
              icon: Icons.code,
              label: 'GitHub',
              color: const Color(0xFF333333),
              url: 'https://github.com/harshsureja',
              delay: 600.ms,
            ),
            _SocialIconButton(
              icon: Icons.work_outline,
              label: 'LinkedIn',
              color: const Color(0xFF0077B5),
              url: 'https://linkedin.com/in/harshsureja',
              delay: 700.ms,
            ),
            _SocialIconButton(
              icon: Icons.question_answer,
              label: 'Stack Overflow',
              color: const Color(0xFFF48024),
              url: 'https://stackoverflow.com/users/harshsureja',
              delay: 800.ms,
            ),
          ],
        ),
      ],
    );
  }

  /// Build contact form
  Widget _buildContactForm(BuildContext context) {
    final controller = Get.put(ContactFormController());
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(DesignConstants.spacingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Send me a message',
                style: textTheme.titleLarge,
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: DesignConstants.spacingLarge),

              // Name Field
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: DesignConstants.spacingMedium),

              // Email Field
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!controller.isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: DesignConstants.spacingMedium),

              // Subject Field
              TextFormField(
                controller: controller.subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  hintText: 'What is this about?',
                  prefixIcon: Icon(Icons.subject_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 500.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: DesignConstants.spacingMedium),

              // Message Field
              TextFormField(
                controller: controller.messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Tell me about your project...',
                  prefixIcon: Icon(Icons.message_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your message';
                  }
                  if (value.trim().length < 10) {
                    return 'Message must be at least 10 characters';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: DesignConstants.spacingLarge),

              // Success/Error Messages
              Obx(() {
                if (controller.successMessage.value.isNotEmpty) {
                  return Container(
                    padding:
                        const EdgeInsets.all(DesignConstants.spacingMedium),
                    margin: const EdgeInsets.only(
                        bottom: DesignConstants.spacingMedium),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(((0.1) * 255).toInt()),
                      borderRadius: BorderRadius.circular(
                          DesignConstants.borderRadiusMedium),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: DesignConstants.spacingSmall),
                        Expanded(
                          child: Text(
                            controller.successMessage.value,
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().shake();
                } else if (controller.errorMessage.value.isNotEmpty) {
                  return Container(
                    padding:
                        const EdgeInsets.all(DesignConstants.spacingMedium),
                    margin: const EdgeInsets.only(
                        bottom: DesignConstants.spacingMedium),
                    decoration: BoxDecoration(
                      color: colorScheme.error.withAlpha(((0.1) * 255).toInt()),
                      borderRadius: BorderRadius.circular(
                          DesignConstants.borderRadiusMedium),
                      border: Border.all(color: colorScheme.error),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: colorScheme.error),
                        const SizedBox(width: DesignConstants.spacingSmall),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().shake();
                }
                return const SizedBox.shrink();
              }),

              // Submit Button
              Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await controller.submitForm();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : const Text('Send Message'),
                      ))
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 700.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  /// Build footer
  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 768;
    final currentYear = DateTime.now().year;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? DesignConstants.spacingMedium
            : DesignConstants.spacingXLarge,
        vertical: DesignConstants.spacingLarge,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(((0.5) * 255).toInt()),
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withAlpha(((0.2) * 255).toInt()),
            width: 1,
          ),
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: isMobile
            ? Column(
                children: [
                  _buildQuickLinks(context),
                  const SizedBox(height: DesignConstants.spacingMedium),
                  _buildCopyright(context, currentYear),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCopyright(context, currentYear),
                  _buildQuickLinks(context),
                ],
              ),
      ),
    );
  }

  Widget _buildCopyright(BuildContext context, int year) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Text(
      '© $year Harsh Sureja. All rights reserved.',
      style: textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final links = [
      {'label': 'About', 'url': '#about'},
      {'label': 'Experience', 'url': '#experience'},
      {'label': 'Projects', 'url': '#projects'},
      {'label': 'Skills', 'url': '#skills'},
    ];

    return Wrap(
      spacing: isMobile
          ? DesignConstants.spacingSmall
          : DesignConstants.spacingMedium,
      runSpacing: DesignConstants.spacingSmall,
      alignment: WrapAlignment.center,
      children: links.map((link) {
        return TextButton(
          onPressed: () {
            // TODO: Implement navigation to sections
            debugPrint('Navigate to ${link['url']}');
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(0, 32),
            padding: const EdgeInsets.symmetric(
              horizontal: DesignConstants.spacingSmall,
            ),
          ),
          child: Text(
            link['label']!,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

/// Contact information item widget
class _ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ContactInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: DesignConstants.spacingSmall,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignConstants.spacingSmall),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius:
                    BorderRadius.circular(DesignConstants.borderRadiusSmall),
              ),
              child: Icon(
                icon,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: DesignConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

/// Animated social media icon button
class _SocialIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String url;
  final Duration delay;

  const _SocialIconButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.url,
    this.delay = Duration.zero,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(DesignConstants.spacingSmall),
          decoration: BoxDecoration(
            color: _isHovering
                ? widget.color.withAlpha(((0.1) * 255).toInt())
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius:
                BorderRadius.circular(DesignConstants.borderRadiusSmall),
            border: Border.all(
              color: _isHovering ? widget.color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: _isHovering ? widget.color : theme.colorScheme.onSurface,
                size: 24,
              )
                  .animate(
                    target: _isHovering ? 1 : 0,
                  )
                  .rotate(
                    begin: 0,
                    end: 0.1,
                    duration: 300.ms,
                  )
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                    duration: 300.ms,
                  ),
              const SizedBox(width: DesignConstants.spacingSmall),
              Text(
                widget.label,
                style: textTheme.labelLarge?.copyWith(
                  color:
                      _isHovering ? widget.color : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: widget.delay)
            .slideX(begin: -0.2, end: 0),
      ),
    );
  }
}
