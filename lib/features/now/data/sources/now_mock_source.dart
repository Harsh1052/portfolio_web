import '../../domain/entities/now_entry.dart';

/// In-memory data source for the "Now" section.
///
/// Update this file whenever Harsh's current focus changes.
/// No async needed — data is always in-memory.
class NowMockSource {
  const NowMockSource();

  List<NowEntry> getEntries() => const [
        NowEntry(
          emoji: '🏢',
          label: 'Currently at',
          value: 'FarmSetu',
          subValue: 'Sole Mobile & Web Engineer — serving 15K+ farmers',
        ),
        NowEntry(
          emoji: '🎯',
          label: 'Building toward',
          value: 'Full-stack engineer',
          subValue:
              'Learning what\'s on the other side of the API — not just consuming it, but designing it',
        ),
        NowEntry(
          emoji: '📚',
          label: 'Learning',
          value: 'Python',
          subValue: 'Backend, APIs, and the full-stack picture',
        ),
        NowEntry(
          emoji: '🔨',
          label: 'Side project',
          value: 'Trovo',
          subValue: 'Location-based treasure hunt game — all systems built, content phase next',
        ),
      ];
}
