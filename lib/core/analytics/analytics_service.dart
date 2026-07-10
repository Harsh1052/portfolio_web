import 'dart:async';
import 'dart:js_interop';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;
import '../services/firebase_service.dart';
import 'analytics_event.dart';

/// First-party event analytics — every visitor interaction is captured as an
/// ordered event stream owned by us (Firestore), not a third party.
///
/// Firestore layout:
/// ```
/// analytics_sessions/{sessionId} {
///   startedAt / lastSeenAt : Timestamp
///   userAgent, language, referrer, screen : String   // device context
///   eventCount   : int                  // rollups for cheap dashboards ↓
///   durationMs   : int
///   maxScrollPct : int
///   dwell.{section}     : int (ms)
///   clicks.{name}       : int
/// }
/// analytics_sessions/{sessionId}/events/{autoId} {
///   seq, type, name, props, ts          // full journey, replayable in order
/// }
/// ```
///
/// Behaviour notes:
/// * Events are queued in memory and flushed in a single WriteBatch every
///   [_flushInterval], when the queue grows past [_maxQueue], or when the tab
///   is hidden — so a bouncing visitor still gets recorded.
/// * Everything is fail-silent: no Firebase, no network, no problem.
/// * Debug builds never write (mirrors the visitor-tracking policy).
class AnalyticsService extends GetxService {
  AnalyticsService(this._firebaseService);

  final FirebaseService _firebaseService;

  static const _sessionKey = 'hs_analytics_session';
  static const _visitorSessionKey = 'hs_visitor_session';
  static const _flushInterval = Duration(seconds: 8);
  static const _maxQueue = 25;

  FirebaseFirestore? _db;
  late final String sessionId;
  final int _sessionStartMs = DateTime.now().millisecondsSinceEpoch;

  final List<AnalyticsEvent> _queue = [];
  int _seq = 0;
  Timer? _flushTimer;
  bool _metaWritten = false;

  // Per-flush rollup deltas (merged into the session doc).
  final Map<String, int> _dwellDelta = {};
  final Map<String, int> _clickDelta = {};
  int _maxScrollPct = 0;

  // Active section dwell timers.
  final Map<String, int> _sectionEnteredAt = {};

  /// Global helper — safe to call from anywhere; no-ops when unregistered.
  static AnalyticsService? get _instance =>
      Get.isRegistered<AnalyticsService>() ? Get.find<AnalyticsService>() : null;

  static void log(
    AnalyticsEventType type,
    String name, [
    Map<String, Object?> props = const {},
  ]) =>
      _instance?._log(type, name, props);

  static void click(String name, [Map<String, Object?> props = const {}]) =>
      _instance?._click(name, props);

  /// Route-level page view (deduped against the last one, since GetX can
  /// report the same route multiple times during a transition).
  static void page(String route) => _instance?._page(route);

  static void externalLink(String name, String url) =>
      _instance?._log(AnalyticsEventType.externalLink, name, {'url': url});

  static void sectionEnter(String section) =>
      _instance?._sectionEnter(section);

  static void sectionExit(String section) => _instance?._sectionExit(section);

  static void scrollDepth(int pct) => _instance?._scrollDepth(pct);

  /// Hard kill-switch: debug/dev runs never record anything.
  static bool get _trackingDisabled => kDebugMode;

  @override
  void onInit() {
    super.onInit();
    sessionId = _resolveSessionId();
    if (_trackingDisabled) {
      debugPrint('[Analytics] debug mode — tracking disabled');
      return; // no initial events, no flush timer, no listeners
    }
    _log(AnalyticsEventType.sessionStart, 'session_start');
    _page('/');
    _flushTimer = Timer.periodic(_flushInterval, (_) => _flush());
    _installLifecycleFlush();
  }

  String? _lastPageRoute;

  void _page(String route) {
    if (route.isEmpty || route == _lastPageRoute) return;
    _lastPageRoute = route;
    _log(AnalyticsEventType.pageView, route);
  }

  @override
  void onClose() {
    _flushTimer?.cancel();
    _flush();
    super.onClose();
  }

  // ── Session identity ────────────────────────────────────────────────────

  /// Reuses the visitor-tracking session id when available so analytics and
  /// the visitor map describe the same session.
  String _resolveSessionId() {
    if (!kIsWeb) return _newId();
    try {
      final visitor = web.window.sessionStorage.getItem(_visitorSessionKey);
      if (visitor != null && visitor.isNotEmpty) return visitor;
      final existing = web.window.sessionStorage.getItem(_sessionKey);
      if (existing != null && existing.isNotEmpty) return existing;
      final id = _newId();
      web.window.sessionStorage.setItem(_sessionKey, id);
      return id;
    } catch (_) {
      return _newId(); // Safari private mode etc.
    }
  }

  String _newId() {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final rand = (ts * 9301 + 49297) % 233280;
    return '${ts}_$rand';
  }

  // ── Tracking API (instance) ─────────────────────────────────────────────

