import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_web/core/routing/app_pages.dart';

/// A delightful 404 page that feels like a lost district in the City of Code.
///
/// Features:
/// - Animated floating "404" with subtle bob
/// - Particle dust effect (lost in the city fog)
/// - Themed message with personality
/// - Clear navigation back to home or the city
class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bobAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bobAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        const Color(0xFF0A0A1A),
                        const Color(0xFF1A1035),
                        const Color(0xFF0A0A1A),
                      ]
                    : [
                        const Color(0xFFF0F4FF),
                        const Color(0xFFE8EEFF),
                        const Color(0xFFF0F4FF),
                      ],
              ),
            ),
          ),

          // Floating particles
          ...List.generate(
            isMobile ? 8 : 16,
            (i) => _FloatingParticle(
              controller: _controller,
              index: i,
              isDark: isDark,
            ),
          ),

          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated 404
                  AnimatedBuilder(
                    animation: _bobAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _bobAnimation.value),
                        child: child,
                      );
                    },
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
                      ).createShader(bounds),
                      child: Text(
                        '404',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 100 : 160,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Lost district message
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'District Not Found',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: isMobile ? 22 : 28,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Looks like you wandered off the city map.\n'
                          'This district hasn\'t been built yet.',
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 14 : 16,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Navigation buttons
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _NavButton(
                          label: 'Back to Home',
                          icon: Icons.home_rounded,
                          isPrimary: true,
                          onTap: () => Get.offAllNamed(AppRoutes.home),
                        ),
                        _NavButton(
                          label: 'Visit the City',
                          icon: Icons.location_city_rounded,
                          isPrimary: false,
                          onTap: () => Get.offAllNamed(AppRoutes.beta),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A small floating dust particle for ambient effect.
class _FloatingParticle extends StatelessWidget {
  const _FloatingParticle({
    required this.controller,
    required this.index,
    required this.isDark,
  });

  final AnimationController controller;
  final int index;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final random = Random(index * 42);
    final size = 3.0 + random.nextDouble() * 5;
    final startX = random.nextDouble();
    final startY = random.nextDouble();
    final driftX = (random.nextDouble() - 0.5) * 40;
    final driftY = (random.nextDouble() - 0.5) * 40;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final screenSize = MediaQuery.sizeOf(context);
        final progress = controller.value;
        return Positioned(
          left: startX * screenSize.width + driftX * progress,
          top: startY * screenSize.height + driftY * progress,
          child: Opacity(
            opacity: 0.15 + 0.25 * sin(progress * pi + index),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF0EA5E9)
                    : const Color(0xFF6366F1),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A styled navigation button for the 404 page.
class _NavButton extends StatefulWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.isPrimary
                  ? const Color(0xFF0EA5E9)
                  : Colors.transparent,
              border: widget.isPrimary
                  ? null
                  : Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.2),
                    ),
              boxShadow: _isHovered && widget.isPrimary
                  ? [
                      BoxShadow(
                        color:
                            const Color(0xFF0EA5E9).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            transform: _isHovered
                ? Matrix4.translationValues(0, -2, 0)
                : Matrix4.identity(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 18,
                  color: widget.isPrimary
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: widget.isPrimary
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
