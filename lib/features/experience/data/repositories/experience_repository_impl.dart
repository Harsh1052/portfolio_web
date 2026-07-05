import '../../domain/entities/experience_entry.dart';
import '../../domain/entities/education_entry.dart';
import '../../domain/repositories/experience_repository.dart';
import '../sources/experience_mock_source.dart';

/// Concrete implementation of [ExperienceRepository].
///
/// Delegates to [ExperienceMockSource] for in-memory data.
class ExperienceRepositoryImpl implements ExperienceRepository {
  const ExperienceRepositoryImpl({required this.source});

  final ExperienceMockSource source;

  @override
  List<ExperienceEntry> getExperience() => source.getExperience();

  @override
  List<EducationEntry> getEducation() => source.getEducation();
}
