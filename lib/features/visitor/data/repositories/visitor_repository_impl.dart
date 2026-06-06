import '../../domain/entities/visitor_stats.dart';
import '../../domain/repositories/visitor_repository.dart';
import '../sources/visitor_remote_source.dart';

class VisitorRepositoryImpl implements VisitorRepository {
  const VisitorRepositoryImpl({required this.remoteSource});

  final VisitorRemoteSource remoteSource;

  @override
  Future<void> trackVisit() => remoteSource.trackVisit();

  @override
  Future<VisitorStats> getStats() => remoteSource.getStats();
}
