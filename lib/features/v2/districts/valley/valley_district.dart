import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/district.dart';
import 'valley_scene.dart';

/// District — Harvest Valley, the FarmSetu chapter. Fully choreographed
/// Phase 2 scene: parallax wheat fields, three story beats, the monsoon,
/// scroll-scrubbed stats, and stamp #1.
class ValleyDistrict extends District {
  const ValleyDistrict();

  @override
  String get id => 'valley';
  @override
  String get title => 'Harvest Valley';
  @override
  String get subtitle => '2024–2026 · FarmSetu';
  @override
  double get scrollLengthFactor => 3.6;
  @override
  DistrictSky get sky => const DistrictSky(
        top: Color(0xFF3D2160),
        mid: Color(0xFFDF6A46),
        horizon: Color(0xFFFFBE5C),
      );
  @override
  Color get accent => const Color(0xFFE8912E);

  @override
  Widget build(BuildContext context, ValueListenable<double> progress) {
    return ValleyScene(progress: progress);
  }
}
