import 'package:flutter/material.dart';
import '../core/motion_tokens.dart';

/// Which layers of a scene to render — port of Wonderous's
/// `WonderIllustrationConfig`, letting one scene widget serve full scenes
/// or single layers (useful later for transitions).
class SceneConfig {
  const SceneConfig({
    this.isShowing = true,
    this.enableBg = true,
    this.enableMg = true,
    this.enableFg = true,
    this.shortMode = false,
  });

  final bool isShowing;
  final bool enableBg;
  final bool enableMg;
  final bool enableFg;
  final bool shortMode;
}

typedef SceneLayerBuilder = List<Widget> Function(
  BuildContext context,
  Animation<double> anim,
);

/// Composites a district scene from bg / mg / fg layer builders with a
/// staggered entrance animation (bg first, foreground last) — port of
/// Wonderous's `WonderIllustrationBuilder`.
class SceneBuilder extends StatefulWidget {
  const SceneBuilder({
    super.key,
    this.config = const SceneConfig(),
    required this.bgBuilder,
    required this.mgBuilder,
    required this.fgBuilder,
  });

  final SceneConfig config;
  final SceneLayerBuilder bgBuilder;
  final SceneLayerBuilder mgBuilder;
  final SceneLayerBuilder fgBuilder;

  @override
  State<SceneBuilder> createState() => _SceneBuilderState();
}

class _SceneBuilderState extends State<SceneBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: V2Motion.entrance,
    value: widget.config.isShowing && V2MotionSettings.instance.reduced.value
        ? 1
        : 0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.config.isShowing) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant SceneBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.isShowing != oldWidget.config.isShowing) {
      widget.config.isShowing ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgAnim = CurvedAnimation(parent: _controller, curve: V2Motion.bgInterval);
    final mgAnim = CurvedAnimation(parent: _controller, curve: V2Motion.mgInterval);
    final fgAnim = CurvedAnimation(parent: _controller, curve: V2Motion.fgInterval);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.config.enableBg) ...widget.bgBuilder(context, bgAnim),
        if (widget.config.enableMg) ...widget.mgBuilder(context, mgAnim),
        if (widget.config.enableFg) ...widget.fgBuilder(context, fgAnim),
      ],
    );
  }
}
