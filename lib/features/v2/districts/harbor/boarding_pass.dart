import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/analytics/analytics_service.dart';

/// The resume, reimagined as a ferry boarding pass — the Harbor's
/// signature interaction. Tapping anywhere downloads the PDF.
class BoardingPass extends StatefulWidget {
  const BoardingPass({super.key, this.compact = false});

  final bool compact;

  static const _resumeUrl = '/resume.pdf';

  @override
  State<BoardingPass> createState() => _BoardingPassState();
}

class _BoardingPassState extends State<BoardingPass> {
  bool _hovered = false;

  void _download() {
    AnalyticsService.click('v2_resume_download');
    launchUrl(Uri.parse(BoardingPass._resumeUrl),
        mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    const seafoam = Color(0xFF6EE7B7);
    const ink = Color(0xFF0F2233);
    final compact = widget.compact;

    return Semantics(
      button: true,
      label: 'Boarding pass — download resume PDF',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: _download,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: compact ? 320 : 420,
            transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F1E4),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .4),
                  blurRadius: _hovered ? 26 : 14,
                  offset: const Offset(0, 8),
                ),
                if (_hovered)
                  BoxShadow(
                    color: seafoam.withValues(alpha: .35),
                    blurRadius: 24,
                  ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header strip.
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: const BoxDecoration(
                    color: ink,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sailing_rounded,
                          size: 15, color: seafoam),
                      const SizedBox(width: 8),
                      Text(
                        'HARBOR FERRY LINE · BOARDING PASS',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: compact ? 9.5 : 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _field('PASSENGER', 'HARSH SUREJA', compact),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _field('FROM', 'CITY OF CODE', compact),
                                const SizedBox(width: 22),
                                _field('TO', 'YOUR TEAM', compact),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _field('SEAT', 'FLUTTER-1', compact),
                          const SizedBox(height: 8),
                          _field('GATE', 'ALWAYS OPEN', compact),
                        ],
                      ),
                    ],
                  ),
                ),
                // Perforation.
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      for (var i = 0; i < (compact ? 24 : 32); i++)
                        Expanded(
                          child: Container(
                            height: 1.4,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            color: ink.withValues(alpha: .25),
                          ),
                        ),
                    ],
                  ),
                ),
                // Barcode + call to action.
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 2, 18, 14),
                  child: Row(
                    children: [
                      for (final barW in const [
                        3.0, 1.5, 4.0, 2.0, 1.5, 5.0, 2.0, 3.0, 1.5, 2.0,
                        4.0, 1.5, 3.0, 2.0, 5.0, 1.5, 2.0, 3.0,
                      ])
                        Container(
                          width: barW,
                          height: 26,
                          margin: const EdgeInsets.only(right: 2.4),
                          color: ink,
                        ),
                      const Spacer(),
                      Icon(Icons.download_rounded,
                          size: 17,
                          color: _hovered ? ink : ink.withValues(alpha: .6)),
                      const SizedBox(width: 6),
                      Text(
                        'RESUME.PDF',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: compact ? 10 : 11.5,
                          fontWeight: FontWeight.w600,
                          color: ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, String value, bool compact) {
    const ink = Color(0xFF0F2233);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: compact ? 8 : 9,
            letterSpacing: 1,
            color: ink.withValues(alpha: .5),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: compact ? 13 : 15,
            fontWeight: FontWeight.w600,
            color: ink,
          ),
        ),
      ],
    );
  }
}
