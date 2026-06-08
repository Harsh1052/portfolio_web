import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/now_entry.dart';

/// A single status card in the "Now" section.
///
/// Shows an [emoji], a muted [label] (category), and the primary [value]
/// with an optional [subValue] below it.
class NowStatusCard extends StatelessWidget {
  const NowStatusCard({super.key, required this.entry});

  final NowEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                entry.emoji,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                entry.label,
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            entry.value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          if (entry.subValue != null) ...[
            const SizedBox(height: 4),
            Text(
              entry.subValue!,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A small pulsing green dot indicating the section is live / current.
///
/// Uses two stacked AnimatedContainers:
///   — outer ring: expands + fades out in a repeating loop
///   — inner dot:  solid, never animates
class _LivePulseDot extends StatefulWidget {
  const _LivePulseDot();

  @override
  State<_LivePulseDot> createState() => _LivePulseDotState();
}

class _LivePulseDotState extends State<_LivePulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _scale = Tween<double>(begin: 1.0, end: 2.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.7, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color dotColor = Color(0xFF22C55E); // green-500
    const double dotSize = 8;

    return SizedBox(
      width: dotSize * 2.6,
      height: dotSize * 2.6,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Expanding ring
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Transform.scale(
              scale: _scale.value,
              child: Opacity(
                opacity: _opacity.value,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: const BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // Solid center dot
          Container(
            width: dotSize,
            height: dotSize,
            decoration: const BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

/// Row label for the "Now" section heading — includes the live pulse dot.
class NowSectionHeadingRow extends StatelessWidget {
  const NowSectionHeadingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Semantics(
          header: true,
          child: Text('Now', style: AppTextStyles.h2),
        ),
        const SizedBox(width: 14),
        const _LivePulseDot(),
      ],
    );
  }
}
