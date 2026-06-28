import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routing/app_pages.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../content/data/models/portfolio_content.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project});

  final ProjectContent project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  void _navigate() {
    Get.toNamed(
      AppRoutes.caseStudy.replaceFirst(':slug', widget.project.slug),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: 'Project: ${p.name}. Activate to read case study.',
      child: InkWell(
        onTap: _navigate,
        onHover: (v) => setState(() => _hovered = v),
        mouseCursor: SystemMouseCursors.click,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hovered
                    ? (isDark ? const Color(0xFF4B5563) : const Color(0xFFB0B0B0))
                    : cs.outline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: AppTextStyles.h3),
                if (p.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: AppTextStyles.body.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
                if (p.metrics.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 20,
                    runSpacing: 4,
                    children: p.metrics
                        .map((m) => Text(m, style: AppTextStyles.metric))
                        .toList(),
                  ),
                ],
                if (p.techTags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: p.techTags
                        .take(3)
                        .map((t) => _TechTag(label: t))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 24),
                Text('Read case study →', style: AppTextStyles.link),
              ],
            ),
          ),
        ),
    );
  }
}

class _TechTag extends StatelessWidget {
  const _TechTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: AppTextStyles.tag),
    );
  }
}
