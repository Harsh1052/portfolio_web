import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Shader warmup utility to precompile shaders for smooth animations
/// This prevents jank during first-time animations
class ShaderWarmup {
  ShaderWarmup._();

  static bool _isWarmedUp = false;

  /// Warm up shaders used in the portfolio
  /// Call this during app initialization
  static Future<void> warmUpShaders(BuildContext context) async {
    if (_isWarmedUp) return;

    // Wait for first frame to be rendered
    await SchedulerBinding.instance.endOfFrame;

    final canvas = ui.PictureRecorder();
    final paint = Paint();
    const rect = Rect.fromLTWH(0, 0, 100, 100);

    // Warm up common shader operations
    _warmUpGradients(canvas, rect);
    _warmUpShadows(canvas, rect, paint);
    _warmUpBlurs(canvas, rect, paint);
    _warmUpTransforms(canvas, rect, paint);

    _isWarmedUp = true;
  }

  /// Warm up gradient shaders
  static void _warmUpGradients(ui.PictureRecorder recorder, Rect rect) {
    final canvas = Canvas(recorder);
    final paint = Paint();

    // Linear gradients
    paint.shader = const LinearGradient(
      colors: [Colors.blue, Colors.purple],
    ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Radial gradients
    paint.shader = const RadialGradient(
      colors: [Colors.blue, Colors.purple, Colors.transparent],
    ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Sweep gradients
    paint.shader = const SweepGradient(
      colors: [Colors.blue, Colors.purple],
    ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  /// Warm up shadow rendering
  static void _warmUpShadows(
    ui.PictureRecorder recorder,
    Rect rect,
    Paint paint,
  ) {
    final canvas = Canvas(recorder);

    // Box shadows
    canvas.drawRect(
      rect,
      paint
        ..color = Colors.black.withAlpha(20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Drop shadows
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      paint
        ..color = Colors.black.withAlpha(30)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );
  }

  /// Warm up blur effects
  static void _warmUpBlurs(
    ui.PictureRecorder recorder,
    Rect rect,
    Paint paint,
  ) {
    final canvas = Canvas(recorder);

    // Gaussian blur
    canvas.drawRect(
      rect,
      paint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Inner blur
    canvas.drawRect(
      rect,
      paint..maskFilter = const MaskFilter.blur(BlurStyle.inner, 5),
    );
  }

  /// Warm up transform operations
  static void _warmUpTransforms(
    ui.PictureRecorder recorder,
    Rect rect,
    Paint paint,
  ) {
    final canvas = Canvas(recorder);
    paint.color = Colors.blue;

    // Scale
    canvas.save();
    canvas.scale(1.5);
    canvas.drawRect(rect, paint);
    canvas.restore();

    // Rotate
    canvas.save();
    canvas.rotate(0.5);
    canvas.drawRect(rect, paint);
    canvas.restore();

    // Translate
    canvas.save();
    canvas.translate(10, 10);
    canvas.drawRect(rect, paint);
    canvas.restore();

    // Skew
    canvas.save();
    canvas.skew(0.1, 0.1);
    canvas.drawRect(rect, paint);
    canvas.restore();
  }

  /// Widget that warms up shaders on build
  /// Place this widget early in your widget tree
  static Widget builder({required Widget child}) {
    return Builder(
      builder: (context) {
        // Warm up shaders asynchronously
        WidgetsBinding.instance.addPostFrameCallback((_) {
          warmUpShaders(context);
        });
        return child;
      },
    );
  }
}

/// Custom shader cache for frequently used shaders
class ShaderCache {
  ShaderCache._();

  static final Map<String, ui.Shader> _cache = {};

  /// Get or create a linear gradient shader
  static ui.Shader getLinearGradient({
    required List<Color> colors,
    required Rect rect,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    List<double>? stops,
  }) {
    final key = 'linear_${colors.hashCode}_${rect.hashCode}';

    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final shader = LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
      stops: stops,
    ).createShader(rect);

    _cache[key] = shader;
    return shader;
  }

  /// Get or create a radial gradient shader
  static ui.Shader getRadialGradient({
    required List<Color> colors,
    required Rect rect,
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
    List<double>? stops,
  }) {
    final key = 'radial_${colors.hashCode}_${rect.hashCode}_$radius';

    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final shader = RadialGradient(
      colors: colors,
      center: center,
      radius: radius,
      stops: stops,
    ).createShader(rect);

    _cache[key] = shader;
    return shader;
  }

  /// Clear shader cache to free memory
  static void clear() {
    _cache.clear();
  }

  /// Clear specific shader from cache
  static void remove(String key) {
    _cache.remove(key);
  }
}

/// Performance monitoring widget for animations
class AnimationPerformanceOverlay extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const AnimationPerformanceOverlay({
    super.key,
    required this.child,
    this.enabled = false,
  });

  @override
  State<AnimationPerformanceOverlay> createState() =>
      _AnimationPerformanceOverlayState();
}

class _AnimationPerformanceOverlayState
    extends State<AnimationPerformanceOverlay> {
  double _fps = 60.0;
  int _frameCount = 0;
  DateTime _lastUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _startMonitoring();
    }
  }

  void _startMonitoring() {
    SchedulerBinding.instance.addPostFrameCallback(_onFrame);
  }

  void _onFrame(Duration timestamp) {
    if (!mounted || !widget.enabled) return;

    _frameCount++;
    final now = DateTime.now();
    final elapsed = now.difference(_lastUpdate).inMilliseconds;

    if (elapsed >= 1000) {
      setState(() {
        _fps = (_frameCount * 1000) / elapsed;
        _frameCount = 0;
        _lastUpdate = now;
      });
    }

    SchedulerBinding.instance.addPostFrameCallback(_onFrame);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.enabled)
          Positioned(
            top: 50,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(70),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'FPS: ${_fps.toStringAsFixed(1)}',
                style: TextStyle(
                  color: _fps >= 55 ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
