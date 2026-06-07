import '../../domain/entities/github_stats.dart';
import '../../domain/repositories/github_repository.dart';
import '../sources/github_remote_source.dart';

/// Implements [GitHubRepository] with an in-memory 24h cache to avoid
/// hammering the API on every hot reload / navigation.
class GitHubRepositoryImpl implements GitHubRepository {
  GitHubRepositoryImpl({required GitHubRemoteSource remoteSource})
      : _remote = remoteSource;

  final GitHubRemoteSource _remote;

  GitHubStats? _cachedStats;
  DateTime? _cacheTime;

  static const _cacheTtl = Duration(hours: 24);

  @override
  Future<GitHubStats> getStats(String username) async {
    if (_cachedStats != null && _cacheTime != null) {
      final age = DateTime.now().difference(_cacheTime!);
      if (age < _cacheTtl) return _cachedStats!;
    }

    final stats = await _remote.fetchStats(username);
    _cachedStats = stats;
    _cacheTime = DateTime.now();
    return stats;
  }
}
