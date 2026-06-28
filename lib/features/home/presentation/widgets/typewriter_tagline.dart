import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Cycles through a list of [roles] with a typewriter animation.
///
/// Each role is typed character by character, held for [pauseDuration],
/// then deleted. The cursor blinks at 530ms intervals while idle.
class TypewriterTagline extends StatefulWidget {
  const TypewriterTagline({super.key});

  /// The roles to cycle through.
  static const List<String> roles = [
    'Flutter Developer.',
    'Mobile Architect.',
    'Open Source Contributor.',
    'Clean Code Advocate.',
    'Problem Solver.',
  ];

  @override
  State<TypewriterTagline> createState() => _TypewriterTaglineState();
}

class _TypewriterTaglineState extends State<TypewriterTagline> {
  String _displayText = '';
  bool _cursorVisible = true;

  int _roleIndex = 0;
  bool _isTyping = true;

  Timer? _typeTimer;
  Timer? _cursorTimer;

  // Timings
  static const _typeInterval = Duration(milliseconds: 60);
  static const _deleteInterval = Duration(milliseconds: 35);
  static const _pauseAfterTyped = Duration(milliseconds: 1800);
  static const _pauseAfterDeleted = Duration(milliseconds: 400);
  static const _cursorBlinkInterval = Duration(milliseconds: 530);

  @override
  void initState() {
    super.initState();
    _startCursorBlink();
    // Small initial delay so it doesn't fire immediately on mount.
    Future<void>.delayed(const Duration(milliseconds: 400), _runLoop);
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(_cursorBlinkInterval, (_) {
      if (mounted) setState(() => _cursorVisible = !_cursorVisible);
    });
  }

  void _runLoop() {
    if (!mounted) return;

    final target = TypewriterTagline.roles[_roleIndex];

    if (_isTyping) {
      if (_displayText.length < target.length) {
        // Type next character.
        _typeTimer = Timer(_typeInterval, () {
          if (mounted) {
            setState(
              () => _displayText = target.substring(0, _displayText.length + 1),
            );
            _runLoop();
          }
        });
      } else {
        // Finished typing — pause, then switch to delete mode.
        _typeTimer = Timer(_pauseAfterTyped, () {
          if (mounted) {
            _isTyping = false;
            _runLoop();
          }
        });
      }
    } else {
      if (_displayText.isNotEmpty) {
        // Delete last character.
        _typeTimer = Timer(_deleteInterval, () {
          if (mounted) {
            setState(
              () => _displayText =
                  _displayText.substring(0, _displayText.length - 1),
            );
            _runLoop();
          }
        });
      } else {
        // Finished deleting — move to next role.
        _typeTimer = Timer(_pauseAfterDeleted, () {
          if (mounted) {
            _roleIndex = (_roleIndex + 1) % TypewriterTagline.roles.length;
            _isTyping = true;
            _runLoop();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 580),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: _displayText.isEmpty ? '\u200B' : _displayText,
              style: AppTextStyles.body.copyWith(
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: AnimatedOpacity(
                opacity: _cursorVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: 2,
                  height: 18,
                  margin: const EdgeInsets.only(left: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
