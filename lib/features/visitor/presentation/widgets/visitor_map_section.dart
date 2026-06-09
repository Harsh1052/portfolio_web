import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../controllers/visitor_controller.dart';
import 'visitor_map_painter.dart';

class VisitorMapSection extends StatefulWidget {
  const VisitorMapSection({super.key});

  @override
  State<VisitorMapSection> createState() => _VisitorMapSectionState();
}

class _VisitorMapSectionState extends State<VisitorMapSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<VisitorController>()) {
      return const SizedBox.shrink();
    }

    final controller = Get.find<VisitorController>();

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
                child: Text('Global Connection', style: AppTextStyles.h2),
              ),
            ),
            const SizedBox(height: 8),
            FadeSlideIn(
              delay: const Duration(milliseconds: 80),
              child: Text(
                'Live geospatial telemetry of recruiters and developers visiting this portfolio.',
                style: AppTextStyles.caption,
              ),
            ),
            const SizedBox(height: 40),
            Obx(() {
              if (controller.status.value == VisitorStatus.loading) {
                return _MapPlaceholder();
              }

              final recentLocations = controller.locations;

              return FadeSlideIn(
                delay: const Duration(milliseconds: 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Glassmorphic Map Container with locked aspect ratio
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: AspectRatio(
                              aspectRatio: 784.077 / 458.627,
                              child: Stack(
                                children: [
                                  // Sleek Vector World Map Background
                                  Positioned.fill(
                                    child: SvgPicture.asset(
                                      'assets/icons/world-map.svg',
                                      fit: BoxFit.fill,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.textSecondary.withValues(alpha: 0.15),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  // High-tech pulsing coordinates overlay
                                  Positioned.fill(
                                    child: AnimatedBuilder(
                                      animation: _pulseController,
                                      builder: (context, child) {
                                        return CustomPaint(
                                          painter: VisitorMapPainter(
                                            locations: recentLocations,
                                            pulseValue: _pulseController.value,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (recentLocations.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      // Recent visitors telemetry footer log
                      _RecentVisitorsTicker(locations: recentLocations),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _RecentVisitorsTicker extends StatelessWidget {
  const _RecentVisitorsTicker({required this.locations});

  final List<dynamic> locations;

  @override
  Widget build(BuildContext context) {
    // Take last 3 visitors
    final displayed = locations.take(3).toList();

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.start,
      children: [
        for (int i = 0; i < displayed.length; i++) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == 0 ? AppColors.accent : AppColors.textSecondary.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${displayed[i].city}, ${displayed[i].country}',
                  style: AppTextStyles.tag.copyWith(
                    color: i == 0 ? AppColors.textPrimary : AppColors.textSecondary,
                    fontWeight: i == 0 ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}
