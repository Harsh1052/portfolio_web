import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../content/data/models/portfolio_content.dart';
import 'project_card.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({super.key, required this.projects});

  final List<ProjectContent> projects;

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder OUTSIDE ContentWrapper so we read actual screen width.
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= Breakpoints.tablet;
        return ContentWrapper(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Theme.of(context).dividerColor,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 64),
                Semantics(
                  header: true,
                  child: Text('Selected work', style: AppTextStyles.h2),
                ),
                const SizedBox(height: 40),
                _ProjectGrid(projects: projects, isDesktop: isDesktop),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid({
    required this.projects,
    required this.isDesktop,
  });

  final List<ProjectContent> projects;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return Column(
        children: [
          for (int i = 0; i < projects.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            FadeSlideIn(
              delay: Duration(milliseconds: i * 100),
              child: ProjectCard(project: projects[i]),
            ),
          ],
        ],
      );
    }

    // 2-column grid: pair cards into rows of 2
    final rows = <Widget>[];
    for (int i = 0; i < projects.length; i += 2) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 16));
      rows.add(
        FadeSlideIn(
          delay: Duration(milliseconds: (i ~/ 2) * 120),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: ProjectCard(project: projects[i])),
              const SizedBox(width: 16),
              if (i + 1 < projects.length)
                Expanded(child: ProjectCard(project: projects[i + 1]))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}