  void _log(
    AnalyticsEventType type,
    String name, [
    Map<String, Object?> props = const {},
  ]) {
    if (_trackingDisabled) {
      debugPrint('[Analytics] (debug, not recorded) ${type.key}: $name');
      return;
    }
    _queue.add(AnalyticsEvent(seq: _seq++, type: type, name: name, props: props));
    if (_queue.length >= _maxQueue) _flush();
  }

  void _click(String name, Map<String, Object?> props) {
    final safe = _sanitize(name);
    if (!_trackingDisabled) {
      _clickDelta[safe] = (_clickDelta[safe] ?? 0) + 1;
    }
    _log(AnalyticsEventType.click, safe, props);
  }

  void _sectionEnter(String section) {
    if (_trackingDisabled) return;
    final safe = _sanitize(section);
    if (_sectionEnteredAt.containsKey(safe)) return;
    _sectionEnteredAt[safe] = DateTime.now().millisecondsSinceEpoch;
    _log(AnalyticsEventType.sectionEnter, safe);
  }

  void _sectionExit(String section) {
    if (_trackingDisabled) return;
    final safe = _sanitize(section);
    final enteredAt = _sectionEnteredAt.remove(safe);
    if (enteredAt == null) return;
    final dwellMs = DateTime.now().millisecondsSinceEpoch - enteredAt;
    if (dwellMs < 400) return; // ignore scroll fly-bys
    _dwellDelta[safe] = (_dwellDelta[safe] ?? 0) + dwellMs;
    _log(AnalyticsEventType.sectionDwell, safe, {'dwellMs': dwellMs});
  }

  void _scrollDepth(int pct) {
    if (_trackingDisabled) return;
    if (pct <= _maxScrollPct) return;
    _maxScrollPct = pct;
    _log(AnalyticsEventType.scrollDepth, 'scroll_$pct', {'pct': pct});
  }

  /// Firestore field keys cannot contain `.` `/` etc.
  String _sanitize(String s) =>
      s.replaceAll(RegExp(r'[.\/\[\]*`~]'), '_').trim();

  // ── Flush pipeline ──────────────────────────────────────────────────────

  Future<bool> _ensureReady() async {
    if (_db != null) return true;
    await _firebaseService.ensureInitialized();
    if (!_firebaseService.isInitialized) return false;
    _db = FirebaseFirestore.instance;
    return true;
  }

  Future<void> _flush() async {
    // Second line of defense — events never queue in debug, but even if one
    // slipped through, nothing is ever written from a debug build.
    if (_trackingDisabled) {
      _queue.clear();
      _dwellDelta.clear();
      _clickDelta.clear();
      return;
    }
    if (_queue.isEmpty && _dwellDelta.isEmpty && _clickDelta.isEmpty) return;
    if (!await _ensureReady()) return;

    // Snapshot + clear state up-front so a slow write never double-sends.
    final events = List<AnalyticsEvent>.from(_queue);
    final dwell = Map<String, int>.from(_dwellDelta);
    final clicks = Map<String, int>.from(_clickDelta);
    _queue.clear();
    _dwellDelta.clear();
    _clickDelta.clear();

    try {
      final sessionDoc = _db!.collection('analytics_sessions').doc(sessionId);
      final batch = _db!.batch();

      batch.set(sessionDoc, {
        if (!_metaWritten) ...{
          'startedAt': FieldValue.serverTimestamp(),
          ..._deviceContext(),
        },
        'lastSeenAt': FieldValue.serverTimestamp(),
        'durationMs': DateTime.now().millisecondsSinceEpoch - _sessionStartMs,
        'maxScrollPct': _maxScrollPct,
        'eventCount': FieldValue.increment(events.length),
        if (dwell.isNotEmpty)
          'dwell': {
            for (final e in dwell.entries) e.key: FieldValue.increment(e.value),
          },
        if (clicks.isNotEmpty)
          'clicks': {
            for (final e in clicks.entries)
              e.key: FieldValue.increment(e.value),
          },
      }, SetOptions(merge: true));

      for (final event in events) {
        batch.set(sessionDoc.collection('events').doc(), event.toMap());
      }

      await batch.commit();
      _metaWritten = true;
    } catch (e) {
      if (kDebugMode) debugPrint('[Analytics] flush failed: $e');
    }
  }

  Map<String, Object?> _deviceContext() {
    if (!kIsWeb) return {};
    try {
      return {
        'userAgent': web.window.navigator.userAgent,
        'language': web.window.navigator.language,
        'referrer': web.document.referrer,
        'screen':
            '${web.window.screen.width}x${web.window.screen.height}',
      };
    } catch (_) {
      return {};
    }
  }

  /// Flush pending events when the visitor switches tabs or leaves —
  /// otherwise short visits would never be recorded.
  void _installLifecycleFlush() {
    if (!kIsWeb) return;
    try {
      web.document.addEventListener(
        'visibilitychange',
        ((web.Event _) {
          if (web.document.visibilityState == 'hidden') {
            // Close out any open section timers so dwell isn't lost.
            for (final section in List<String>.from(_sectionEnteredAt.keys)) {
              _sectionExit(section);
            }
            _flush();
          }
        }).toJS,
      );
    } catch (_) {
      // Non-fatal — periodic flush still covers most sessions.
    }
  }
}
