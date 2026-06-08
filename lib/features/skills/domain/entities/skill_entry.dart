/// A single skill entry within a [TimelineYear].
///
/// [label] is the skill name shown on the tag.
/// [tooltip] is a short sentence giving recruiter-readable context
/// (e.g. "Used in FarmSetu — moved chart work to a Dart Isolate").
class SkillEntry {
  const SkillEntry({
    required this.label,
    required this.tooltip,
  });

  final String label;
  final String tooltip;
}
