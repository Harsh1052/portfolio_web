import '../entities/timeline_year.dart';

/// Abstract contract for fetching the skills timeline data.
///
/// Returns the list of [TimelineYear] entries ordered oldest → newest.
/// Data is static / in-memory — result is synchronous.
abstract class SkillsRepository {
  List<TimelineYear> getTimeline();
}
