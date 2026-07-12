import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// One positioned artwork layer inside a district scene — a close port of
/// Wonderous's `IllustrationPiece`.
///
/// Standardizes the tricks that make their scenes feel alive:
/// * responsive sizing (`heightFactor` of the scene, floored by `minHeight`)
/// * `fractionalOffset` positioning relative to the piece's own size
/// * entrance choreography (`initialOffset`/`initialScale` driven by [entrance])
/// * scroll-linked depth (`zoomAmt` × live [zoom] listenable)
/// * `dynamicHzOffset` — pieces spread outward on wide screens
class ScenePiece extends StatefulWidget {
  const ScenePiece({
    super.key,
    required this.imagePath,
    required this.entrance,
    required this.heightFactor,
    this.zoom,
    this.alignment = Alignment.center,
    this.minHeight,
    this.offset = Offset.zero,
    this.fractionalOffset,
    this.zoomAmt = 0,
    this.initialOffset = Offset.zero,
    this.initialScale = 1,
    this.dynamicHzOffset = 0,
  });

  /// Full asset path, e.g. `assets/v2/valley/valley_hero.png`.
  final String imagePath;

  /// Entrance animation (0→1), typically a staggered layer anim
  /// from [SceneBuilder].
  final Animation<double> entrance;

  /// Live scroll-derived value (0..1) multiplied by [zoomAmt] for depth.
  final ValueListenable<double>? zoom;

  final Alignment alignment;
  final double heightFactor;
  final double? minHeight;
  final Offset offset;
  final Offset? fractionalOffset;
  final double zoomAmt;
  final Offset initialOffset;
  final double initialScale;
  final double dynamicHzOffset;

  @override
  State<ScenePiece> createState() => _ScenePieceState();
}

class _ScenePieceState extends State<ScenePiece> {
  double? _aspectRatio;
  bool _loadStarted = false;

  void _loadAspectRatio() {
    if (_loadStarted) return;
    _loadStarted = true;
    rootBundle.load(widget.imagePath).then((data) async {
      final image = await decodeImageFromList(data.buffer.asUint8List());
      if (!mounted) return;
      setState(() => _aspectRatio = image.width / image.height);
    }).catchError((Object e) {
      if (kDebugMode) debugPrint('[ScenePiece] load failed: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadAspectRatio();
    final aspect = _aspectRatio ?? 1;

    return Align(
      alignment: widget.alignment,
      child: LayoutBuilder(
        key: ValueKey(_aspectRatio),
        builder: (_, constraints) {
          final height = (constraints.maxHeight * widget.heightFactor)
              .clamp(widget.minHeight ?? 0, double.infinity)
              .toDouble();
          final width = height * aspect;

          final screenWidth = MediaQuery.of(context).size.width;
          final dynamicAmt = ((screenWidth - 400) / 1100).clamp(0.0, 1.0);

          return AnimatedBuilder(
            animation: widget.entrance,
            builder: (context, _) {
              final t = Curves.easeOut.transform(widget.entrance.value);

              var translation = widget.offset;
              if (widget.initialOffset != Offset.zero) {
                translation += widget.initialOffset * (1 - t);
              }
              translation += Offset(dynamicAmt * widget.dynamicHzOffset, 0);
              if (widget.fractionalOffset != null) {
                translation += Offset(
                  widget.fractionalOffset!.dx * width,
                  widget.fractionalOffset!.dy * height,
                );
              }
              final introZoom = (widget.initialScale - 1) * (1 - t);

              Widget img = Opacity(
                opacity: t.clamp(0.0, 1.0),
                child: Image.asset(
                  widget.imagePath,
                  excludeFromSemantics: true,
                  fit: BoxFit.fitHeight,
                ),
              );
              // Overflow box so the piece isn't clipped while translated.
              img = OverflowBox(maxWidth: 2500, child: img);

              Widget content = SizedBox(height: height, width: width, child: img);

              if (widget.zoom != null && widget.zoomAmt != 0) {
                content = ValueListenableBuilder<double>(
                  valueListenable: widget.zoom!,
                  builder: (_, z, child) => Transform.scale(
                    scale: 1 + widget.zoomAmt * z + introZoom,
                    child: child,
                  ),
                  child: content,
                );
              } else if (introZoom != 0) {
                content = Transform.scale(scale: 1 + introZoom, child: content);
              }

              return Transform.translate(offset: translation, child: content);
            },
          );
        },
      ),
    );
  }
}
