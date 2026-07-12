import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/features/v2/core/progress_utils.dart';

void main() {
  group('ProgressBands.band', () {
    test('maps the range linearly to 0..1', () {
      expect(0.25.band(0.25, 0.75), 0);
      expect(0.50.band(0.25, 0.75), closeTo(0.5, 1e-9));
      expect(0.75.band(0.25, 0.75), 1);
    });

    test('clamps outside the range', () {
      expect(0.0.band(0.25, 0.75), 0);
      expect(1.0.band(0.25, 0.75), 1);
      expect((-5.0).band(0.25, 0.75), 0);
    });

    test('applies the curve', () {
      final linear = 0.5.band(0.0, 1.0);
      final eased = 0.5.band(0.0, 1.0, curve: Curves.easeInCubic);
      expect(eased, lessThan(linear));
      expect(0.0.band(0.0, 1.0, curve: Curves.easeInCubic), 0);
      expect(1.0.band(0.0, 1.0, curve: Curves.easeInCubic), 1);
    });

    test('overlapping bands choreograph independently', () {
      const t = 0.5;
      final doors = t.band(0.20, 0.62);
      final name = 1 - t.band(0.22, 0.48);
      expect(doors, closeTo((0.5 - 0.20) / 0.42, 1e-9));
      expect(name, 0); // name fully faded by 0.48
    });
  });
}
