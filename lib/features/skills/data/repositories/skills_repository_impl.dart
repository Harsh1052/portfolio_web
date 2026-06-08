import '../../domain/entities/timeline_year.dart';
import '../../domain/repositories/skills_repository.dart';
import '../sources/skills_mock_source.dart';

/// Concrete implementation of [SkillsRepository].
///
/// Delegates to [SkillsMockSource] — fully in-memory, no network needed.
class SkillsRepositoryImpl implements SkillsRepository {
  const SkillsRepositoryImpl({required SkillsMockSource source})
      : _source = source;

  final SkillsMockSource _source;

  @override
  List<TimelineYear> getTimeline() => _source.getTimeline();
}
