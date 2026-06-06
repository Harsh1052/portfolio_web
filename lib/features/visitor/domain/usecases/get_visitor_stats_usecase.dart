import '../entities/visitor_stats.dart';
import '../repositories/visitor_repository.dart';

/// Fetches the current [VisitorStats] from the backend.
class GetVisitorStatsUsecase {
  const GetVisitorStatsUsecase(this._repository);

  final VisitorRepository _repository;

  Future<VisitorStats> call() => _repository.getStats();
}
