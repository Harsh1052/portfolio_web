import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import '../../../../core/services/firebase_service.dart';
import '../../domain/entities/visitor_stats.dart';

/// Firestore data source for visitor tracking.
///
/// Firestore document layout:
/// ```
/// visitors/stats {
///   totalViews:    int       // incremented on every page load
///   uniqueSessions: int      // incremented once per browser session
///   lastVisitedAt: Timestamp
/// }
/// ```
///
/// IMPORTANT: [FirebaseFirestore.instance] is obtained lazily inside
/// [_ensureReady], only after [FirebaseService.ensureInitialized] succeeds.
/// This prevents the `No Firebase App '[DEFAULT]'` crash that occurs when
/// [FirebaseFirestore.instance] is called before [Firebase.initializeApp].
class VisitorRemoteSource {
  VisitorRemoteSource(this._firebaseService);

  final FirebaseService _firebaseService;

  // Lazily initialized — set only after Firebase is ready.
  FirebaseFirestore? _db;

  static const _collection = 'visitors';
  static const _document = 'stats';
  static const _sessionKey = 'hs_visitor_session';

  DocumentReference<Map<String, dynamic>> get _statsDoc =>
      _db!.collection(_collection).doc(_document);

  /// Initializes Firebase if needed, then lazily sets up the Firestore client.
  /// Returns [true] if Firestore is ready to use, [false] otherwise.
  Future<bool> _ensureReady() async {
    if (_db != null) return true; // already initialized
    await _firebaseService.ensureInitialized();
    if (!_firebaseService.isInitialized) return false;
    // Safe to access FirebaseFirestore.instance now — Firebase.app() exists.
    _db = FirebaseFirestore.instance;
    return true;
  }

  /// Returns true if this is the first [trackVisit] call in the current
  /// browser tab session (sessionStorage is cleared on tab close).
  bool _isNewSession() {
    if (!kIsWeb) return false;
    try {
      // web 1.x: getItem / setItem use plain Dart Strings.
      final existing = web.window.sessionStorage.getItem(_sessionKey);
      if (existing != null) return false;
      final sessionId = _generateSessionId();
      web.window.sessionStorage.setItem(_sessionKey, sessionId);
      return true;
    } catch (e) {
      // Catches QuotaExceededError in Safari private mode — non-fatal.
      if (kDebugMode) debugPrint('[VisitorSource] sessionStorage error: $e');
      return false;
    }
  }

  String _generateSessionId() {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final rand = (ts * 9301 + 49297) % 233280;
    return '${ts}_$rand';
  }

  Future<void> trackVisit() async {
    if (!await _ensureReady()) return;
    final isNew = _isNewSession();
    try {
      await _statsDoc.set(
        {
          'totalViews': FieldValue.increment(1),
          if (isNew) 'uniqueSessions': FieldValue.increment(1),
          'lastVisitedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[VisitorSource] trackVisit failed: $e');
    }
  }

  Future<VisitorStats> getStats() async {
    if (!await _ensureReady()) return VisitorStats.empty;
    try {
      final snap = await _statsDoc.get();
      if (!snap.exists) return VisitorStats.empty;
      final data = snap.data()!;
      return VisitorStats(
        totalViews: (data['totalViews'] as num?)?.toInt() ?? 0,
        uniqueSessions: (data['uniqueSessions'] as num?)?.toInt() ?? 0,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[VisitorSource] getStats failed: $e');
      return VisitorStats.empty;
    }
  }
}
