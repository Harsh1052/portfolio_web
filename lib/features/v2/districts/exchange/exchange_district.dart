import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/district.dart';
import 'exchange_scene.dart';

/// District — The Exchange, the Kotak Securities chapter. Night financial
/// district where the skyline is a live candlestick chart fed by a
/// (clearly fictional) simulated market stream.
class ExchangeDistrict extends District {
  const ExchangeDistrict();

  @override
  String get id => 'exchange';
  @override
  String get title => 'The Exchange';
  @override
  String get subtitle => '2026 – present · Kotak Securities';
  @override
  double get scrollLengthFactor => 3.4;
  @override
  DistrictSky get sky => const DistrictSky(
        top: Color(0xFF03040A),
        mid: Color(0xFF0B1220),
        horizon: Color(0xFF123B2E),
      );
  @override
  Color get accent => const Color(0xFF10B981);

  @override
  Widget build(BuildContext context, ValueListenable<double> progress) {
    return ExchangeScene(progress: progress);
  }
}
