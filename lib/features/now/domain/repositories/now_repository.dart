import '../entities/now_entry.dart';

/// Abstract contract for fetching "Now" status entries.
///
/// The domain layer depends on this interface; the data layer provides
/// [NowRepositoryImpl] which delegates to [NowMockSource].
abstract class NowRepository {
  /// Returns the current set of [NowEntry] items describing what Harsh
  /// is doing right now. Result is synchronous — data is in-memory.
  List<NowEntry> getEntries();
}
