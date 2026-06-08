import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../domain/entities/now_entry.dart';
import '../../domain/repositories/now_repository.dart';
import 'now_status_card.dart';

/// "Now" section — shown between the hero and the work section.
///
/// Displays a compact grid of status cards each describing one facet of
/// what Harsh is doing right now: current role, what he's learning,
/// what he's building, and what he's building toward.
///
/// Data is fetched via dependency injection from [NowRepository].
/// The section heading has a live pulsing green dot to signal recency.
class NowSection extends StatelessWidget {
  const NowSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve NowRepository via DI
    final entries = Get.find<NowRepository>().getEntries();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < Breakpoints.mobile;
        return ContentWrapper(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: AppColors.border,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 64),
                const NowSectionHeadingRow(),
                const SizedBox(height: 40),
                _NowGrid(entries: entries, isMobile: isMobile),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NowGrid extends StatelessWidget {
  const _NowGrid({required this.entries, required this.isMobile});

  final List<NowEntry> entries;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < entries.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            FadeSlideIn(
              delay: Duration(milliseconds: i * 80),
              child: NowStatusCard(entry: entries[i]),
            ),
          ],
        ],
      );
    }

    // 2-column grid on tablet/desktop
    final rows = <Widget>[];
    for (int i = 0; i < entries.length; i += 2) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 12));
      rows.add(
        FadeSlideIn(
          delay: Duration(milliseconds: (i ~/ 2) * 90),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: NowStatusCard(entry: entries[i])),
              const SizedBox(width: 12),
              if (i + 1 < entries.length)
                Expanded(child: NowStatusCard(entry: entries[i + 1]))
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
