/// A single status card shown in the "Now" section.
///
/// Each [NowEntry] represents one facet of what Harsh is currently doing —
/// e.g. current role, what he's learning, what he's building.
class NowEntry {
  const NowEntry({
    required this.emoji,
    required this.label,
    required this.value,
    this.subValue,
  });

  /// Decorative emoji shown left of the label (e.g. "🏢", "📚", "🔨").
  final String emoji;

  /// Short category label (e.g. "Currently at", "Learning", "Building").
  final String label;

  /// Primary value text (e.g. "FarmSetu — Sole Mobile & Web Engineer").
  final String value;

  /// Optional secondary detail shown below [value] in muted style.
  final String? subValue;
}
