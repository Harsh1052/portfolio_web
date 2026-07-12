import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import '../../../core/analytics/analytics_event.dart';
import '../../../core/analytics/analytics_service.dart';

/// The collectible layer of the City of Code: one stamp hides in every
/// district. Finds persist in localStorage and fire analytics events, so
/// engagement depth is measurable per visitor.
class StampsController {
  StampsController._() {
    _load();
  }

  /// For unit tests — skips persistence entirely.
  @visibleForTesting
  StampsController.internal();

  static final StampsController instance = StampsController._();

  /// Total stamps across the finished city.
  static const int total = 8;

  static const _storageKey = 'v2_stamps';

  /// Immutable snapshot of found stamp ids — replaced (never mutated) on
  /// collect, so ValueListenableBuilders always fire.
  final ValueNotifier<Set<String>> found = ValueNotifier(const <String>{});

  int get count => found.value.length;

  bool isFound(String id) => found.value.contains(id);

  /// Registers a find. Returns true when it was new.
  bool collect(String id) {
    if (isFound(id)) return false;
    found.value = {...found.value, id};
    _persist();
    AnalyticsService.log(
      AnalyticsEventType.game,
      'v2_stamp_found',
      {'stamp': id, 'count': count, 'total': total},
    );
    if (count == total) {
      AnalyticsService.log(AnalyticsEventType.game, 'v2_passport_complete');
    }
    return true;
  }

  void _load() {
    if (!kIsWeb) return;
    try {
      final raw = web.window.localStorage.getItem(_storageKey);
      if (raw == null || raw.isEmpty) return;
      final list = (jsonDecode(raw) as List).cast<String>();
      found.value = list.toSet();
    } catch (_) {
      // Corrupt/blocked storage — start fresh.
    }
  }

  void _persist() {
    if (!kIsWeb) return;
    try {
      web.window.localStorage
          .setItem(_storageKey, jsonEncode(found.value.toList()));
    } catch (_) {
      // Safari private mode — non-fatal.
    }
  }
}
