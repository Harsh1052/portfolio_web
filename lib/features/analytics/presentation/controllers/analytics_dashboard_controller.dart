import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/services/firebase_service.dart';
import '../../domain/entities/analytics_models.dart';

enum DashboardStatus { loading, loaded, empty, error }

/// Loads session rollups + per-session journeys for the /analytics page.
///
/// Aggregates are computed client-side from the session summary docs, so
/// the dashboard needs only ONE query to render — journeys are fetched
/// lazily when a session is expanded.
class AnalyticsDashboardController extends GetxController {
  AnalyticsDashboardController(this._firebaseService);

  final FirebaseService _firebaseService;
  FirebaseFirestore? _db;

  static const _sessionLimit = 60;

  final status = DashboardStatus.loading.obs;
  final sessions = <SessionSummary>[].obs;

  /// sessionId → journey (populated lazily on expand).
  final journeys = <String, List<JourneyEvent>>{}.obs;
  final expandedSessionId = RxnString();

  // ── Aggregates (recomputed when sessions load) ─────────────────────────

  int get totalSessions => sessions.length;

  int get totalEvents =>
      sessions.fold(0, (total, s) => total + s.eventCount);

  Duration get avgDuration => sessions.isEmpty
      ? Duration.zero
      : Duration(
          milliseconds:
              sessions.fold(0, (total, s) => total + s.durationMs) ~/
                  sessions.length,
        );

  int get avgScrollPct => sessions.isEmpty
      ? 0
      : sessions.fold(0, (total, s) => total + s.maxScrollPct) ~/ sessions.length;

  /// Section → summed dwell ms across all loaded sessions, sorted desc.
  List<MapEntry<String, int>> get dwellBySection {
    final totals = <String, int>{};
    for (final s in sessions) {
      for (final e in s.dwell.entries) {
        totals[e.key] = (totals[e.key] ?? 0) + e.value;
      }
    }
    final list = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return list;
  }

  /// Click name → summed count across all loaded sessions, sorted desc.
  List<MapEntry<String, int>> get topClicks {
    final totals = <String, int>{};
    for (final s in sessions) {
      for (final e in s.clicks.entries) {
        totals[e.key] = (totals[e.key] ?? 0) + e.value;
      }
    }
    final list = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    loadSessions();
  }

  Future<bool> _ensureReady() async {
    if (_db != null) return true;
    await _firebaseService.ensureInitialized();
    if (!_firebaseService.isInitialized) return false;
    _db = FirebaseFirestore.instance;
    return true;
  }

  Future<void> loadSessions() async {
    status.value = DashboardStatus.loading;
    if (!await _ensureReady()) {
      status.value = DashboardStatus.error;
      return;
    }
    try {
      final snap = await _db!
          .collection('analytics_sessions')
          .orderBy('lastSeenAt', descending: true)
          .limit(_sessionLimit)
          .get();
      sessions.value =
          snap.docs.map(SessionSummary.fromDoc).toList(growable: false);
      status.value =
          sessions.isEmpty ? DashboardStatus.empty : DashboardStatus.loaded;
    } catch (e) {
      if (kDebugMode) debugPrint('[Dashboard] load failed: $e');
      status.value = DashboardStatus.error;
    }
  }

  Future<void> toggleSession(String sessionId) async {
    if (expandedSessionId.value == sessionId) {
      expandedSessionId.value = null;
      return;
    }
    expandedSessionId.value = sessionId;
    if (journeys.containsKey(sessionId)) return;

    try {
      final snap = await _db!
          .collection('analytics_sessions')
          .doc(sessionId)
          .collection('events')
          .orderBy('seq')
          .limit(500)
          .get();
      journeys[sessionId] =
          snap.docs.map(JourneyEvent.fromDoc).toList(growable: false);
      journeys.refresh();
    } catch (e) {
      if (kDebugMode) debugPrint('[Dashboard] journey load failed: $e');
      journeys[sessionId] = const [];
      journeys.refresh();
    }
  }
}
