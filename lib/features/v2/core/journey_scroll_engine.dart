import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'district.dart';

/// Maps one global scroll offset to per-district local progress.
///
/// The pattern is lifted from Wonderous's editorial screen: a single
/// ScrollController listener writes [scrollPos]; every animated element is a
/// small ValueListenableBuilder deriving its own value — no setState anywhere
/// in the scroll path.
///
/// All math is pure and synchronous, so it unit-tests without widgets.
class JourneyScrollEngine {
  JourneyScrollEngine({required this.districts});

  final List<District> districts;

  /// Raw scroll offset in px. Single source of truth.
  final ValueNotifier<double> scrollPos = ValueNotifier(0);

  /// Whole-journey progress 0..1 — drives the sky gradient.
  final ValueNotifier<double> journeyProgress = ValueNotifier(0);

  /// Index of the district currently under the viewport center.
  final ValueNotifier<int> activeIndex = ValueNotifier(0);

  /// Continuous district coordinate for sky stitching: pinned at `i`
  /// through most of district i, easing to `i + 1` only across the last
  /// [skyBlendStart]→1.0 stretch — so each district owns its sky and
  /// transitions happen at the boundary, regardless of district lengths.
  final ValueNotifier<double> districtCoord = ValueNotifier(0);

  /// Fraction of a district's span after which its sky starts blending
  /// into the next district's.
  static const double skyBlendStart = 0.75;

  final Map<String, ValueNotifier<double>> _progress = {};

  double _viewport = 0;
  List<double> _starts = const [];
  List<double> _heights = const [];
  double _total = 0;

  bool get isLaidOut => _viewport > 0;
  double get viewportHeight => _viewport;
  double get totalHeight => _total;

  /// Pixel height of district [i] in scroll space.
  double heightOf(int i) => _heights.isEmpty ? 0 : _heights[i];

  /// Pixel offset where district [i] begins.
  double startOf(int i) => _starts.isEmpty ? 0 : _starts[i];

  /// Live local progress for a district. Safe to call before [layout].
  ValueNotifier<double> progressOf(String id) =>
      _progress.putIfAbsent(id, () => ValueNotifier(0));

  /// Recomputes extents for a viewport size. Cheap — call from LayoutBuilder.
  void layout(double viewportHeight) {
    if (viewportHeight <= 0 || viewportHeight == _viewport) return;
    _viewport = viewportHeight;
    final starts = <double>[];
    final heights = <double>[];
    var cursor = 0.0;
    for (final d in districts) {
      starts.add(cursor);
      final h = d.scrollLengthFactor.clamp(1.0, 10.0) * viewportHeight;
      heights.add(h);
      cursor += h;
    }
    _starts = starts;
    _heights = heights;
    _total = cursor;
    // layout() is typically called from a LayoutBuilder during build —
    // notifier writes there would markNeedsBuild mid-build. Defer the
    // re-derivation one microtask; extents themselves are plain fields
    // and are readable synchronously right away.
    scheduleMicrotask(() => onScroll(scrollPos.value));
  }

  /// Feed the raw scroll offset; derives every dependent notifier.
  void onScroll(double px) {
    scrollPos.value = px;
    if (!isLaidOut) return;

    final maxScroll = (_total - _viewport).clamp(1.0, double.infinity);
    journeyProgress.value = (px / maxScroll).clamp(0.0, 1.0);

    final center = px + _viewport / 2;
    for (var i = 0; i < districts.length; i++) {
      final d = districts[i];
      // Local progress: 0 when the district's top hits the viewport top,
      // 1 when its bottom reaches the viewport bottom.
      final span = (_heights[i] - _viewport).clamp(1.0, double.infinity);
      final local = ((px - _starts[i]) / span).clamp(0.0, 1.0);
      final notifier = progressOf(d.id);
      if (notifier.value != local) notifier.value = local;

      if (center >= _starts[i] && center < _starts[i] + _heights[i]) {
        if (activeIndex.value != i) activeIndex.value = i;

        // Sky coordinate: hold this district's sky, blend near its end.
        final localCenter =
            ((center - _starts[i]) / _heights[i]).clamp(0.0, 1.0);
        final blend = ((localCenter - skyBlendStart) / (1 - skyBlendStart))
            .clamp(0.0, 1.0);
        final coord = math.min(
          i + Curves.easeInOut.transform(blend),
          (districts.length - 1).toDouble(),
        );
        if (districtCoord.value != coord) districtCoord.value = coord;
      }
    }
  }

  void dispose() {
    scrollPos.dispose();
    journeyProgress.dispose();
    activeIndex.dispose();
    districtCoord.dispose();
    for (final n in _progress.values) {
      n.dispose();
    }
  }
}
