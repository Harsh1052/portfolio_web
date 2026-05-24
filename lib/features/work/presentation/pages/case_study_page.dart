import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/routing/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../content/data/models/portfolio_content.dart';
import '../../../content/presentation/controllers/content_controller.dart';

class CaseStudyPage extends StatelessWidget {
  const CaseStudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final slug = Get.parameters['slug'] ?? '';
    final controller = Get.find<ContentController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Obx(() {
        final content = controller.content.value;
        if (content == null) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppColors.accent,
              ),
            ),
          );
        }

        final project =
            content.projects.firstWhereOrNull((p) => p.slug == slug);
        if (project == null) {
          return _NotFound(slug: slug);
        }

        return _CaseStudyScroll(project: project);
      }),
    );
  }
}

// ─── Page not found ──────────────────────────────────────────────────────────

class _NotFound extends StatelessWidget {
  const _NotFound({required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Project not found: $slug', style: AppTextStyles.body),
          const SizedBox(height: 16),
          _BackLink(),
        ],
      ),
    );
  }
}

// ─── Scrollable page ─────────────────────────────────────────────────────────

class _CaseStudyScroll extends StatelessWidget {
  const _CaseStudyScroll({required this.project});
  final ProjectContent project;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CaseStudyHeader(project: project),
          if (project.caseStudy != null)
            _CaseStudyBody(
              project: project,
              cs: project.caseStudy!,
            )
          else
            _NoContent(project: project),
          const _CaseStudyFooter(),
        ],
      ),
    );
  }
}

// ─── Header: title + summary + metadata ──────────────────────────────────────

class _CaseStudyHeader extends StatelessWidget {
  const _CaseStudyHeader({required this.project});
  final ProjectContent project;

  @override
  Widget build(BuildContext context) {
    final cs = project.caseStudy;
    return ContentWrapper(
      maxWidth: 720,
      child: Padding(
        padding: const EdgeInsets.only(top: 80, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(project.name, style: AppTextStyles.h2),
            ),
            if (cs != null) ...[
              const SizedBox(height: 12),
              Text(
                cs.summary,
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              _MetadataBar(cs: cs),
            ] else ...[
              const SizedBox(height: 12),
              Text(
                project.description,
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 48),
            const Divider(color: AppColors.border, thickness: 1, height: 1),
          ],
        ),
      ),
    );
  }
}

class _MetadataBar extends StatelessWidget {
  const _MetadataBar({required this.cs});
  final CaseStudyContent cs;

  @override
  Widget build(BuildContext context) {
    final parts = [cs.role, cs.timeline, cs.stack];
    return Wrap(
      spacing: 0,
      runSpacing: 4,
      children: [
        for (int i = 0; i < parts.length; i++) ...[
          if (i > 0)
            Text(' · ', style: AppTextStyles.caption),
          Text(parts[i], style: AppTextStyles.caption),
        ],
      ],
    );
  }
}

// ─── Main body ───────────────────────────────────────────────────────────────

class _CaseStudyBody extends StatelessWidget {
  const _CaseStudyBody({required this.project, required this.cs});
  final ProjectContent project;
  final CaseStudyContent cs;

  @override
  Widget build(BuildContext context) {
    return ContentWrapper(
      maxWidth: 720,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(heading: 'The problem', prose: cs.problem),
            const SizedBox(height: 56),
            _Section(heading: 'The approach', prose: cs.approach),
            const SizedBox(height: 56),
            _Section(heading: 'What was hard', prose: cs.whatWasHard),
            const SizedBox(height: 56),
            _OutcomesSection(outcomes: cs.outcomes),
            const SizedBox(height: 56),
            _Section(
              heading: "What I'd do differently",
              prose: cs.whatIdDoDifferently,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Individual section ───────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.heading, required this.prose});
  final String heading;
  final String prose;

  @override
  Widget build(BuildContext context) {
    final paragraphs = prose.split('\n\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: AppTextStyles.caseSectionHeading),
        const SizedBox(height: 16),
        for (int i = 0; i < paragraphs.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 585),
            child: Text(paragraphs[i], style: AppTextStyles.body),
          ),
        ],
      ],
    );
  }
}

// ─── Outcomes (bulleted) ──────────────────────────────────────────────────────

class _OutcomesSection extends StatelessWidget {
  const _OutcomesSection({required this.outcomes});
  final List<String> outcomes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Outcomes', style: AppTextStyles.caseSectionHeading),
        const SizedBox(height: 16),
        for (final outcome in outcomes) ...[
          _BulletItem(text: outcome),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 585),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '· ',
            style: AppTextStyles.body.copyWith(color: AppColors.accent),
          ),
          Expanded(
            child: Text(text, style: AppTextStyles.body),
          ),
        ],
      ),
    );
  }
}

// ─── No case study yet (NUG) ─────────────────────────────────────────────────

class _NoContent extends StatelessWidget {
  const _NoContent({required this.project});
  final ProjectContent project;

  @override
  Widget build(BuildContext context) {
    return ContentWrapper(
      maxWidth: 720,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Text(
          'Full case study coming soon.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

// ─── Footer: back link + next project ────────────────────────────────────────

class _CaseStudyFooter extends StatelessWidget {
  const _CaseStudyFooter();

  @override
  Widget build(BuildContext context) {
    return ContentWrapper(
      maxWidth: 720,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: AppColors.border, thickness: 1, height: 1),
            const SizedBox(height: 32),
            _BackLink(),
          ],
        ),
      ),
    );
  }
}

// ─── Back link ────────────────────────────────────────────────────────────────

class _BackLink extends StatefulWidget {
  @override
  State<_BackLink> createState() => _BackLinkState();
}

class _BackLinkState extends State<_BackLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: 'Back to selected work',
      child: InkWell(
        onTap: () {
          if (Get.previousRoute.isNotEmpty) {
            Get.back();
          } else {
            Get.offAllNamed(AppRoutes.home);
          }
        },
        onHover: (v) => setState(() => _hovered = v),
        mouseCursor: SystemMouseCursors.click,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Text(
          '← Back to work',
          style: AppTextStyles.body.copyWith(
            color: _hovered ? AppColors.accent : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ─── External link helper ─────────────────────────────────────────────────────

// ignore: unused_element
Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
