import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'day_phase.dart';

/// Adaptive Ambience — makes the portfolio feel alive by adapting to each
/// visitor's moment in the world:
///
/// * **Time of day** (visitor's local clock) drives a [DayPhase] — dawn, day,
///   dusk, night — which tints the hero particles and picks the greeting.
/// * **Location + weather** (ipapi.co → open-meteo, both keyless & free)
///   personalise the greeting ("Good evening — raining in Mumbai?") and can
///   trigger a subtle rain/snow overlay.
///
/// Everything degrades gracefully: offline or blocked lookups simply leave
/// the site in its default state. No API keys, no tracking beyond what the
/// visitor-map feature already does.
class AmbienceController extends GetxController {
  /// Current phase of the visitor's day. Re-evaluated every minute.
  final phase = DayPhaseX.fromDateTime(DateTime.now()).obs;

  /// Current weather bucket at the visitor's location (if resolvable).
  final weather = WeatherKind.unknown.obs;

  /// Visitor's city from GeoIP (if resolvable).
  final city = RxnString();

  Timer? _clockTimer;

  /// Particle tint for the current phase — read once per painted frame.
  Color get particleColor => phase.value.particleColor;

  @override
  void onInit() {
    super.onInit();
    // Keep the phase honest for visitors who leave the tab open.
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      final next = DayPhaseX.fromDateTime(DateTime.now());
      if (next != phase.value) phase.value = next;
    });
    _resolveWeather();
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    super.onClose();
  }

  /// GeoIP → coordinates → current weather. Entirely fail-silent.
  Future<void> _resolveWeather() async {
    try {
      final geo = await GetConnect()
          .get('https://ipapi.co/json/')
          .timeout(const Duration(milliseconds: 3000));
      if (!geo.status.isOk || geo.body == null) return;

      final body = geo.body as Map<String, dynamic>;
      final lat = (body['latitude'] as num?)?.toDouble();
      final lon = (body['longitude'] as num?)?.toDouble();
      final resolvedCity = body['city'] as String?;
      if (resolvedCity != null && resolvedCity.isNotEmpty) {
        city.value = resolvedCity;
      }
      if (lat == null || lon == null) return;

      final wx = await GetConnect()
          .get(
            'https://api.open-meteo.com/v1/forecast'
            '?latitude=$lat&longitude=$lon&current=weather_code',
          )
          .timeout(const Duration(milliseconds: 3000));
      if (!wx.status.isOk || wx.body == null) return;

      final current =
          (wx.body as Map<String, dynamic>)['current'] as Map<String, dynamic>?;
      final code = (current?['weather_code'] as num?)?.toInt();
      if (code != null) {
        weather.value = WeatherKindX.fromWmoCode(code);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[Ambience] weather lookup skipped: $e');
    }
  }
}
