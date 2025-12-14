import 'package:flutter/material.dart';
import '../../../../core/theme/terminal_theme.dart';

class HoloCard extends StatefulWidget {
  final Widget child;
  final Color borderColor;

  const HoloCard({
    super.key,
    required this.child,
    this.borderColor = TerminalTheme.neonGreen,
  });

  @override
  State<HoloCard> createState() => _HoloCardState();
}

class _HoloCardState extends State<HoloCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.borderColor.withValues(alpha: 0.05)
              : TerminalTheme.voidBlack,
          border: Border.all(
            color: _isHovered
                ? widget.borderColor
                : widget.borderColor.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  widget.borderColor.withValues(alpha: _isHovered ? 0.2 : 0.05),
              blurRadius: _isHovered ? 20 : 10,
              spreadRadius: _isHovered ? 2 : 0,
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

class HoloBullet extends StatelessWidget {
  final String text;

  const HoloBullet(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('> ',
              style: TerminalTheme.terminalText
                  .copyWith(color: TerminalTheme.cyberBlue)),
          Expanded(
            child: Text(
              text,
              style: TerminalTheme.terminalText,
            ),
          ),
        ],
      ),
    );
  }
}
