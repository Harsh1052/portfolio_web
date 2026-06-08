import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'responsive_layout.dart';

/// A interactive backdrop that draws floating particles in pseudo-3D space
/// with connecting webs. Particles drift dynamically, respond to mouse hover,
/// and draw linking lines to the mouse pointer.
class ParticleBackdrop extends StatefulWidget {
  const ParticleBackdrop({super.key});

  @override
  State<ParticleBackdrop> createState() => _ParticleBackdropState();
}

class _ParticleBackdropState extends State<ParticleBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  Offset _mousePosition = Offset.zero;
  bool _isHovered = false;
  Size _lastSize = Size.zero;
  final math.Random _random = math.Random();

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

  void _initializeParticles(Size size) {
    _particles.clear();
    // Use fewer particles on mobile to preserve CPU & battery
    final isMobile = size.width < Breakpoints.mobile;
    final particleCount = isMobile ? 18 : 45;

    for (int i = 0; i < particleCount; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * size.height,
          z: _random.nextDouble() * 0.9 + 0.1, // z between 0.1 and 1.0 (depth)
          vx: (_random.nextDouble() * 0.4 - 0.2) * 40,
          vy: (_random.nextDouble() * 0.4 - 0.2) * 40,
          vz: (_random.nextDouble() * 0.02 - 0.01) * 40,
        ),
      );
    }
    _lastSize = size;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        // Reinitialize if size changes significantly
        if (_lastSize != size) {
          _initializeParticles(size);
        }

        return MouseRegion(
          onEnter: (event) {
            setState(() {
              _isHovered = true;
              _mousePosition = event.localPosition;
            });
          },
          onHover: (event) {
            setState(() {
              _mousePosition = event.localPosition;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
          },
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Update particle positions on every tick
                for (final particle in _particles) {
                  particle.update(
                    size: size,
                    mousePos: _isHovered ? _mousePosition : null,
                    dt: 0.016, // Approx 60fps frame delta
                  );
                }

                return CustomPaint(
                  size: size,
                  painter: _ParticlePainter(
                    particles: _particles,
                    mousePos: _isHovered ? _mousePosition : null,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.z,
    required this.vx,
    required this.vy,
    required this.vz,
  });

  double x;
  double y;
  double z; // depth factor: 0.1 is far, 1.0 is near
  double vx;
  double vy;
  double vz;

  void update({
    required Size size,
    required Offset? mousePos,
    required double dt,
  }) {
    // Normal drift
    x += vx * dt;
    y += vy * dt;
    z += vz * dt;

    // Bounce/wrap z-depth
    if (z < 0.1) {
      z = 0.1;
      vz = -vz;
    } else if (z > 1.0) {
      z = 1.0;
      vz = -vz;
    }

    // Wrap x/y bounds
    if (x < -20) {
      x = size.width + 20;
    } else if (x > size.width + 20) {
      x = -20;
    }

    if (y < -20) {
      y = size.height + 20;
    } else if (y > size.height + 20) {
      y = -20;
    }

    // Mouse gravitation effect (closer/medium nodes shift slightly toward cursor)
    if (mousePos != null) {
      final dx = mousePos.dx - x;
      final dy = mousePos.dy - y;
      final distance = math.sqrt(dx * dx + dy * dy);

      if (distance < 200) {
        // Force scales with proximity and depth (nearer particles respond more)
        final force = (200 - distance) / 200 * z * 8;
        x += (dx / distance) * force * dt * 30;
        y += (dy / distance) * force * dt * 30;
      }
    }
  }
}

class _ParticlePainter extends CustomPainter {
  const _ParticlePainter({
    required this.particles,
    required this.mousePos,
  });

  final List<_Particle> particles;
  final Offset? mousePos;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // 1. Draw connecting lines between close particles
    for (int i = 0; i < particles.length; i++) {
      final p1 = particles[i];

      for (int j = i + 1; j < particles.length; j++) {
        final p2 = particles[j];

        // Draw connections
        final dx = p1.x - p2.x;
        final dy = p1.y - p2.y;
        final dist = math.sqrt(dx * dx + dy * dy);

        // Connection distance limit
        const limit = 110.0;
        if (dist < limit) {
          // Opacity scaled by proximity and average depth
          final avgZ = (p1.z + p2.z) / 2.0;
          final alpha = (1.0 - (dist / limit)) * 0.12 * avgZ;
          linePaint.color = AppColors.accent.withValues(alpha: alpha);
          canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), linePaint);
        }
      }

      // Connect to mouse if active
      if (mousePos != null) {
        final dx = p1.x - mousePos!.dx;
        final dy = p1.y - mousePos!.dy;
        final dist = math.sqrt(dx * dx + dy * dy);

        const mouseLimit = 150.0;
        if (dist < mouseLimit) {
          final alpha = (1.0 - (dist / mouseLimit)) * 0.22 * p1.z;
          linePaint.color = AppColors.accent.withValues(alpha: alpha);
          canvas.drawLine(Offset(p1.x, p1.y), mousePos!, linePaint);
        }
      }
    }

    // 2. Draw the particles
    for (final p in particles) {
      // Scale visual properties by depth (z)
      final radius = 2.0 + (3.0 * p.z); // Size 2.0 to 5.0
      final opacity = 0.04 + (0.16 * p.z); // Opacity 0.04 to 0.20

      // Add a subtle outer glow for nearer particles
      if (p.z > 0.6) {
        final glowPaint = Paint()
          ..color = AppColors.accent.withValues(alpha: opacity * 0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(p.x, p.y), radius * 2.2, glowPaint);
      }

      paint.color = AppColors.accent.withValues(alpha: opacity);
      canvas.drawCircle(Offset(p.x, p.y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
