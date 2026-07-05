import '../entities/experience_entry.dart';
import '../entities/education_entry.dart';

/// Abstract contract for fetching career history data.
///
/// Data is static / in-memory — results are synchronous.
abstract class ExperienceRepository {
  /// Work experience entries ordered newest → oldest.
  List<ExperienceEntry> getExperience();

  /// Education entries.
  List<EducationEntry> getEducation();
}
