import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/design_constants.dart';

/// Animated background with floating geometric shapes
class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final int particleCount = 20;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      particleCount,
      (index) => AnimationController(
        duration: Duration(
          milliseconds: 3000 + Random().nextInt(4000),
        ),
        vsync: this,
      )..repeat(reverse: true),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: -50 + Random().nextDouble() * 100,
        end: 50 + Random().nextDouble() * 100,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated gradient background
        AnimatedContainer(
          duration: const Duration(seconds: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surface,
                AppColors.primaryBlue.withAlpha(((0.03) * 255).toInt()),
                AppColors.accentPurple.withAlpha(((0.05) * 255).toInt()),
                AppColors.accentTeal.withAlpha(((0.03) * 255).toInt()),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        ),

        // Floating particles
        ...List.generate(particleCount, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final random = Random(index);
              final size = 40.0 + random.nextDouble() * 120;
              final left =
                  random.nextDouble() * MediaQuery.of(context).size.width;
              final top =
                  random.nextDouble() * MediaQuery.of(context).size.height;

              return Positioned(
                left: left + _animations[index].value,
                top: top + _animations[index].value * 0.5,
                child: Opacity(
                  opacity: 0.03 + random.nextDouble() * 0.05,
                  child: Transform.rotate(
                    angle: _animations[index].value * 0.01,
                    child: _buildParticle(
                      size,
                      index % 3,
                      random,
                    ),
                  ),
                ),
              );
            },
          );
        }),

        // Content
        widget.child,
      ],
    );
  }

  Widget _buildParticle(double size, int shapeType, Random random) {
    final colors = [
      AppColors.primaryBlue,
      AppColors.accentPurple,
      AppColors.accentTeal,
    ];

    switch (shapeType) {
      case 0: // Circle
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                colors[random.nextInt(3)].withAlpha(((0.3) * 255).toInt()),
                Colors.transparent,
              ],
            ),
          ),
        );
      case 1: // Square
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.2),
            gradient: LinearGradient(
              colors: [
                colors[random.nextInt(3)].withAlpha(((0.3) * 255).toInt()),
                Colors.transparent,
              ],
            ),
          ),
        );
      case 2: // Triangle
      default:
        return CustomPaint(
          size: Size(size, size),
          painter: TrianglePainter(
            color: colors[random.nextInt(3)].withAlpha(((0.3) * 255).toInt()),
          ),
        );
    }
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
