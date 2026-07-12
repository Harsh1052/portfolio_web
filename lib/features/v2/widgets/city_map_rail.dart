import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/journey_scroll_engine.dart';

/// The "city map" — dot navigation for the journey. Vertical on the right
/// edge for desktop, horizontal along the bottom for mobile. Doubles as a
/// progress indicator: the active district's dot stretches and glows.
class CityMapRail extends StatelessWidget {
  const CityMapRail({
    super.key,
    required this.engine,
    required this.onSelect,
  });

  final JourneyScrollEngine engine;
  final void Function(int index) onSelect;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return ValueListenableBuilder<int>(
      valueListenable: engine.activeIndex,
      builder: (context, active, _) {
        final dots = [
          for (var i = 0; i < engine.districts.length; i++)
            _RailDot(
              label: engine.districts[i].title,
              color: engine.districts[i].accent,
              isActive: i == active,
              horizontal: isMobile,
              onTap: () => onSelect(i),
            ),
        ];

        final bar = Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(30),
          ),
          child: isMobile
              ? Row(mainAxisSize: MainAxisSize.min, children: dots)
              : Column(mainAxisSize: MainAxisSize.min, children: dots),
        );

        return isMobile
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: bar,
                ),
              )
            : Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: bar,
                ),
              );
      },
    );
  }
}

class _RailDot extends StatefulWidget {
  const _RailDot({
    required this.label,
    required this.color,
    required this.isActive,
    required this.horizontal,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isActive;
  final bool horizontal;
  final VoidCallback onTap;

  @override
  State<_RailDot> createState() => _RailDotState();
}

class _RailDotState extends State<_RailDot> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    final size = active ? 22.0 : 10.0;

    return Tooltip(
      message: widget.label,
      textStyle: GoogleFonts.jetBrainsMono(fontSize: 11, color: Colors.white),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: widget.horizontal ? size : 10,
              height: widget.horizontal ? 10 : size,
              decoration: BoxDecoration(
                color: active
                    ? widget.color
                    : Colors.white.withValues(alpha: _hovered ? 0.9 : 0.45),
                borderRadius: BorderRadius.circular(6),
                boxShadow: active
                    ? [BoxShadow(color: widget.color.withValues(alpha: .6), blurRadius: 8)]
                    : const [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
