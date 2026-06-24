import '../entities/visitor_location.dart';
import '../repositories/visitor_repository.dart';

/// Streams real-time visitor location updates from the backend.
class WatchVisitorLocationsUsecase {
  const WatchVisitorLocationsUsecase(this._repository);

  final VisitorRepository _repository;

  Stream<List<VisitorLocation>> call() => _repository.watchVisitorLocations();
}
