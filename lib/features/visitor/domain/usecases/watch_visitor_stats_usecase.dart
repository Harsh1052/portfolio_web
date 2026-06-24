import '../entities/visitor_stats.dart';
import '../repositories/visitor_repository.dart';

/// Streams real-time [VisitorStats] updates from the backend.
class WatchVisitorStatsUsecase {
  const WatchVisitorStatsUsecase(this._repository);

  final VisitorRepository _repository;

  Stream<VisitorStats> call() => _repository.watchStats();
}
