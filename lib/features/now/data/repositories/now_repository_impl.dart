import '../../domain/entities/now_entry.dart';
import '../../domain/repositories/now_repository.dart';
import '../sources/now_mock_source.dart';

/// Concrete implementation of [NowRepository].
///
/// Delegates to [NowMockSource] — fully in-memory, no network call needed.
class NowRepositoryImpl implements NowRepository {
  const NowRepositoryImpl({required NowMockSource source}) : _source = source;

  final NowMockSource _source;

  @override
  List<NowEntry> getEntries() => _source.getEntries();
}
