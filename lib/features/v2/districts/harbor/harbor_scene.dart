import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../core/motion_tokens.dart';
import '../../core/progress_utils.dart';
import '../../widgets/stamp.dart';
import '../../widgets/story_panel.dart';
import 'boarding_pass.dart';
import 'harbor_painter.dart';

/// The Harbor — journey's end and the point of departure:
///
/// | band        | what happens                                            |
/// |-------------|---------------------------------------------------------|
/// | 0.00 – 0.10 | arrival — dusk water, the lighthouse starts sweeping    |
/// | 0.14 – 0.42 | farewell beat — the whole journey in one breath         |
/// | 0.30 – 0.62 | a paper boat sails for the horizon                      |
/// | 0.42 – 1.00 | the boarding pass docks; contact lines stay moored      |
///
/// Unlike every other district, the finale's actions don't fade out —
/// this is where the visitor is meant to arrive and stay.
class HarborScene extends StatefulWidget {
  const HarborScene({super.key, required this.progress});

  final ValueListenable<double> progress;

  @override
  State<HarborScene> createState() => _HarborSceneState();
}

class _HarborSceneState extends State<HarborScene>
    with SingleTickerProviderStateMixin {
  static const _accent = Color(0xFF6EE7B7);
  static const _email = 'surejapatel@gmail.com';

  late final AnimationController _ticker = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  );

  bool _copied = false;

  @override
  void initState() {
    super.initState();
    if (!V2MotionSettings.instance.reduced.value) _ticker.repeat();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Future<void> _copyEmail() async {
    AnalyticsService.click('v2_contact_email_copy');
    await Clipboard.setData(const ClipboardData(text: _email));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  void _open(String name, String url) {
    AnalyticsService.click('v2_contact_$name');
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final isMobile = mq.width < 700;

    return ValueListenableBuilder<double>(
      valueListenable: widget.progress,
      builder: (context, t, _) {
        final arrive = t.band(0.0, 0.10, curve: V2Motion.reveal);
        final titleFade = 1 - t.band(0.34, 0.44);
        final passIn = t.band(0.42, 0.56, curve: V2Motion.reveal);
        final contactIn = t.band(0.50, 0.64, curve: V2Motion.reveal);
        final stampShow = t.band(0.16, 0.22);

        return Stack(
          fit: StackFit.expand,
          children: [
            // ── The harbor ──
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ticker,
                builder: (_, __) => CustomPaint(
                  painter: HarborPainter(
                    t: t,
                    time: _ticker.value,
                    sway: !V2MotionSettings.instance.reduced.value,
                    isMobile: isMobile,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
            // ── Arrival title ──
            Align(
              alignment: const Alignment(0, -0.55),
              child: IgnorePointer(
                child: Opacity(
                  opacity: (arrive * titleFade).clamp(0.0, 1.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'The Harbor',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 34 : 52,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'journey\'s end · every visitor leaves with a connection',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: isMobile ? 11 : 13,
                          color: _accent.withValues(alpha: 0.95),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Farewell beat ──
            Align(
              alignment: isMobile
                  ? const Alignment(0, -0.30)
                  : const Alignment(-0.7, -0.24),
              child: StoryPanel(
                t: t,
                start: 0.14,
                end: 0.42,
                accent: _accent,
                maxWidth: isMobile ? mq.width - 48 : 430,
                title: 'The last dock',
                body:
                    'You\'ve walked the whole city — from blueprints in the '
                    'Square to live candles at the Exchange, with a monsoon in '
                    'between. Cities like this are built one commit at a time, '
                    'and there\'s always another district coming. If you\'d '
                    'like to build one together, the ferry is waiting.',
              ),
            ),
            // ── Boarding pass (stays docked) ──
            if (passIn > 0)
              Align(
                alignment: Alignment(0, isMobile ? -0.05 : -0.02),
                child: Opacity(
                  opacity: passIn.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, (1 - passIn) * 50),
                    child: BoardingPass(compact: isMobile),
                  ),
                ),
              ),
            // ── Contact moorings (stay) ──
            if (contactIn > 0)
              Align(
                alignment: Alignment(0, isMobile ? 0.42 : 0.44),
                child: Opacity(
                  opacity: contactIn.clamp(0.0, 1.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _ContactPill(
                        icon: _copied
                            ? Icons.check_rounded
                            : Icons.mail_outline_rounded,
                        label: _copied ? 'copied!' : _email,
                        onTap: _copyEmail,
                      ),
                      _ContactPill(
                        icon: Icons.code_rounded,
                        label: 'GitHub',
                        onTap: () =>
                            _open('github', 'https://github.com/Harsh1052'),
                      ),
                      _ContactPill(
                        icon: Icons.business_center_outlined,
                        label: 'LinkedIn',
                        onTap: () => _open('linkedin',
                            'https://www.linkedin.com/in/harsh-sureja-87a70b16a/'),
                      ),
                      _ContactPill(
                        icon: Icons.edit_note_rounded,
                        label: 'Medium',
                        onTap: () =>
                            _open('medium', 'https://medium.com/@surejapatel'),
                      ),
                    ],
                  ),
                ),
              ),
            // ── Stamp #7, on the dock ──
            if (stampShow > 0)
              Align(
                alignment: isMobile
                    ? const Alignment(-0.8, 0.72)
                    : const Alignment(-0.86, 0.66),
                child: Opacity(
                  opacity: stampShow.clamp(0.0, 1.0),
                  child: const CollectibleStamp(
                    id: 'harbor',
                    label: 'Harbor stamp',
                    color: Color(0xFF6EE7B7),
                    icon: Icons.sailing_rounded,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ContactPill extends StatefulWidget {
  const _ContactPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_ContactPill> createState() => _ContactPillState();
}

class _ContactPillState extends State<_ContactPill> {
  static const _accent = Color(0xFF6EE7B7);
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: _hovered
                  ? _accent.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _accent.withValues(alpha: _hovered ? 0.9 : 0.45),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 15, color: _accent),
                const SizedBox(width: 7),
                Text(
                  widget.label,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.95),
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
