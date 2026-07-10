import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The four ambient phases of a day, derived from the visitor's local clock.
enum DayPhase { dawn, day, dusk, night }

extension DayPhaseX on DayPhase {
  /// Particle / ambient tint for this phase.
  Color get particleColor => switch (this) {
        DayPhase.dawn => const Color(0xFFF59E0B), // warm amber sunrise
        DayPhase.day => AppColors.accent, //         signature sky blue
        DayPhase.dusk => const Color(0xFFF97316), // burnt-orange sunset
        DayPhase.night => const Color(0xFF818CF8), // soft indigo starlight
      };

  String get greeting => switch (this) {
        DayPhase.dawn => 'Good morning',
        DayPhase.day => 'Good afternoon',
        DayPhase.dusk => 'Good evening',
        DayPhase.night => 'Burning the midnight oil?',
      };

  String get emoji => switch (this) {
        DayPhase.dawn => '🌅',
        DayPhase.day => '☀️',
        DayPhase.dusk => '🌆',
        DayPhase.night => '🌙',
      };

  static DayPhase fromDateTime(DateTime now) {
    final h = now.hour;
    if (h >= 5 && h < 9) return DayPhase.dawn;
    if (h >= 9 && h < 17) return DayPhase.day;
    if (h >= 17 && h < 21) return DayPhase.dusk;
    return DayPhase.night;
  }
}

/// Simplified current-weather buckets (mapped from open-meteo WMO codes).
enum WeatherKind { unknown, clear, cloudy, rain, snow }

extension WeatherKindX on WeatherKind {
  /// Map a WMO weather code (open-meteo `weather_code`) to a bucket.
  static WeatherKind fromWmoCode(int code) {
    if (code == 0 || code == 1) return WeatherKind.clear;
    if (code >= 2 && code <= 48) return WeatherKind.cloudy;
    if ((code >= 51 && code <= 67) ||
        (code >= 80 && code <= 82) ||
        (code >= 95 && code <= 99)) {
      return WeatherKind.rain;
    }
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return WeatherKind.snow;
    }
    return WeatherKind.unknown;
  }

  String get label => switch (this) {
        WeatherKind.clear => 'clear skies',
        WeatherKind.cloudy => 'a bit cloudy',
        WeatherKind.rain => 'raining',
        WeatherKind.snow => 'snowing',
        WeatherKind.unknown => '',
      };
}
