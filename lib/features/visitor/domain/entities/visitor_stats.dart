/// Immutable entity representing aggregated visitor statistics.
class VisitorStats {
  const VisitorStats({
    required this.totalViews,
    required this.uniqueSessions,
  });

  /// Every page load (incremented on each session start).
  final int totalViews;

  /// Distinct sessions (deduplicated via sessionStorage UUID).
  final int uniqueSessions;

  static const empty = VisitorStats(totalViews: 0, uniqueSessions: 0);

  @override
  String toString() =>
      'VisitorStats(totalViews: $totalViews, uniqueSessions: $uniqueSessions)';
}
