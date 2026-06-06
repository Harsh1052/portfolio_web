import '../repositories/visitor_repository.dart';

/// Triggers a visit tracking event.
/// Call once on app launch — idempotent within the same browser session.
class TrackVisitUsecase {
  const TrackVisitUsecase(this._repository);

  final VisitorRepository _repository;

  Future<void> call() => _repository.trackVisit();
}
