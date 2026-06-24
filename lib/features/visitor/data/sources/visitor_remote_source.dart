import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;
import '../../../../core/services/firebase_service.dart';
import '../../domain/entities/visitor_location.dart';
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
///
/// visitor_locations/{docId} {
///   city: String
///   region: String
///   country: String
///   latitude: double
///   longitude: double
///   timestamp: Timestamp
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

      // If it is a new session, run GeoIP lookup to fetch coordinates
      if (isNew) {
        _captureAndSaveGeoLocation().catchError((e) {
          if (kDebugMode) debugPrint('[VisitorSource] Geolocation capture failed: $e');
        });
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[VisitorSource] trackVisit failed: $e');
    }
  }

  /// Queries ipapi.co to obtain visitor geolocation data, then stores it in Firestore.
  Future<void> _captureAndSaveGeoLocation() async {
    try {
      // Short timeout so lookup fails quickly if blocked/offline
      final response = await GetConnect()
          .get('https://ipapi.co/json/')
          .timeout(const Duration(milliseconds: 2500));

      if (response.status.isOk && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        final city = body['city'] as String? ?? 'Unknown';
        final region = body['region'] as String? ?? 'Unknown';
        final country = body['country_name'] as String? ?? 'Unknown';
        final lat = (body['latitude'] as num?)?.toDouble() ?? 0.0;
        final lon = (body['longitude'] as num?)?.toDouble() ?? 0.0;

        // Skip coordinate lookup if invalid
        if (lat == 0.0 && lon == 0.0) return;

        await _db!.collection('visitor_locations').add({
          'city': city,
          'region': region,
          'country': country,
          'latitude': lat,
          'longitude': lon,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[VisitorSource] GeoIP fetch failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Real-time stream watchers
  // ---------------------------------------------------------------------------

  /// Emits [VisitorStats] every time the `visitors/stats` document changes.
  ///
  /// Uses `async*` to ensure Firebase is initialized before subscribing.
  /// Falls back to [VisitorStats.empty] on errors or if Firebase isn't ready.
  Stream<VisitorStats> watchStats() async* {
    if (!await _ensureReady()) {
      yield VisitorStats.empty;
      return;
    }

    yield* _statsDoc.snapshots().map((snap) {
      if (!snap.exists) return VisitorStats.empty;
      final data = snap.data()!;
      if (kDebugMode) debugPrint('[VisitorSource] stats snapshot: $data');
      return VisitorStats(
        totalViews: (data['totalViews'] as num?)?.toInt() ?? 0,
        uniqueSessions: (data['uniqueSessions'] as num?)?.toInt() ?? 0,
      );
    }).handleError((e) {
      if (kDebugMode) debugPrint('[VisitorSource] watchStats error: $e');
      // Stream continues with empty stats on transient errors.
    });
  }

  /// Emits a fresh list of [VisitorLocation] every time the
  /// `visitor_locations` collection changes (new visitor arrives, etc.).
  ///
  /// Falls back to a hardcoded set of Indian cities when Firebase is
  /// unavailable or the collection is empty (for local dev / first deploy).
  Stream<List<VisitorLocation>> watchLocations() async* {
    if (!await _ensureReady()) {
      yield _fallbackLocations();
      return;
    }

    yield* _db!
        .collection('visitor_locations')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((query) {
      if (query.docs.isEmpty) return _fallbackLocations();

      return query.docs.map((doc) {
        final data = doc.data();
        final timestamp =
            (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
        return VisitorLocation(
          city: data['city'] as String? ?? 'Unknown',
          region: data['region'] as String? ?? 'Unknown',
          country: data['country'] as String? ?? 'Unknown',
          latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
          timestamp: timestamp,
        );
      }).toList();
    }).handleError((e) {
      if (kDebugMode) debugPrint('[VisitorSource] watchLocations error: $e');
    });
  }

  // ---------------------------------------------------------------------------
  // Fallback seed data (major Indian cities for local dev / empty collection)
  // ---------------------------------------------------------------------------

  List<VisitorLocation> _fallbackLocations() => [
        VisitorLocation(
          city: 'Mumbai',
          region: 'Maharashtra',
          country: 'India',
          latitude: 19.0760,
          longitude: 72.8777,
          timestamp: DateTime.now(),
        ),
        VisitorLocation(
          city: 'Bengaluru',
          region: 'Karnataka',
          country: 'India',
          latitude: 12.9716,
          longitude: 77.5946,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        VisitorLocation(
          city: 'New Delhi',
          region: 'Delhi',
          country: 'India',
          latitude: 28.6139,
          longitude: 77.2090,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        VisitorLocation(
          city: 'Kolkata',
          region: 'West Bengal',
          country: 'India',
          latitude: 22.5726,
          longitude: 88.3639,
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        VisitorLocation(
          city: 'Chennai',
          region: 'Tamil Nadu',
          country: 'India',
          latitude: 13.0827,
          longitude: 80.2707,
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        VisitorLocation(
          city: 'Hyderabad',
          region: 'Telangana',
          country: 'India',
          latitude: 17.3850,
          longitude: 78.4867,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        VisitorLocation(
          city: 'Pune',
          region: 'Maharashtra',
          country: 'India',
          latitude: 18.5204,
          longitude: 73.8567,
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ];
}
