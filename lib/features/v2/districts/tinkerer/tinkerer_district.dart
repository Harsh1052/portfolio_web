import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/district.dart';
import 'tinkerer_scene.dart';

/// District — Tinkerers' Park, the side-project chapter: a night carnival
/// where the ferris wheel turns with the visitor's scroll and the v1
/// bug-game bug makes its cameo.
class TinkererDistrict extends District {
  const TinkererDistrict();

  @override
  String get id => 'tinkerer';
  @override
  String get title => "Tinkerers' Park";
  @override
  String get subtitle => 'nights & weekends · side projects';
  @override
  double get scrollLengthFactor => 3.2;
  @override
  DistrictSky get sky => const DistrictSky(
        top: Color(0xFF1A1030),
        mid: Color(0xFF35204E),
        horizon: Color(0xFF7A3E68),
      );
  @override
  Color get accent => const Color(0xFFF472B6);

  @override
  Widget build(BuildContext context, ValueListenable<double> progress) {
    return TinkererScene(progress: progress);
  }
}
