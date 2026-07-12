import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/district.dart';
import 'enterprise_scene.dart';

/// District — Enterprise Heights, the Elision Infotech chapter (2023–2024):
/// blue-hour glass towers whose windows spell out the 50K users served,
/// with a crash-rate graph that falls as the visitor scrolls.
class EnterpriseDistrict extends District {
  const EnterpriseDistrict();

  @override
  String get id => 'enterprise';
  @override
  String get title => 'Enterprise Heights';
  @override
  String get subtitle => '2023–2024 · Elision Infotech';
  @override
  double get scrollLengthFactor => 3.2;
  @override
  DistrictSky get sky => const DistrictSky(
        top: Color(0xFF101E38),
        mid: Color(0xFF23405F),
        horizon: Color(0xFF6E93BC),
      );
  @override
  Color get accent => const Color(0xFF7DD3FC);

  @override
  Widget build(BuildContext context, ValueListenable<double> progress) {
    return EnterpriseScene(progress: progress);
  }
}
