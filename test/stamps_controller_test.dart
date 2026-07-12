import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/features/v2/core/stamps_controller.dart';

void main() {
  group('StampsController', () {
    test('collect registers a new stamp and reports it', () {
      final c = StampsController.internal();
      expect(c.isFound('valley'), isFalse);
      expect(c.collect('valley'), isTrue);
      expect(c.isFound('valley'), isTrue);
      expect(c.count, 1);
    });

    test('collecting the same stamp twice is a no-op', () {
      final c = StampsController.internal();
      expect(c.collect('valley'), isTrue);
      expect(c.collect('valley'), isFalse);
      expect(c.count, 1);
    });

    test('found notifier emits a new set instance on collect', () {
      final c = StampsController.internal();
      final before = c.found.value;
      var notified = 0;
      c.found.addListener(() => notified++);
      c.collect('gate');
      expect(notified, 1);
      expect(identical(before, c.found.value), isFalse);
      expect(c.found.value, contains('gate'));
    });

    test('counts multiple distinct stamps toward the total', () {
      final c = StampsController.internal();
      for (final id in ['gate', 'valley', 'exchange']) {
        c.collect(id);
      }
      expect(c.count, 3);
      expect(StampsController.total, 8);
    });
  });
}
