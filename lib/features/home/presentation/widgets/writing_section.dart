import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../content/data/models/portfolio_content.dart';

class WritingSection extends StatelessWidget {
  const WritingSection({super.key, required this.articles});

  final List<ArticleContent> articles;

  @override
  Widget build(BuildContext context) {
    if (articles.length < 2) return const SizedBox.shrink();

    return ContentWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: AppColors.border, thickness: 1, height: 1),
            const SizedBox(height: 64),
            Semantics(
              header: true,
              child: Text('Writing', style: AppTextStyles.h2),
            ),
            const SizedBox(height: 40),
            for (int i = 0; i < articles.length; i++) ...[
              if (i > 0) const SizedBox(height: 40),
              FadeSlideIn(
                delay: Duration(milliseconds: i * 100),
                child: _ArticleRow(article: articles[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ArticleRow extends StatefulWidget {
  const _ArticleRow({required this.article});
  final ArticleContent article;

  @override
  State<_ArticleRow> createState() => _ArticleRowState();
}

class _ArticleRowState extends State<_ArticleRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.article;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(a.title, style: AppTextStyles.h3),
            ),
            const SizedBox(width: 16),
            Text(a.publishedDate, style: AppTextStyles.caption),
          ],
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 585),
          child: Text(
            a.summary,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 12),
        Semantics(
          link: true,
          label: 'Read "${a.title}" on Medium — opens in new tab',
          child: InkWell(
            onTap: () => launchUrl(
              Uri.parse(a.url),
              mode: LaunchMode.externalApplication,
            ),
            onHover: (v) => setState(() => _hovered = v),
            mouseCursor: SystemMouseCursors.click,
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            child: Text(
              'Read on Medium →',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                color: _hovered ? AppColors.accent : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
