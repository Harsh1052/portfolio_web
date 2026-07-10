import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ambience_controller.dart';
import 'day_phase.dart';

/// Time-aware greeting shown above the name in the hero:
///
///   🌆 Good evening · raining in Mumbai right now
///
/// The weather/city clause appears only when the (fail-silent) lookups
/// resolve; otherwise the greeting stands alone.
class AmbientGreeting extends StatelessWidget {
  const AmbientGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final ambience = Get.find<AmbienceController>();

    return Obx(() {
      final phase = ambience.phase.value;
      final weather = ambience.weather.value;
      final city = ambience.city.value;

      var text = '${phase.emoji}  ${phase.greeting}';
      if (weather != WeatherKind.unknown && city != null) {
        text += ' · ${weather.label} in $city right now';
      } else if (city != null) {
        text += ' · hello, $city';
      }

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        builder: (context, t, child) => Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 8),
            child: child,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: phase.particleColor,
            letterSpacing: 0.2,
          ),
        ),
      );
    });
  }
}
