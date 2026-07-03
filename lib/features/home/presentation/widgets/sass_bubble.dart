import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/sass_controller.dart';

/// Floating "Sass Bot" — a 🤖 avatar at bottom-left that drops funny
/// chat-bubble messages and eventually shows a "Hire Me" CTA pill.
class SassBubble extends StatelessWidget {
  const SassBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final sass = Get.find<SassController>();

    return Obx(() {
      if (sass.isDismissed.value) return const SizedBox.shrink();

      final message = sass.currentMessage.value;
      final typing = sass.isTyping.value;
      final showHire = sass.showHireButton.value;
      final hasPopup = message != null || typing;

      return Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Chat bubble (typing / message) ──
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: hasPopup
                    ? _ChatCard(
                        key: ValueKey(typing ? '__typing__' : message),
                        message: message,
                        isTyping: typing,
                        onDismiss: sass.dismiss,
                      )
                    : const SizedBox.shrink(key: ValueKey('__empty__')),
              ),
              if (hasPopup) const SizedBox(height: 10),

              // ── Avatar + "Hire Me" button ──
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _BotAvatar(),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    child: showHire
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child:
                                _HireMeButton(onTap: sass.scrollToContact),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ─── Chat Card ──────────────────────────────────────────────────────────────

class _ChatCard extends StatelessWidget {
  const _ChatCard({
    super.key,
    required this.message,
    required this.isTyping,
    required this.onDismiss,
  });

  final String? message;
  final bool isTyping;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withValues(alpha: isDark ? 0.30 : 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: isTyping
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: _TypingDots(),
                        )
                      : Text(
                          message ?? '',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 13.5,
                            height: 1.5,
                            color:
                                Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                ),
                const SizedBox(width: 4),
                _DismissButton(onTap: onDismiss),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Typing Indicator ───────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_ctrl.value + i * 0.25) % 1.0;
            final y = -3.0 * math.sin(phase * math.pi);
            return Transform.translate(
              offset: Offset(0, y),
              child: Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.7),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ─── Dismiss (X) Button ─────────────────────────────────────────────────────

class _DismissButton extends StatefulWidget {
  const _DismissButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_DismissButton> createState() => _DismissButtonState();
}

class _DismissButtonState extends State<_DismissButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: _hovered ? 1.0 : 0.35,
            child: Icon(
              Icons.close_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Bot Avatar ─────────────────────────────────────────────────────────────

class _BotAvatar extends StatefulWidget {
  const _BotAvatar();

  @override
  State<_BotAvatar> createState() => _BotAvatarState();
}

class _BotAvatarState extends State<_BotAvatar> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? AppColors.accent.withValues(alpha: _hovered ? 0.30 : 0.15)
              : AppColors.accent.withValues(alpha: _hovered ? 0.20 : 0.10),
          border: Border.all(
            color:
                AppColors.accent.withValues(alpha: _hovered ? 0.6 : 0.3),
            width: 1.5,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    blurRadius: 14,
                  ),
                ]
              : [],
        ),
        child: const Center(
          child: Text('🤖', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}

// ─── "Hire Me" Pill Button ──────────────────────────────────────────────────

class _HireMeButton extends StatefulWidget {
  const _HireMeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_HireMeButton> createState() => _HireMeButtonState();
}

class _HireMeButtonState extends State<_HireMeButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accent
                : AppColors.accent.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            'Hire Me 🤝',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
