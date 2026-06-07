import '../entities/github_stats.dart';

/// Contract for the GitHub data layer.
abstract interface class GitHubRepository {
  /// Returns [GitHubStats] for [username] (current year).
  /// Implementations may cache the result to avoid redundant network calls.
  Future<GitHubStats> getStats(String username);
}
