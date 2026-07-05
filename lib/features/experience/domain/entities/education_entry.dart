/// A single education entry.
class EducationEntry {
  const EducationEntry({
    required this.degree,
    required this.institution,
    required this.location,
    required this.startYear,
    required this.endYear,
    required this.description,
  });

  final String degree;
  final String institution;
  final String location;
  final String startYear;
  final String endYear;
  final String description;
}
