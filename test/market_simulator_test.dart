import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/features/v2/districts/exchange/market_simulator.dart';

void main() {
  group('MarketSimulator', () {
    test('starts with session-open quotes and no movement', () {
      final sim = MarketSimulator(seed: 1);
      for (final q in sim.quotes.value) {
        expect(q.price, q.sessionOpen);
        expect(q.pctChange, 0);
        expect(q.up, isTrue);
      }
      sim.dispose();
    });

    test('tickOnce moves prices and notifies listeners', () {
      final sim = MarketSimulator(seed: 1);
      var notified = 0;
      sim.quotes.addListener(() => notified++);
      final before = [for (final q in sim.quotes.value) q.price];
      sim.tickOnce();
      final after = [for (final q in sim.quotes.value) q.price];
      expect(notified, 1);
      expect(after, isNot(equals(before)));
      sim.dispose();
    });

    test('same seed produces the same walk', () {
      final a = MarketSimulator(seed: 42);
      final b = MarketSimulator(seed: 42);
      for (var i = 0; i < 25; i++) {
        a.tickOnce();
        b.tickOnce();
      }
      for (var i = 0; i < a.quotes.value.length; i++) {
        expect(a.quotes.value[i].price, b.quotes.value[i].price);
      }
      a.dispose();
      b.dispose();
    });

    test('prices never go non-positive over a long walk', () {
      final sim = MarketSimulator(seed: 3);
      for (var i = 0; i < 2000; i++) {
        sim.tickOnce();
      }
      for (final q in sim.quotes.value) {
        expect(q.price, greaterThan(0));
      }
      sim.dispose();
    });

    test('direction flag tracks the last tick', () {
      final sim = MarketSimulator(seed: 5);
      sim.tickOnce();
      for (final q in sim.quotes.value) {
        expect(q.up, q.price >= q.lastPrice);
      }
      sim.dispose();
    });

    test('start is idempotent and stop cancels', () {
      final sim = MarketSimulator(seed: 1);
      sim.start();
      sim.start();
      expect(sim.isRunning, isTrue);
      sim.stop();
      expect(sim.isRunning, isFalse);
      sim.dispose();
    });
  });
}
