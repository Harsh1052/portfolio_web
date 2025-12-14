import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/design_constants.dart';
import '../utils/glassmorphic_utils.dart';

/// Animated particle background for hero section with floating particles
///
/// Creates an immersive background with animated particles that float and move.
/// Optimized for performance with CustomPainter and responsive particle counts.
class ParticleBackground extends StatefulWidget {
  /// Number of particles (null = auto based on device)
  final int? particleCount;

  /// Particle colors (null = theme-based colors)
  final List<Color>? colors;

  /// Animation speed multiplier
  final double speedMultiplier;

  /// Whether particles should interact with mouse/touch
  final bool enableInteraction;

  /// Child widget to overlay on particles
  final Widget? child;

  const ParticleBackground({
    super.key,
    this.particleCount,
    this.colors,
    this.speedMultiplier = 1.0,
    this.enableInteraction = false,
    this.child,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  Offset? _mousePosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _initializeParticles();
  }

  void _initializeParticles() {
    // Will be properly initialized in didChangeDependencies when we have context
    _particles = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final particleCount =
        widget.particleCount ?? GlassmorphicUtils.getParticleCount(context);
    final colors = widget.colors ?? GlassmorphicUtils.getParticleColors(isDark);

    if (_particles.isEmpty) {
      _particles = List.generate(
        particleCount,
        (index) => Particle(
          position: Offset(
            math.Random().nextDouble(),
            math.Random().nextDouble(),
          ),
          velocity: Offset(
            (math.Random().nextDouble() - 0.5) *
                ParticleConfig.maxSpeed *
                widget.speedMultiplier,
            (math.Random().nextDouble() - 0.5) *
                ParticleConfig.maxSpeed *
                widget.speedMultiplier,
          ),
          size: ParticleConfig.minSize +
              math.Random().nextDouble() *
                  (ParticleConfig.maxSize - ParticleConfig.minSize),
          color: colors[math.Random().nextInt(colors.length)],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateParticles() {
    setState(() {
      for (var particle in _particles) {
        particle.update(_mousePosition, widget.enableInteraction);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: widget.enableInteraction
          ? (event) {
              setState(() {
                _mousePosition = event.localPosition;
              });
            }
          : null,
      onExit: widget.enableInteraction
          ? (_) {
              setState(() {
                _mousePosition = null;
              });
            }
          : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          _updateParticles();
          return CustomPaint(
            painter: ParticlePainter(
              particles: _particles,
              animation: _controller,
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Individual particle data
class Particle {
  Offset position; // Normalized 0-1
  Offset velocity;
  double size;
  Color color;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
  });

  void update(Offset? mousePosition, bool enableInteraction) {
    // Update position
    position += velocity * 0.001;

    // Wrap around edges
    if (position.dx < 0) position = Offset(1, position.dy);
    if (position.dx > 1) position = Offset(0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, 1);
    if (position.dy > 1) position = Offset(position.dx, 0);

    // Mouse interaction - particles move away from cursor
    if (enableInteraction && mousePosition != null) {
      final distance = (position - mousePosition).distance;
      if (distance < 0.2) {
        // Normalized distance threshold
        final direction = (position - mousePosition) / distance;
        velocity += direction * 0.01;
      }
    }

    // Damping to prevent particles from moving too fast
    velocity *= 0.99;

    // Add some randomness to keep particles moving
    velocity += Offset(
      (math.Random().nextDouble() - 0.5) * 0.001,
      (math.Random().nextDouble() - 0.5) * 0.001,
    );
  }
}

/// Custom painter for rendering particles
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Animation<double> animation;

  ParticlePainter({
    required this.particles,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: ParticleConfig.opacity)
        ..style = PaintingStyle.fill;

      final position = Offset(
        particle.position.dx * size.width,
        particle.position.dy * size.height,
      );

      // Draw particle as circle
      canvas.drawCircle(position, particle.size, paint);

      // Optional: Draw glow effect
      final glowPaint = Paint()
        ..color = particle.color.withValues(alpha: ParticleConfig.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(position, particle.size * 1.5, glowPaint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return true;
  }
}

/// Simpler static particle background (better performance)
class StaticParticleBackground extends StatelessWidget {
  final int? particleCount;
  final List<Color>? colors;
  final Widget? child;

  const StaticParticleBackground({
    super.key,
    this.particleCount,
    this.colors,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final count = particleCount ?? GlassmorphicUtils.getParticleCount(context);
    final particleColors =
        colors ?? GlassmorphicUtils.getParticleColors(isDark);

    return CustomPaint(
      painter: StaticParticlePainter(
        particleCount: count,
        colors: particleColors,
      ),
      child: child,
    );
  }
}

/// Static particle painter (no animation)
class StaticParticlePainter extends CustomPainter {
  final int particleCount;
  final List<Color> colors;

  StaticParticlePainter({
    required this.particleCount,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistency

    for (var i = 0; i < particleCount; i++) {
      final paint = Paint()
        ..color = colors[random.nextInt(colors.length)]
            .withValues(alpha: ParticleConfig.opacity)
        ..style = PaintingStyle.fill;

      final position = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );

      final particleSize = ParticleConfig.minSize +
          random.nextDouble() *
              (ParticleConfig.maxSize - ParticleConfig.minSize);

      canvas.drawCircle(position, particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(StaticParticlePainter oldDelegate) {
    return false;
  }
}
