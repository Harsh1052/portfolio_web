import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../controllers/github_stats_controller.dart';
import 'contribution_graph.dart';

/// Full page section that displays GitHub contribution stats + heatmap.
/// Lazy-guards itself: renders nothing if the controller isn't registered.
class ContributionGraphSection extends StatelessWidget {
  const ContributionGraphSection({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<GitHubStatsController>()) {
      return const SizedBox.shrink();
    }

    final controller = Get.find<GitHubStatsController>();

    return ContentWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: AppColors.border, thickness: 1, height: 1),
            const SizedBox(height: 64),
            FadeSlideIn(
              child: Semantics(
                header: true,
                child: Text('GitHub Activity', style: AppTextStyles.h2),
              ),
            ),
            const SizedBox(height: 40),
            Obx(() {
              final status = controller.status.value;
              switch (status) {
                case GitHubStatus.loading:
                case GitHubStatus.initial:
                  return _LoadingPlaceholder();

                case GitHubStatus.error:
                  return _ErrorView(onRetry: controller.refresh);

                case GitHubStatus.loaded:
                  final stats = controller.stats.value;
                  return FadeSlideIn(
                    delay: const Duration(milliseconds: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StatsRow(stats: stats),
                        const SizedBox(height: 24),
                        ContributionGraph(stats: stats),
                        const SizedBox(height: 12),
                        _GraphLegend(),
                      ],
                    ),
                  );
              }
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Stats Row ──────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final dynamic stats; // GitHubStats

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 40,
      runSpacing: 16,
      children: [
        _StatChip(
          value: '${stats.totalContributions}',
          label: 'contributions\nthis year',
        ),
        _StatChip(
          value: '${stats.currentStreak}',
          label: 'day current\nstreak',
        ),
        _StatChip(
          value: '${stats.longestStreak}',
          label: 'day longest\nstreak',
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTextStyles.h3),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

// ─── Legend ─────────────────────────────────────────────────────────────────

class _GraphLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFFEBEDF0),
      Color(0xFF9BE9A8),
      Color(0xFF40C463),
      Color(0xFF30A14E),
      Color(0xFF216E39),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Less', style: AppTextStyles.caption),
        const SizedBox(width: 6),
        for (final color in colors) ...[
          Container(
            width: 11,
            height: 11,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
        const SizedBox(width: 4),
        Text('More', style: AppTextStyles.caption),
      ],
    );
  }
}

// ─── Loading ────────────────────────────────────────────────────────────────

class _LoadingPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SkeletonBlock(width: 280, height: 52),
        const SizedBox(height: 24),
        // Simulate graph rows
        for (int i = 0; i < 7; i++) ...[
          if (i > 0) const SizedBox(height: 2),
          const _SkeletonBlock(width: double.infinity, height: 11),
        ],
      ],
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ─── Error ───────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Could not load GitHub activity.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onRetry,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            foregroundColor: AppColors.accent,
            textStyle: AppTextStyles.link,
          ),
          child: const Text('Try again →'),
        ),
      ],
    );
  }
}
