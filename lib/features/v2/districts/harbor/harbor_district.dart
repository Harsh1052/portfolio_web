import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/district.dart';
import 'harbor_scene.dart';

/// District — The Harbor, journey's end: dusk water, a sweeping
/// lighthouse, a paper boat that sails with the scroll, and the resume
/// as a ferry boarding pass. No visitor leaves without a connection.
class HarborDistrict extends District {
  const HarborDistrict();

  @override
  String get id => 'harbor';
  @override
  String get title => 'The Harbor';
  @override
  String get subtitle => 'journey\'s end · contact & departure';
  @override
  double get scrollLengthFactor => 3.0;
  @override
  DistrictSky get sky => const DistrictSky(
        top: Color(0xFF1E1A3E),
        mid: Color(0xFF4A3A6E),
        horizon: Color(0xFFE8875E),
      );
  @override
  Color get accent => const Color(0xFF6EE7B7);

  @override
  Widget build(BuildContext context, ValueListenable<double> progress) {
    return HarborScene(progress: progress);
  }
}
