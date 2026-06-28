import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

/// A premium animated Sun ↔ Moon toggle button.
///
/// Uses [AnimatedSwitcher] with a combined rotation + scale + fade transition
/// so the icon morphs smoothly between the two states.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();

    return Obx(() {
      final isDark = controller.isDark;

      return Tooltip(
        message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
        child: _HoverButton(
          onTap: controller.toggle,
          isDark: isDark,
        ),
      );
    });
  }
}

class _HoverButton extends StatefulWidget {
  const _HoverButton({required this.onTap, required this.isDark});

  final VoidCallback onTap;
  final bool isDark;

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _hovered = false;

  void _handleTap() {
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark
        ? AppColors.borderDark
        : (_hovered ? AppColors.border : Colors.transparent);
    final iconColor = isDark ? AppColors.textPrimaryDark : AppColors.textSecondary;
    final hoverIconColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark
                  ? AppColors.borderDark
                  : (_hovered ? AppColors.border : Colors.transparent),
              width: 1,
            ),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                final rotate =
                    Tween<double>(begin: -0.5, end: 0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                );
                return RotationTransition(
                  turns: rotate,
                  child: ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                );
              },
              child: isDark
                  ? Icon(
                      Icons.wb_sunny_rounded,
                      key: const ValueKey('sun'),
                      size: 18,
                      color: _hovered ? hoverIconColor : iconColor,
                    )
                  : Icon(
                      Icons.dark_mode_rounded,
                      key: const ValueKey('moon'),
                      size: 18,
                      color: _hovered ? hoverIconColor : iconColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
