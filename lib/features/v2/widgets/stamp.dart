import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/motion_tokens.dart';
import '../core/stamps_controller.dart';

/// A hidden collectible — one per district. Glints softly to reward
/// observant visitors; tapping it collects the stamp (persisted +
/// tracked) with a little celebration.
class CollectibleStamp extends StatefulWidget {
  const CollectibleStamp({
    super.key,
    required this.id,
    required this.label,
    required this.color,
    this.icon = Icons.approval_rounded,
  });

  final String id;
  final String label;
  final Color color;
  final IconData icon;

  @override
  State<CollectibleStamp> createState() => _CollectibleStampState();
}

class _CollectibleStampState extends State<CollectibleStamp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glint = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  bool _justFound = false;
  Timer? _celebrateTimer;

  @override
  void initState() {
    super.initState();
    if (!V2MotionSettings.instance.reduced.value) {
      _glint.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _celebrateTimer?.cancel();
    _glint.dispose();
    super.dispose();
  }

  void _collect() {
    final isNew = StampsController.instance.collect(widget.id);
    if (!isNew) return;
    setState(() => _justFound = true);
    _celebrateTimer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) setState(() => _justFound = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: StampsController.instance.found,
      builder: (context, foundSet, _) {
        final found = foundSet.contains(widget.id);

        final badge = AnimatedBuilder(
          animation: _glint,
          builder: (context, child) {
            final glow = found ? .55 : .25 + _glint.value * .35;
            return Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: found
                    ? widget.color
                    : const Color(0xFF14091F).withValues(alpha: 0.55),
                border: Border.all(
                  color: widget.color.withValues(alpha: found ? 1 : .7),
                  width: 1.6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: glow),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Icon(
                found ? Icons.check_rounded : widget.icon,
                size: 22,
                color: found ? const Color(0xFF14091F) : widget.color,
              ),
            );
          },
        );

        return Semantics(
          label: found
              ? '${widget.label} collected'
              : 'Hidden collectible: ${widget.label}',
          button: !found,
          child: MouseRegion(
            cursor: found ? MouseCursor.defer : SystemMouseCursors.click,
            child: GestureDetector(
              onTap: found ? null : _collect,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1, end: _justFound ? 1.25 : 1),
                    duration: V2Motion.med,
                    curve: V2Motion.settle,
                    builder: (_, s, child) =>
                        Transform.scale(scale: s, child: child),
                    child: badge,
                  ),
                  AnimatedOpacity(
                    duration: V2Motion.fast,
                    opacity: _justFound ? 1 : 0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14091F)
                              .withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: widget.color.withValues(alpha: .6)),
                        ),
                        child: Text(
                          '${widget.label} · '
                          '${StampsController.instance.count}/${StampsController.total}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
