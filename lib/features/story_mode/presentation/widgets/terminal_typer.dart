import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/terminal_theme.dart';

class TerminalTyper extends StatelessWidget {
  final String text;
  final Duration speed;
  final VoidCallback? onFinished;

  const TerminalTyper({
    super.key,
    required this.text,
    this.speed = const Duration(milliseconds: 50),
    this.onFinished,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      isRepeatingAnimation: false,
      onFinished: onFinished,
      displayFullTextOnTap: true,
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          textStyle: TerminalTheme.terminalText,
          speed: speed,
          cursor: '█',
          curve: Curves.linear,
        ),
      ],
    );
  }
}
