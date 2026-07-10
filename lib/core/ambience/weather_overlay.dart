import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ambience_controller.dart';
import 'day_phase.dart';

/// Subtle rain / snow overlay for the hero — only rendered when the
/// visitor's local weather actually calls for it.
///
/// Deliberately understated: low particle count, low alpha, ignores pointer
/// events, and sits behind the hero content.
class WeatherOverlay extends StatefulWidget {
  const WeatherOverlay({super.key});

  @override
  State<WeatherOverlay> createState() => _WeatherOverlayState();
}

class _WeatherOverlayState extends State<WeatherOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Drop> _drops = [];
  final math.Random _random = math.Random();
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _seed(Size size, WeatherKind kind) {
    _drops.clear();
    final count = kind == WeatherKind.snow ? 36 : 44;
    for (var i = 0; i < count; i++) {
      _drops.add(_Drop.random(_random, size, kind));
    }
    _size = size;
  }

  @override
  Widget build(BuildContext context) {
    final ambience = Get.find<AmbienceController>();

    return Obx(() {
      final kind = ambience.weather.value;
      if (kind != WeatherKind.rain && kind != WeatherKind.snow) {
        return const SizedBox.shrink();
      }

      return IgnorePointer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            if (_size != size || _drops.isEmpty) _seed(size, kind);

            return RepaintBoundary(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  for (final d in _drops) {
                    d.update(size, _random);
                  }
                  return CustomPaint(
                    size: size,
                    painter: _WeatherPainter(
                      drops: _drops,
                      kind: kind,
                      color: ambience.phase.value.particleColor,
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }
}

class _Drop {
  _Drop({
    required this.x,
    required this.y,
    required this.speed,
    required this.depth,
    required this.drift,
  });

  double x;
  double y;
  final double speed;
  final double depth; // 0.3–1.0 → size & alpha scaling
  final double drift; // horizontal sway (snow) / slant (rain)

  factory _Drop.random(math.Random r, Size size, WeatherKind kind) {
    final depth = 0.3 + r.nextDouble() * 0.7;
    return _Drop(
      x: r.nextDouble() * size.width,
      y: r.nextDouble() * size.height,
      speed: kind == WeatherKind.snow
          ? (30 + r.nextDouble() * 40) * depth
          : (280 + r.nextDouble() * 220) * depth,
      depth: depth,
      drift: kind == WeatherKind.snow
          ? (r.nextDouble() * 30 - 15)
          : (20 + r.nextDouble() * 15),
    );
  }

  void update(Size size, math.Random r) {
    const dt = 0.016;
    y += speed * dt;
    x += drift * dt;
    if (y > size.height + 10) {
      y = -10;
      x = r.nextDouble() * size.width;
    }
    if (x > size.width + 10) x = -10;
    if (x < -10) x = size.width + 10;
  }
}

class _WeatherPainter extends CustomPainter {
  _WeatherPainter({
    required this.drops,
    required this.kind,
    required this.color,
  });

  final List<_Drop> drops;
  final WeatherKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final d in drops) {
      if (kind == WeatherKind.rain) {
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0 * d.depth
          ..color = color.withValues(alpha: 0.14 * d.depth);
        final len = 10 + 8 * d.depth;
        canvas.drawLine(
          Offset(d.x, d.y),
          Offset(d.x - d.drift * 0.06 * len / 12, d.y + len),
          paint,
        );
      } else {
        paint
          ..style = PaintingStyle.fill
          ..color = Colors.white.withValues(alpha: 0.20 * d.depth);
        canvas.drawCircle(Offset(d.x, d.y), 1.2 + 1.6 * d.depth, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
