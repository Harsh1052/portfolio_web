import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/motion_tokens.dart';
import '../core/progress_utils.dart';

/// One narrative beat, choreographed against district progress: slides up
/// and fades in as its band begins, fades out as it ends. Purely
/// presentational — parents pass the live progress value [t].
class StoryPanel extends StatelessWidget {
  const StoryPanel({
    super.key,
    required this.t,
    required this.start,
    required this.end,
    required this.title,
    required this.body,
    required this.accent,
    this.maxWidth = 430,
  });

  final double t;
  final double start;
  final double end;
  final String title;
  final String body;
  final Color accent;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final fadeIn = t.band(start, start + 0.07, curve: V2Motion.reveal);
    final fadeOut = 1 - t.band(end - 0.05, end);
    final opacity = (fadeIn * fadeOut).clamp(0.0, 1.0);
    if (opacity == 0) return const SizedBox.shrink();

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, (1 - fadeIn) * 36),
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF14091F).withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withValues(alpha: 0.45)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.65,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
