import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

/// One quote in the (obviously fictional) City of Code exchange.
class Quote {
  const Quote({
    required this.symbol,
    required this.price,
    required this.sessionOpen,
    required this.lastPrice,
  });

  final String symbol;
  final double price;
  final double sessionOpen;

  /// Price at the previous tick — drives the ▲/▼ direction.
  final double lastPrice;

  double get pctChange => (price - sessionOpen) / sessionOpen * 100;
  bool get up => price >= lastPrice;

  Quote tickTo(double next) => Quote(
        symbol: symbol,
        price: next,
        sessionOpen: sessionOpen,
        lastPrice: price,
      );
}

/// Simulated market feed for the Exchange district — a seeded random walk
/// over tech-pun tickers. Clearly fictional by design (no real symbols, no
/// real prices): the *streaming mechanics* are the exhibit, not the data.
class MarketSimulator {
  MarketSimulator({
    int seed = 7,
    this.interval = const Duration(milliseconds: 900),
  }) : _rnd = math.Random(seed) {
    quotes = ValueNotifier(_initial());
  }

  final Duration interval;
  final math.Random _rnd;
  Timer? _timer;

  late final ValueNotifier<List<Quote>> quotes;

  bool get isRunning => _timer != null;

  static const _listings = <(String, double)>[
    ('FLTR', 302.10),
    ('DART', 145.60),
    ('BLOC', 88.20),
    ('GETX', 61.75),
    ('WDGT', 214.30),
    ('WSKT', 129.05),
  ];

  List<Quote> _initial() => [
        for (final (symbol, open) in _listings)
          Quote(
            symbol: symbol,
            price: open,
            sessionOpen: open,
            lastPrice: open,
          ),
      ];

  void start() {
    if (isRunning) return;
    _timer = Timer.periodic(interval, (_) => tickOnce());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// One random-walk step across all listings. Public for tests.
  void tickOnce() {
    quotes.value = [
      for (final q in quotes.value)
        q.tickTo(
          // ±0.35% drift per tick, floored so prices stay positive.
          math.max(1.0, q.price * (1 + (_rnd.nextDouble() - 0.5) * 0.007)),
        ),
    ];
  }

  void dispose() {
    stop();
    quotes.dispose();
  }
}
