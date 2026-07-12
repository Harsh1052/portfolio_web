import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/features/v2/core/district.dart';
import 'package:portfolio_web/features/v2/core/journey_scroll_engine.dart';

class _FakeDistrict extends District {
  const _FakeDistrict(this.id, this.scrollLengthFactor);

  @override
  final String id;
  @override
  final double scrollLengthFactor;
  @override
  String get title => id;
  @override
  String get subtitle => '';
  @override
  DistrictSky get sky => const DistrictSky(
        top: Colors.black,
        mid: Colors.grey,
        horizon: Colors.white,
      );
  @override
  Color get accent => Colors.blue;
  @override
  Widget build(BuildContext context, ValueListenable<double> progress) =>
      const SizedBox.shrink();
}

void main() {
  const vp = 1000.0;

  JourneyScrollEngine makeEngine() => JourneyScrollEngine(
        districts: const [
          _FakeDistrict('a', 2.0), // 0..2000
          _FakeDistrict('b', 1.5), // 2000..3500
          _FakeDistrict('c', 1.0), // 3500..4500
        ],
      )..layout(vp);

  group('layout', () {
    test('computes extents from scrollLengthFactor × viewport', () {
      final e = makeEngine();
      expect(e.totalHeight, 4500);
      expect(e.startOf(0), 0);
      expect(e.startOf(1), 2000);
      expect(e.startOf(2), 3500);
      expect(e.heightOf(1), 1500);
    });

    test('clamps scrollLengthFactor below 1 to one viewport', () {
      final e = JourneyScrollEngine(
        districts: const [_FakeDistrict('tiny', 0.3)],
      )..layout(vp);
      expect(e.heightOf(0), vp);
    });

    test('same viewport twice is a no-op', () {
      final e = makeEngine();
      e.onScroll(500);
      e.layout(vp);
      expect(e.scrollPos.value, 500);
    });
  });

  group('local progress', () {
    test('is 0 before a district is reached and 1 after it is passed', () {
      final e = makeEngine();
      e.onScroll(0);
      expect(e.progressOf('b').value, 0);
      e.onScroll(4500);
      expect(e.progressOf('b').value, 1);
    });

    test('reaches 0 at district top and 1 when scrolled through', () {
      final e = makeEngine();
      // District b spans 2000..3500 → travel span = 1500 - 1000 = 500.
      e.onScroll(2000);
      expect(e.progressOf('b').value, 0);
      e.onScroll(2250);
      expect(e.progressOf('b').value, closeTo(0.5, 0.001));
      e.onScroll(2500);
      expect(e.progressOf('b').value, 1);
    });

    test('clamps to 0..1', () {
      final e = makeEngine();
      e.onScroll(-200);
      expect(e.progressOf('a').value, 0);
      e.onScroll(99999);
      expect(e.progressOf('c').value, 1);
    });
  });

  group('activeIndex', () {
    test('follows the viewport center across district boundaries', () {
      final e = makeEngine();
      e.onScroll(0); // center at 500 → district a
      expect(e.activeIndex.value, 0);
      e.onScroll(1600); // center at 2100 → district b
      expect(e.activeIndex.value, 1);
      e.onScroll(3200); // center at 3700 → district c
      expect(e.activeIndex.value, 2);
    });
  });

  group('journeyProgress', () {
    test('spans 0..1 over the scrollable range', () {
      final e = makeEngine();
      e.onScroll(0);
      expect(e.journeyProgress.value, 0);
      e.onScroll(3500); // total 4500 - viewport 1000
      expect(e.journeyProgress.value, 1);
      e.onScroll(1750);
      expect(e.journeyProgress.value, closeTo(0.5, 0.001));
    });
  });

  group('districtCoord (sky stitching)', () {
    test('holds the district sky through most of its span', () {
      final e = makeEngine();
      // Center at 25% of district a (span 0..2000): 2000*.25 - 500 = 0 px? →
      // scroll so center lands at 500 (25% of a).
      e.onScroll(0); // center 500 → local 0.25
      expect(e.districtCoord.value, 0);
      e.onScroll(900); // center 1400 → local 0.70 < blendStart
      expect(e.districtCoord.value, 0);
    });

    test('blends toward the next district near the boundary', () {
      final e = makeEngine();
      e.onScroll(1400); // center 1900 → local 0.95 within blend zone
      expect(e.districtCoord.value, greaterThan(0.5));
      expect(e.districtCoord.value, lessThanOrEqualTo(1.0));
    });

    test('never exceeds the last district index', () {
      final e = makeEngine();
      e.onScroll(99999);
      expect(e.districtCoord.value, lessThanOrEqualTo(2.0));
    });
  });

  test('progressOf is safe before layout', () {
    final e = JourneyScrollEngine(districts: const [_FakeDistrict('x', 2)]);
    expect(e.progressOf('x').value, 0);
    e.onScroll(100); // must not throw
    expect(e.isLaidOut, isFalse);
  });
}
