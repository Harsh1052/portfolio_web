import '../entities/visitor_location.dart';
import '../entities/visitor_stats.dart';

abstract class VisitorRepository {
  /// Tracks the current session (idempotent — safe to call multiple times).
  /// Increments [totalViews] always; increments [uniqueSessions] only on
  /// first call per browser session (sessionStorage-gated).
  Future<void> trackVisit();

  /// Emits [VisitorStats] snapshots in real-time as the backend document
  /// changes (e.g. new visitor increments the counter).
  Stream<VisitorStats> watchStats();

  /// Emits the latest list of visitor locations in real-time as new
  /// entries are added to the backend collection.
  Stream<List<VisitorLocation>> watchVisitorLocations();
}
