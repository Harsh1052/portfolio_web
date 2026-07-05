/// A single work experience / role entry in the career timeline.
class ExperienceEntry {
  const ExperienceEntry({
    required this.position,
    required this.company,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.employmentType,
    required this.responsibilities,
    required this.technologies,
  });

  final String position;
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final String employmentType;
  final List<String> responsibilities;
  final List<String> technologies;

  /// Whether this is the current/active role.
  bool get isCurrent => endDate == 'Present';
}
