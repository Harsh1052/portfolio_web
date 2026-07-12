import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/district.dart';
import 'gate_scene.dart';

/// District 1 — The City Gate. The fully illustrated Phase 1 scene:
/// procedural skyline, swinging doors, spilling light, dust motes, and
/// scroll-choreographed typography.
class GateDistrict extends District {
  const GateDistrict();

  @override
  String get id => 'gate';
  @override
  String get title => 'The City Gate';
  @override
  String get subtitle => 'Welcome to the City of Code';
  @override
  double get scrollLengthFactor => 2.4;
  @override
  DistrictSky get sky => const DistrictSky(
        top: Color(0xFF191036),
        mid: Color(0xFF3D2160),
        horizon: Color(0xFFB03D66),
      );
  @override
  Color get accent => const Color(0xFFF5B93E);

  @override
  Widget build(BuildContext context, ValueListenable<double> progress) {
    return GateScene(progress: progress);
  }
}
