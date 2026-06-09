import '../entities/visitor_location.dart';
import '../repositories/visitor_repository.dart';

/// Fetches the recent visitor locations from the repository.
class GetVisitorLocationsUsecase {
  const GetVisitorLocationsUsecase(this._repository);

  final VisitorRepository _repository;

  Future<List<VisitorLocation>> call() => _repository.getVisitorLocations();
}
