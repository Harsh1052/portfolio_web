import '../../domain/entities/visitor_location.dart';
import '../../domain/entities/visitor_stats.dart';
import '../../domain/repositories/visitor_repository.dart';
import '../sources/visitor_remote_source.dart';

class VisitorRepositoryImpl implements VisitorRepository {
  const VisitorRepositoryImpl({required this.remoteSource});

  final VisitorRemoteSource remoteSource;

  @override
  Future<void> trackVisit() => remoteSource.trackVisit();

  @override
  Stream<VisitorStats> watchStats() => remoteSource.watchStats();

  @override
  Stream<List<VisitorLocation>> watchVisitorLocations() =>
      remoteSource.watchLocations();
}
