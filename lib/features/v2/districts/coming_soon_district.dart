import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/district.dart';
import '../widgets/under_construction.dart';

/// Placeholder for every district still being built. Ends the beta journey
/// on an honest, playful note — and sets up the "new district" announcements.
class ComingSoonDistrict extends District {
  const ComingSoonDistrict();

  @override
  String get id => 'coming_soon';
  @override
  String get title => 'Under Construction';
  @override
  String get subtitle => 'New districts open with every commit';
  @override
  double get scrollLengthFactor => 1.2;
  @override
  DistrictSky get sky => const DistrictSky(
        top: Color(0xFF0B1220),
        mid: Color(0xFF1E2A4A),
        horizon: Color(0xFF10B981),
      );
  @override
  Color get accent => const Color(0xFF10B981);

  @override
  Widget build(BuildContext context, ValueListenable<double> progress) {
    return const UnderConstruction(
      upcoming: [
        'Enterprise Heights',
        "Tinkerers' Park",
        'The Harbor',
      ],
    );
  }
}
