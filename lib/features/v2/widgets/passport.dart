import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/motion_tokens.dart';
import '../core/stamps_controller.dart';

/// Registry of every stamp in the city — id, district, icon, color.
const passportSlots = <(String, String, IconData, Color)>[
  ('gate', 'The City Gate', Icons.location_city_rounded, Color(0xFFFFD98A)),
  ('foundation', 'Foundation Square', Icons.architecture_rounded,
      Color(0xFF5FA8E8)),
  ('craftsman', "Craftsman's Lane", Icons.handyman_rounded, Color(0xFFFFB84D)),
  ('enterprise', 'Enterprise Heights', Icons.apartment_rounded,
      Color(0xFF7DD3FC)),
  ('valley', 'Harvest Valley', Icons.grass_rounded, Color(0xFFF5B93E)),
  ('exchange', 'The Exchange', Icons.candlestick_chart_rounded,
      Color(0xFF10B981)),
  ('tinkerer', "Tinkerers' Park", Icons.attractions_rounded,
      Color(0xFFF472B6)),
  ('harbor', 'The Harbor', Icons.sailing_rounded, Color(0xFF6EE7B7)),
];

/// Top-bar chip showing live stamp progress; tap to open the passport.
class PassportChip extends StatelessWidget {
  const PassportChip({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: StampsController.instance.found,
      builder: (context, found, _) {
        final complete = found.length >= StampsController.total;
        final color =
            complete ? const Color(0xFFFFD98A) : Colors.white;
        return Semantics(
          button: true,
          label: 'City passport — ${found.length} of '
              '${StampsController.total} stamps collected',
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: complete
                        ? const Color(0xFFFFD98A).withValues(alpha: .8)
                        : Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.approval_rounded, size: 15, color: color),
                    const SizedBox(width: 6),
                    Text(
                      '${found.length}/${StampsController.total}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Full passport: all eight stamp slots, and — when the collection is
/// complete — the citizen celebration with confetti.
class PassportOverlay extends StatefulWidget {
  const PassportOverlay({
    super.key,
    required this.celebrate,
    required this.onClose,
  });

  /// True when opened by the moment of completion (confetti fires).
  final bool celebrate;
  final VoidCallback onClose;

  @override
  State<PassportOverlay> createState() => _PassportOverlayState();
}

class _PassportOverlayState extends State<PassportOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _confetti = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );

  @override
  void initState() {
    super.initState();
    if (widget.celebrate && !V2MotionSettings.instance.reduced.value) {
      _confetti.forward();
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return ValueListenableBuilder<Set<String>>(
      valueListenable: StampsController.instance.found,
      builder: (context, found, _) {
        final complete = found.length >= StampsController.total;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Scrim (tap to close).
            GestureDetector(
              onTap: widget.onClose,
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
            // Confetti behind the card.
            if (widget.celebrate)
              IgnorePointer(
                child: AnimatedBuilder(
                  animation: _confetti,
                  builder: (_, __) => CustomPaint(
                    painter: _ConfettiPainter(t: _confetti.value),
                    size: Size.infinite,
                  ),
                ),
              ),
            // The passport card.
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: isMobile ? 340 : 470),
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF14091F).withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: complete
                        ? const Color(0xFFFFD98A).withValues(alpha: .7)
                        : Colors.white.withValues(alpha: .3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.approval_rounded,
                          size: 20,
                          color: complete
                              ? const Color(0xFFFFD98A)
                              : Colors.white70,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'City Passport',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Semantics(
                          button: true,
                          label: 'Close passport',
                          child: GestureDetector(
                            onTap: widget.onClose,
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Icon(Icons.close_rounded,
                                  size: 20, color: Colors.white70),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      complete
                          ? 'every district, every stamp'
                          : '${found.length} of ${StampsController.total} '
                              'stamps — keep exploring',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: .7),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: isMobile ? 12 : 16,
                      runSpacing: 14,
                      children: [
                        for (final (id, label, icon, color) in passportSlots)
                          _Slot(
                            label: label,
                            icon: icon,
                            color: color,
                            found: found.contains(id),
                            compact: isMobile,
                          ),
                      ],
                    ),
                    if (complete) ...[
                      const SizedBox(height: 22),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD98A).withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                const Color(0xFFFFD98A).withValues(alpha: .5),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'CITIZEN OF THE CITY OF CODE',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: const Color(0xFFFFD98A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'You walked every street of my story and found '
                              'every stamp. Very few visitors ever do. '
                              'Thank you — sincerely. If you ever want to '
                              'build a district together, you know where the '
                              'harbor is.\n— Harsh',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                height: 1.6,
                                color: Colors.white.withValues(alpha: .9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({
    required this.label,
    required this.icon,
    required this.color,
    required this.found,
    required this.compact,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool found;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 54.0 : 64.0;
    return Semantics(
      label: found ? '$label stamp — collected' : '$label stamp — not found yet',
      child: Tooltip(
        message: label,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: found
                    ? color.withValues(alpha: .18)
                    : Colors.transparent,
                border: Border.all(
                  color: found
                      ? color
                      : Colors.white.withValues(alpha: .25),
                  width: found ? 2 : 1.4,
                ),
              ),
              child: Icon(
                found ? icon : Icons.question_mark_rounded,
                size: compact ? 20 : 24,
                color:
                    found ? color : Colors.white.withValues(alpha: .35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One-shot celebration burst — seeded confetti with gravity and spin.
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.t});

  final double t;

  static const _colors = [
    Color(0xFFFFD98A),
    Color(0xFFF472B6),
    Color(0xFF7DD3FC),
    Color(0xFF6EE7B7),
    Color(0xFFF5B93E),
    Color(0xFFEF4444),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0 || t >= 1) return;
    final rnd = math.Random(77);
    final origin = Offset(size.width / 2, size.height * .30);

    for (var i = 0; i < 90; i++) {
      final angle = rnd.nextDouble() * math.pi * 2;
      final speed = 140 + rnd.nextDouble() * 380;
      final vx = math.cos(angle) * speed;
      final vy = math.sin(angle) * speed - 180;
      final x = origin.dx + vx * t;
      final y = origin.dy + vy * t + 520 * t * t;
      if (y > size.height + 20) continue;

      final fade = (1 - t).clamp(0.0, 1.0);
      final spin = (t * (2 + rnd.nextDouble() * 4) + rnd.nextDouble()) *
          math.pi *
          2;
      final color = _colors[i % _colors.length];

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(spin);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: 4 + rnd.nextDouble() * 5,
            height: 7 + rnd.nextDouble() * 5,
          ),
          const Radius.circular(1.5),
        ),
        Paint()..color = color.withValues(alpha: fade),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
