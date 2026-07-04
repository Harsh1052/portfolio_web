import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'responsive_layout.dart';

// ─── HELLO dot-matrix ────────────────────────────────────────────────────────
// Grid: columns 0-18 (width=18), rows 0-4 (height=4), 0-indexed.
//
//  H  H   E E E   L       L       O O
//  H  H   E       L       L      O   O
//  HHHH   E E     L       L      O   O
//  H  H   E       L       L       O O
//  H  H   E E E   L L L   L L L
//
const List<List<int>> _helloPoints = [
  // H (cols 0-2)
  [0,0],[2,0], [0,1],[2,1], [0,2],[1,2],[2,2], [0,3],[2,3], [0,4],[2,4],
  // E (cols 4-6)
  [4,0],[5,0],[6,0], [4,1], [4,2],[5,2], [4,3], [4,4],[5,4],[6,4],
  // L (cols 8-10)
  [8,0], [8,1], [8,2], [8,3], [8,4],[9,4],[10,4],
  // L (cols 12-14)
  [12,0], [12,1], [12,2], [12,3], [12,4],[13,4],[14,4],
  // O (cols 16-18)
  [17,0], [16,1],[18,1], [16,2],[18,2], [16,3],[18,3], [17,4],
];

// Total HELLO points = 11 + 10 + 7 + 7 + 8 = 43 (matches 45-particle desktop count)

enum _ParticlePhase { converging, free }

