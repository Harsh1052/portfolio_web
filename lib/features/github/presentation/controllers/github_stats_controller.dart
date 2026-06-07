import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../domain/entities/github_stats.dart';
import '../../domain/usecases/get_github_stats_usecase.dart';

enum GitHubStatus { initial, loading, loaded, error }

class GitHubStatsController extends GetxController {
  GitHubStatsController({required GetGitHubStatsUsecase usecase})
      : _usecase = usecase;

  final GetGitHubStatsUsecase _usecase;

  static const _username = 'Harsh1052';

  final status = GitHubStatus.initial.obs;
  final stats = GitHubStats.empty.obs;

  bool get isLoaded => status.value == GitHubStatus.loaded;
  bool get isError => status.value == GitHubStatus.error;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    status.value = GitHubStatus.loading;
    try {
      stats.value = await _usecase(_username);
      status.value = GitHubStatus.loaded;
    } catch (e) {
      if (kDebugMode) debugPrint('[GitHubStatsController] error: $e');
      status.value = GitHubStatus.error;
    }
  }

  /// Allows manual refresh from UI.
  @override
  Future<void> refresh() => _load();
}
