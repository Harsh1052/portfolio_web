import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../content/data/models/portfolio_content.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.contact});

  final ContactInfo contact;

  @override
  Widget build(BuildContext context) {
    return ContentWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionDivider(),
            const SizedBox(height: 64),
            Semantics(
              header: true,
              child: Text('Contact', style: AppTextStyles.h2),
            ),
            const SizedBox(height: 40),
            _CopyEmail(email: contact.email),
            const SizedBox(height: 32),
            _ContactLink(label: 'LinkedIn', url: contact.linkedinUrl),
            const SizedBox(height: 12),
            _ContactLink(label: 'GitHub', url: contact.githubUrl),
            const SizedBox(height: 12),
            _ContactLink(label: 'Medium', url: contact.mediumUrl),
          ],
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.border, thickness: 1, height: 1);
  }
}

/// Email address as plain text. Clicking copies to clipboard and briefly
/// shows a checkmark to confirm.
class _CopyEmail extends StatefulWidget {
  const _CopyEmail({required this.email});

  final String email;

  @override
  State<_CopyEmail> createState() => _CopyEmailState();
}

class _CopyEmailState extends State<_CopyEmail> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.email));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Email address ${widget.email}. Activate to copy.',
      button: true,
      child: InkWell(
        onTap: _copy,
        mouseCursor: SystemMouseCursors.click,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.email, style: AppTextStyles.body),
              const SizedBox(width: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  _copied
                      ? 'assets/icons/check.svg'
                      : 'assets/icons/copy.svg',
                  key: ValueKey(_copied),
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    _copied ? AppColors.accent : AppColors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class _ContactLink extends StatefulWidget {
  const _ContactLink({required this.label, required this.url});

  final String label;
  final String url;

  @override
  State<_ContactLink> createState() => _ContactLinkState();
}

class _ContactLinkState extends State<_ContactLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: '${widget.label} — opens in new tab',
      child: InkWell(
        onTap: () => launchUrl(
          Uri.parse(widget.url),
          mode: LaunchMode.externalApplication,
        ),
        onHover: (v) => setState(() => _hovered = v),
        mouseCursor: SystemMouseCursors.click,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Text(
          '${widget.label} →',
          style: AppTextStyles.body.copyWith(
            color: _hovered ? AppColors.accent : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
