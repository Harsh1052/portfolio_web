import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../visitor/presentation/widgets/visitor_count_badge.dart';
import '../controllers/tour_controller.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentWrapper(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Harsh Sureja · ${DateTime.now().year} · Built in Flutter Web',
                        style: AppTextStyles.caption,
                      ),
                      const _TakeTourLink(),
                    ],
                  ),
                ),
                const VisitorCountBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A small clickable link to replay the guided tour.
class _TakeTourLink extends StatefulWidget {
  const _TakeTourLink();

  @override
  State<_TakeTourLink> createState() => _TakeTourLinkState();
}

class _TakeTourLinkState extends State<_TakeTourLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          if (Get.isRegistered<TourController>()) {
            Get.find<TourController>().startTour();
          }
        },
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTextStyles.caption.copyWith(
            color: _hovered ? AppColors.accent : AppColors.accent.withValues(alpha: 0.6),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.explore_rounded, size: 14, color: AppColors.accent),
              SizedBox(width: 4),
              Text('Take a Tour'),
            ],
          ),
        ),
      ),
    );
  }
}
