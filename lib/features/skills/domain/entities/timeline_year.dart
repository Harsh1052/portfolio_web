import 'skill_entry.dart';

/// A group of [SkillEntry] items acquired in a given [year].
///
/// Used by the skills timeline to render one row per year showing
/// what tools, patterns, and technologies Harsh picked up that year.
class TimelineYear {
  const TimelineYear({
    required this.year,
    required this.skills,
  });

  /// The calendar year (e.g. 2022, 2023).
  final int year;

  /// Skills acquired / practised in this year.
  final List<SkillEntry> skills;
}
