import '../entities/visitor_location.dart';
import '../entities/visitor_stats.dart';

abstract class VisitorRepository {
  /// Tracks the current session (idempotent — safe to call multiple times).
  /// Increments [totalViews] always; increments [uniqueSessions] only on
  /// first call per browser session (sessionStorage-gated).
  Future<void> trackVisit();

  /// Returns the latest [VisitorStats] snapshot from the backend.
  Future<VisitorStats> getStats();

  /// Returns a list of recent visitor locations from the backend.
  Future<List<VisitorLocation>> getVisitorLocations();

  /// Saves the given visitor location details to the database.
  Future<void> saveVisitorLocation(VisitorLocation location);
}