/// A interactive backdrop that draws floating particles in pseudo-3D space.
///
/// On first load (desktop only), particles converge to spell **"HELLO"**
/// in the center of the hero section for 3.5 seconds. The moment the user
/// moves their mouse, or after the timeout, particles explode outward and
/// resume normal free-floating, mouse-interactive behavior.
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

  _ParticlePhase _phase = _ParticlePhase.converging;
  Timer? _phaseTimer;

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
    _phaseTimer?.cancel();
    super.dispose();
  }

  void _triggerExplosion() {
    if (!mounted || _phase == _ParticlePhase.free) return;
    setState(() => _phase = _ParticlePhase.free);

    // Apply outward radial burst from center of screen
    if (_lastSize != Size.zero) {
      final cx = _lastSize.width / 2;
      final cy = _lastSize.height / 2;
      for (final p in _particles) {
        final dx = p.x - cx;
        final dy = p.y - cy;
        final dist = math.sqrt(dx * dx + dy * dy);
        if (dist > 1) {
          final speed = 120.0 + _random.nextDouble() * 160.0;
          p.vx = (dx / dist) * speed;
          p.vy = (dy / dist) * speed;
        } else {
          // Particle is right at center, send in random direction
          final angle = _random.nextDouble() * 2 * math.pi;
          p.vx = math.cos(angle) * 200;
          p.vy = math.sin(angle) * 200;
        }
      }
    }
  }

  void _initializeParticles(Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final isMobile = size.width < Breakpoints.mobile;
    final particleCount = isMobile ? 18 : 45;

    // Use a fixed 450x100 px grid for HELLO on desktop so it is perfectly dense and readable.
    // 1 unit = 25px (450 / 18 = 25, 100 / 4 = 25).
    const displayW = 450.0;
    const displayH = 100.0;

    // If the layout type (mobile vs desktop) changed, we must re-initialize
    // to get the correct particle count and reset the welcome phase.
    final bool typeChanged = _particles.length != particleCount;

    // If particles are already initialized and layout type hasn't changed, just scale them.
    if (_particles.isNotEmpty && _lastSize.width > 0 && _lastSize.height > 0 && !typeChanged) {
      final scaleX = size.width / _lastSize.width;
      final scaleY = size.height / _lastSize.height;

      final originX = (size.width - displayW) / 2;
      final originY = (size.height - displayH) / 2;

      for (int i = 0; i < _particles.length; i++) {
        final p = _particles[i];
        p.x *= scaleX;
        p.y *= scaleY;

        if (i < _helloPoints.length && !isMobile) {
          final pt = _helloPoints[i];
          p.targetX = originX + pt[0] * 25.0;
          p.targetY = originY + pt[1] * 25.0;
        } else {
          p.targetX = null;
          p.targetY = null;
        }
      }
      _lastSize = size;
      return;
    }

    _particles.clear();

    if (isMobile) {
      _phase = _ParticlePhase.free;
      _phaseTimer?.cancel();
    } else {
      // Start the 5-second welcome timer ONLY when we successfully initialize on desktop.
      // This prevents transient layout passes from cancelling the timer.
      _phase = _ParticlePhase.converging;
      _phaseTimer?.cancel();
      _phaseTimer = Timer(const Duration(milliseconds: 5000), _triggerExplosion);
    }

    final originX = (size.width - displayW) / 2;
    final originY = (size.height - displayH) / 2;

    for (int i = 0; i < particleCount; i++) {
      double? tx;
      double? ty;

      if (!isMobile && i < _helloPoints.length) {
        final pt = _helloPoints[i];
        tx = originX + pt[0] * 25.0;
        ty = originY + pt[1] * 25.0;
      }

      _particles.add(
        _Particle(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * size.height,
          z: _random.nextDouble() * 0.9 + 0.1,
          vx: (_random.nextDouble() * 0.4 - 0.2) * 40,
          vy: (_random.nextDouble() * 0.4 - 0.2) * 40,
          vz: (_random.nextDouble() * 0.02 - 0.01) * 40,
          targetX: tx,
          targetY: ty,
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
            setState(() => _mousePosition = event.localPosition);
          },
          onExit: (_) => setState(() => _isHovered = false),
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                for (final particle in _particles) {
                  particle.update(
                    size: size,
                    mousePos: _isHovered ? _mousePosition : null,
                    dt: 0.016,
                    phase: _phase,
                  );
                }

                return CustomPaint(
                  size: size,
                  painter: _ParticlePainter(
                    particles: _particles,
                    mousePos: _isHovered ? _mousePosition : null,
                    phase: _phase,
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

// ─── Particle Model ──────────────────────────────────────────────────────────

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.z,
    required this.vx,
    required this.vy,
    required this.vz,
    this.targetX,
    this.targetY,
  });

  double x;
  double y;
  double z;
  double vx;
  double vy;
  double vz;

  // Convergence target — null for surplus particles or mobile
  double? targetX;
  double? targetY;

  void update({
    required Size size,
    required Offset? mousePos,
    required double dt,
    required _ParticlePhase phase,
  }) {
    if (phase == _ParticlePhase.converging && targetX != null) {
      // Snappy spring physics: snaps particles to 'HELLO' targets in ~0.4s
      final fx = (targetX! - x) * 18.0 - vx * 5.0;
      final fy = (targetY! - y) * 18.0 - vy * 5.0;
      vx += fx * dt;
      vy += fy * dt;
      x += vx * dt;
      y += vy * dt;
      return; // Skip free-drift logic during convergence
    }

    // ── Free Phase ──
    x += vx * dt;
    y += vy * dt;
    z += vz * dt;

    // Gradual velocity decay after explosion
    vx *= 0.985;
    vy *= 0.985;

    // Clamp velocity to reasonable range (prevents runaway after explosion)
    final speed = math.sqrt(vx * vx + vy * vy);
    if (speed > 80) {
      vx = (vx / speed) * 80;
      vy = (vy / speed) * 80;
    }
    // Maintain a minimum drift
    if (speed < 8 && speed > 0.01) {
      vx = (vx / speed) * 8;
      vy = (vy / speed) * 8;
    }

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

    // Mouse gravitation
    if (mousePos != null) {
      final dx = mousePos.dx - x;
      final dy = mousePos.dy - y;
      final distance = math.sqrt(dx * dx + dy * dy);
      if (distance < 200) {
        final force = (200 - distance) / 200 * z * 8;
        x += (dx / distance) * force * dt * 30;
        y += (dy / distance) * force * dt * 30;
      }
    }
  }
}

// ─── Painter ─────────────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  const _ParticlePainter({
    required this.particles,
    required this.mousePos,
    required this.phase,
  });

  final List<_Particle> particles;
  final Offset? mousePos;
  final _ParticlePhase phase;

  @override
  void paint(Canvas canvas, Size size) {
    final isConverging = phase == _ParticlePhase.converging;

    final paint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..strokeWidth = isConverging ? 1.5 : 1.0
      ..style = PaintingStyle.stroke;

    // ── 1. Connecting lines between close particles ──
    for (int i = 0; i < particles.length; i++) {
      final p1 = particles[i];

      for (int j = i + 1; j < particles.length; j++) {
        final p2 = particles[j];
        final dx = p1.x - p2.x;
        final dy = p1.y - p2.y;
        final dist = math.sqrt(dx * dx + dy * dy);

        // During convergence: 36.0 limit connects adjacent 25px grid points perfectly.
        final limit = isConverging ? 36.0 : 110.0;
        if (dist < limit) {
          final avgZ = (p1.z + p2.z) / 2.0;
          final alpha = isConverging
              ? (1.0 - (dist / limit)) * 0.70   // Highly visible connecting lines
              : (1.0 - (dist / limit)) * 0.12 * avgZ;
          linePaint.color = AppColors.accent.withValues(alpha: alpha);
          canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), linePaint);
        }
      }

      // Connect to mouse only in free phase
      if (!isConverging && mousePos != null) {
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

    // ── 2. Draw the particles ──
    for (final p in particles) {
      if (isConverging) {
        // During HELLO convergence: bright, solid dots at fixed size
        final glowPaint = Paint()
          ..color = AppColors.accent.withValues(alpha: 0.30)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(p.x, p.y), 8.0, glowPaint);
        paint.color = AppColors.accent.withValues(alpha: 0.95);
        canvas.drawCircle(Offset(p.x, p.y), 4.0, paint);
      } else {
        // Free phase: depth-scaled size and opacity
        final radius = 2.0 + (3.0 * p.z);
        final opacity = 0.04 + (0.16 * p.z);

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
