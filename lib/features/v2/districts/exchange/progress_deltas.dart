import 'package:flutter/foundation.dart';

/// Immutable per-candle price deltas handed to the skyline painter —
/// value-equatable so `shouldRepaint` only fires on real market movement.
@immutable
class CandleDeltas {
  const CandleDeltas(this.values);

  const CandleDeltas.none() : values = const [];

  /// Delta (price − lastPrice) per live candle, index-aligned with the
  /// leftmost skyline candles.
  final List<double> values;

  /// Null for candles beyond the live feed → painter falls back to seed.
  double? deltaFor(int i) => i < values.length ? values[i] : null;

  @override
  bool operator ==(Object other) =>
      other is CandleDeltas && listEquals(other.values, values);

  @override
  int get hashCode => Object.hashAll(values);
}
