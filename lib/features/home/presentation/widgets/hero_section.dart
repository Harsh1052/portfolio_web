import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../content/data/models/portfolio_content.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.content});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < Breakpoints.mobile;
        return ContentWrapper(
          child: Padding(
            padding: EdgeInsets.only(
              top: isMobile ? 64 : 96,
              bottom: isMobile ? 64 : 96,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GradientName(isMobile: isMobile),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 580),
                  child: Text(
                    content.tagline,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                _HeroActions(contact: content.contact),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GradientName extends StatelessWidget {
  const _GradientName({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final style = isMobile ? AppTextStyles.h1Mobile : AppTextStyles.h1;
    return Semantics(
      header: true,
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: AppColors.nameGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: Text(
          'Harsh Sureja',
          // White is required — ShaderMask replaces the color via srcIn blend.
          style: style.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _HeroActions extends StatelessWidget {
  const _HeroActions({required this.contact});

  final ContactInfo contact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _IconLink(
          asset: 'assets/icons/github.svg',
          url: contact.githubUrl,
          semanticsLabel: 'GitHub profile',
        ),
        _IconLink(
          asset: 'assets/icons/linkedin.svg',
          url: contact.linkedinUrl,
          semanticsLabel: 'LinkedIn profile',
        ),
        _IconLink(
          asset: 'assets/icons/email.svg',
          url: 'mailto:${contact.email}',
          semanticsLabel: 'Send email to ${contact.email}',
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => launchUrl(
            Uri.parse(contact.resumeUrl),
            mode: LaunchMode.externalApplication,
          ),
          child: const Text('Download Resume'),
        ),
      ],
    );
  }
}

class _IconLink extends StatefulWidget {
  const _IconLink({
    required this.asset,
    required this.url,
    required this.semanticsLabel,
  });

  final String asset;
  final String url;
  final String semanticsLabel;

  @override
  State<_IconLink> createState() => _IconLinkState();
}

class _IconLinkState extends State<_IconLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticsLabel,
      button: true,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        onHover: (v) => setState(() => _hovered = v),
        mouseCursor: SystemMouseCursors.click,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            widget.asset,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              _hovered ? AppColors.textPrimary : AppColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
