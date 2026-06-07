import '../entities/github_stats.dart';
import '../repositories/github_repository.dart';

/// Fetches GitHub contribution stats for a given [username].
///
/// Usage:
/// ```dart
/// final stats = await getGitHubStatsUsecase('Harsh1052');
/// ```
class GetGitHubStatsUsecase {
  const GetGitHubStatsUsecase(this._repository);

  final GitHubRepository _repository;

  Future<GitHubStats> call(String username) => _repository.getStats(username);
}
