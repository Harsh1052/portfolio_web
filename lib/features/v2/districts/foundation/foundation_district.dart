import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/district.dart';
import 'foundation_scene.dart';

/// District — Foundation Square, the origin chapter (2017–2021):
/// GTU Computer Engineering + the Across the Glob internship, told as a
/// construction site where blueprints become steel.
class FoundationDistrict extends District {
  const FoundationDistrict();

  @override
  String get id => 'foundation';
  @override
  String get title => 'Foundation Square';
  @override
  String get subtitle => '2017–2021 · GTU & first internship';
  @override
  double get scrollLengthFactor => 3.2;
  @override
  DistrictSky get sky => const DistrictSky(
        top: Color(0xFF16305E),
        mid: Color(0xFF2A4E8F),
        horizon: Color(0xFF9FC4E8),
      );
  @override
  Color get accent => const Color(0xFF5FA8E8);

  @override
  Widget build(BuildContext context, ValueListenable<double> progress) {
    return FoundationScene(progress: progress);
  }
}
