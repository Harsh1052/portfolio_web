import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/district.dart';
import 'craftsman_scene.dart';

/// District — Craftsman's Lane, the Tagline Infotech chapter (2021–2022):
/// a lantern-lit workshop street where the UI craft was learned — signs
/// flicker on shop by shop and the gear train turns with the scroll.
class CraftsmanDistrict extends District {
  const CraftsmanDistrict();

  @override
  String get id => 'craftsman';
  @override
  String get title => "Craftsman's Lane";
  @override
  String get subtitle => '2021–2022 · Tagline Infotech';
  @override
  double get scrollLengthFactor => 3.2;
  @override
  DistrictSky get sky => const DistrictSky(
        top: Color(0xFF4A2B4E),
        mid: Color(0xFF8A4A46),
        horizon: Color(0xFFE8A25E),
      );
  @override
  Color get accent => const Color(0xFFFFB84D);

  @override
  Widget build(BuildContext context, ValueListenable<double> progress) {
    return CraftsmanScene(progress: progress);
  }
}
