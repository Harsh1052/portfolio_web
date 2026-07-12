import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/progress_utils.dart';

/// Scroll-scrubbed animated number: counts from 0 to [target] as the
/// visitor scrolls through its band — scrub back and it counts down.
class StatCounter extends StatelessWidget {
  const StatCounter({
    super.key,
    required this.t,
    required this.start,
    required this.end,
    required this.target,
    required this.label,
    required this.accent,
    this.suffix = '',
    this.compact = false,
  });

  final double t;
  final double start;
  final double end;
  final int target;
  final String suffix;
  final String label;
  final Color accent;
  final bool compact;

  static String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      buf.write(s[i]);
      final remaining = s.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buf.write(',');
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final k = t.band(start, end, curve: Curves.easeOutCubic);
    final value = (target * k).round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${_fmt(value)}$suffix',
          style: GoogleFonts.spaceGrotesk(
            fontSize: compact ? 24 : 32,
            fontWeight: FontWeight.w600,
            color: accent,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: compact ? 11 : 12.5,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}
