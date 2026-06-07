import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../presentation/controllers/visitor_controller.dart';
import '../../domain/entities/visitor_stats.dart';

/// A subtle, self-contained visitor counter badge.
///
/// Shows a pulsing dot + formatted count.
/// Silently hides itself if [VisitorController] is not registered
/// (e.g. Firebase config missing in dev).
class VisitorCountBadge extends StatelessWidget {
  const VisitorCountBadge({super.key});

  @override
  Widget build(BuildContext context) {
    // Observe the static isReady flag — this rebuilds reactively once
    // VisitorController finishes its async init (Firebase may not be ready
    // when this widget first builds, causing the first-load blank bug).
    return Obx(() {
      if (!VisitorController.isReady.value) return const SizedBox.shrink();

      final controller = Get.find<VisitorController>();
      return Obx(() {
        if (!controller.isLoaded) return const SizedBox.shrink();
        return _Badge(stats: controller.stats.value);
      });
    });
  }
}

class _Badge extends StatefulWidget {
  const _Badge({required this.stats});
  final VisitorStats stats;

  @override
  State<_Badge> createState() => _BadgeState();
}

class _BadgeState extends State<_Badge> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.stats.totalViews;
    final label = _formatCount(count);

    return Semantics(
      label: '$count total portfolio views',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing live dot
          FadeTransition(
            opacity: _opacity,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label views',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M+';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K+';
    return n.toString();
  }
}
