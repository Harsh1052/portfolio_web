import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/motion_tokens.dart';

/// Rebuilds with a `pctVisible` (0..1) as the item scrolls into view —
/// port of Wonderous's `AnimatedListItem`. Measures its own global position
/// against the viewport each scroll tick; no extra packages.
class AnimatedListItem extends StatelessWidget {
  const AnimatedListItem({
    super.key,
    required this.scrollPos,
    required this.builder,
  });

  final ValueListenable<double> scrollPos;
  final Widget Function(BuildContext context, double pctVisible) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: scrollPos,
      builder: (context, _, __) => LayoutBuilder(
        builder: (context, constraints) {
          double pctVisible = 1;
          final render = context.findRenderObject();
          if (render is RenderBox && render.hasSize) {
            final yPos = render.localToGlobal(Offset.zero).dy;
            final screenHeight = MediaQuery.of(context).size.height;
            final amtVisible = screenHeight - yPos;
            pctVisible =
                (amtVisible / render.size.height * .5).clamp(0.0, 1.0);
          }
          if (V2MotionSettings.instance.reduced.value) pctVisible = 1;
          return builder(context, pctVisible);
        },
      ),
    );
  }
}

/// Scales its child 1.35 → 1 as it scrolls onto screen — port of
/// Wonderous's `ScalingListItem`.
class ScalingListItem extends StatelessWidget {
  const ScalingListItem({
    super.key,
    required this.scrollPos,
    required this.child,
  });

  final ValueListenable<double> scrollPos;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedListItem(
      scrollPos: scrollPos,
      builder: (_, pctVisible) {
        final scale = 1.35 - pctVisible * .35;
        return ClipRect(
          child: Transform.scale(scale: scale, child: child),
        );
      },
    );
  }
}

/// Fades and slides its child up as it scrolls onto screen — our own
/// companion to [ScalingListItem] for text beats.
class RevealingListItem extends StatelessWidget {
  const RevealingListItem({
    super.key,
    required this.scrollPos,
    required this.child,
    this.slide = 40,
  });

  final ValueListenable<double> scrollPos;
  final Widget child;
  final double slide;

  @override
  Widget build(BuildContext context) {
    return AnimatedListItem(
      scrollPos: scrollPos,
      builder: (_, pctVisible) {
        final t = V2Motion.reveal.transform(pctVisible);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * slide),
            child: child,
          ),
        );
      },
    );
  }
}
