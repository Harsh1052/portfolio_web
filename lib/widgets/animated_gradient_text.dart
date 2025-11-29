import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/design_constants.dart';

/// Animated text widget with gradient effects and shimmer animations
/// 
/// This widget creates text with a gradient fill and optional shimmer animation
/// for a premium, modern look.
class AnimatedGradientText extends StatelessWidget {
  /// Text to display
  final String text;

  /// Text style (gradient will be applied on top)
  final TextStyle? style;

  /// Gradient to use for text
  final Gradient gradient;

  /// Whether to enable shimmer animation
  final bool enableShimmer;

  /// Shimmer animation duration
  final Duration shimmerDuration;

  /// Text alignment
  final TextAlign? textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow? overflow;

  const AnimatedGradientText({
    super.key,
    required this.text,
    this.style,
    this.gradient = AppColors.primaryGradient,
    this.enableShimmer = true,
    this.shimmerDuration = const Duration(milliseconds: 2000),
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    Widget textWidget = ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style?.copyWith(color: Colors.white) ??
            const TextStyle(color: Colors.white),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );

    if (enableShimmer) {
      textWidget = textWidget
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
            duration: shimmerDuration,
            color: Colors.white.withOpacity(0.3),
          );
    }

    return textWidget;
  }
}

/// Gradient text without animation (for better performance)
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.gradient = AppColors.primaryGradient,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style?.copyWith(color: Colors.white) ??
            const TextStyle(color: Colors.white),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

/// Animated typing effect with gradient text
class TypewriterGradientText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final Duration typingSpeed;
  final Duration pauseDuration;
  final bool loop;

  const TypewriterGradientText({
    super.key,
    required this.text,
    this.style,
    this.gradient = AppColors.primaryGradient,
    this.typingSpeed = const Duration(milliseconds: 100),
    this.pauseDuration = const Duration(seconds: 2),
    this.loop = true,
  });

  @override
  State<TypewriterGradientText> createState() =>
      _TypewriterGradientTextState();
}

class _TypewriterGradientTextState extends State<TypewriterGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _displayText = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.typingSpeed * widget.text.length,
    );
    _startTyping();
  }

  void _startTyping() async {
    while (mounted) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _currentIndex++;
          _displayText = widget.text.substring(0, _currentIndex);
        });
        await Future.delayed(widget.typingSpeed);
      } else {
        if (widget.loop) {
          await Future.delayed(widget.pauseDuration);
          setState(() {
            _currentIndex = 0;
            _displayText = '';
          });
        } else {
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientText(
      text: _displayText,
      style: widget.style,
      gradient: widget.gradient,
    );
  }
}
