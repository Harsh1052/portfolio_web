import 'package:flutter/material.dart';

/// Tiled, tinted grain texture — the Wonderous "painterly paper" trick.
///
/// A small repeating speckle PNG is tinted with [color] and laid over a flat
/// background, instantly giving code-painted surfaces a hand-textured feel.
/// Port of `IllustrationTexture` from gskinner's Wonderous.
class IllustrationTexture extends StatelessWidget {
  const IllustrationTexture(
    this.path, {
    super.key,
    this.scale = 1,
    this.color,
    this.flipX = false,
    this.flipY = false,
    this.opacity,
  });

  final String path;
  final double scale;
  final Color? color;
  final bool flipX;
  final bool flipY;
  final Animation<double>? opacity;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Transform.scale(
        scaleX: scale * (flipX ? -1 : 1),
        scaleY: scale * (flipY ? -1 : 1),
        child: Image.asset(
          path,
          excludeFromSemantics: true,
          repeat: ImageRepeat.repeat,
          fit: BoxFit.none,
          alignment: Alignment.topCenter,
          color: color,
          opacity: opacity,
          cacheWidth: 1024,
        ),
      ),
    );
  }
}
