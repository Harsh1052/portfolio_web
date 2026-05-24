import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../content/data/models/portfolio_content.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key, required this.about});

  final AboutContent about;

  @override
  Widget build(BuildContext context) {
    final paragraphs = about.prose.split('\n\n');

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
              child: Text('About', style: AppTextStyles.h2),
            ),
            const SizedBox(height: 40),
            for (int i = 0; i < paragraphs.length; i++) ...[
              if (i > 0) const SizedBox(height: 20),
              ConstrainedBox(
                // 65ch ≈ 65 × ~9px average char width ≈ 585px
                constraints: const BoxConstraints(maxWidth: 585),
                child: Text(
                  paragraphs[i],
                  style: AppTextStyles.body,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Subtle horizontal rule used between sections.
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.border,
      thickness: 1,
      height: 1,
    );
  }
}
