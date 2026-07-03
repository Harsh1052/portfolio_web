import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/tour_controller.dart';

/// Full-screen overlay that dims the page and cuts out a spotlight rectangle
/// over the active tour step's widget. A glassmorphic info card appears near
/// the spotlight with step title, description, and navigation buttons.
class TourOverlay extends StatelessWidget {
  const TourOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TourController>();

    return Obx(() {
      if (!controller.isActive.value) return const SizedBox.shrink();

      final rect = controller.spotlightRect.value;
      final step = controller.currentStep;
      final stepIndex = controller.currentStepIndex.value;
      final totalSteps = controller.totalSteps;

      return Stack(
        children: [
          // ── Dark overlay with spotlight cutout ──
          Positioned.fill(
            child: GestureDetector(
              onTap: controller.endTour,
              child: TweenAnimationBuilder<Rect?>(
                tween: _RectTween(begin: rect, end: rect),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubic,
                builder: (context, animatedRect, _) {
                  return CustomPaint(
                    painter: _SpotlightPainter(
                      spotlightRect: animatedRect,
                    ),
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ),
          ),

          // ── Info Card ──
          if (rect != null && step != null)
            _buildInfoCard(
              context: context,
              rect: rect,
              step: step,
              stepIndex: stepIndex,
              totalSteps: totalSteps,
              controller: controller,
            ),
        ],
      );
    });
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required Rect rect,
    required TourStep step,
    required int stepIndex,
    required int totalSteps,
    required TourController controller,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const cardWidth = 340.0;
    const cardMargin = 16.0;

    // Determine horizontal position — align to center of spotlight,
    // but clamp within screen bounds.
    double left = rect.center.dx - cardWidth / 2;
    left = left.clamp(cardMargin, screenSize.width - cardWidth - cardMargin);

    // Determine vertical position — prefer below the spotlight.
    // If not enough room below, place above.
    final spaceBelow = screenSize.height - rect.bottom;
    final spaceAbove = rect.top;
    final placeBelow = spaceBelow > 220;

    double top;
    if (placeBelow) {
      top = rect.bottom + cardMargin;
    } else if (spaceAbove > 220) {
      top = rect.top - 220 - cardMargin;
    } else {
      // Fallback: center on screen
      top = screenSize.height / 2 - 110;
    }

    return Positioned(
      left: left,
      top: top,
      width: cardWidth,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 16 * (1 - value)),
              child: child,
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step indicator + icon
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          step.icon,
                          size: 18,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          step.title,
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    step.description,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      height: 1.5,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Progress dots + navigation buttons
                  Row(
                    children: [
                      // Progress dots
                      ...List.generate(totalSteps, (i) {
                        final isCurrentDot = i == stepIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 6),
                          width: isCurrentDot ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isCurrentDot
                                ? AppColors.accent
                                : AppColors.accent.withValues(alpha: 0.25),
                          ),
                        );
                      }),

                      const Spacer(),

                      // Skip button
                      _TourTextButton(
                        label: 'Skip',
                        onTap: controller.endTour,
                      ),
                      const SizedBox(width: 8),

                      // Back button
                      if (stepIndex > 0) ...[
                        _TourTextButton(
                          label: 'Back',
                          onTap: controller.prevStep,
                        ),
                        const SizedBox(width: 8),
                      ],

                      // Next / Finish button
                      _TourPrimaryButton(
                        label:
                            stepIndex == totalSteps - 1 ? 'Finish' : 'Next',
                        onTap: controller.nextStep,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Spotlight Painter ─────────────────────────────────────────────────────────

class _SpotlightPainter extends CustomPainter {
  final Rect? spotlightRect;

  _SpotlightPainter({this.spotlightRect});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.55);

    // Save layer for blend-mode cutout.
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // Draw full-screen dark overlay.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      overlayPaint,
    );

    // Cut out the spotlight rectangle with rounded corners.
    if (spotlightRect != null) {
      final clearPaint = Paint()..blendMode = BlendMode.clear;
      final rRect = RRect.fromRectAndRadius(
        spotlightRect!,
        const Radius.circular(12),
      );
      canvas.drawRRect(rRect, clearPaint);
    }

    canvas.restore();

    // Draw a subtle glowing border around the spotlight.
    if (spotlightRect != null) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = AppColors.accent.withValues(alpha: 0.6);
      final rRect = RRect.fromRectAndRadius(
        spotlightRect!,
        const Radius.circular(12),
      );
      canvas.drawRRect(rRect, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.spotlightRect != spotlightRect;
  }
}

// ─── Tween for Rect? ──────────────────────────────────────────────────────────

class _RectTween extends Tween<Rect?> {
  _RectTween({super.begin, super.end});

  @override
  Rect? lerp(double t) {
    if (begin == null && end == null) return null;
    if (begin == null) return end;
    if (end == null) return begin;
    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, t)!,
      lerpDouble(begin!.top, end!.top, t)!,
      lerpDouble(begin!.right, end!.right, t)!,
      lerpDouble(begin!.bottom, end!.bottom, t)!,
    );
  }
}

double? lerpDouble(double a, double b, double t) => a + (b - a) * t;

// ─── Button widgets ────────────────────────────────────────────────────────────

class _TourTextButton extends StatefulWidget {
  const _TourTextButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_TourTextButton> createState() => _TourTextButtonState();
}

class _TourTextButtonState extends State<_TourTextButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTextStyles.caption.copyWith(
            color: _hovered
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _TourPrimaryButton extends StatefulWidget {
  const _TourPrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_TourPrimaryButton> createState() => _TourPrimaryButtonState();
}

class _TourPrimaryButtonState extends State<_TourPrimaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accent
                : AppColors.accent.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(8),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
