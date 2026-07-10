/// Event types tracked across the portfolio.
///
/// Every visitor interaction becomes an [AnalyticsEvent] with a session-scoped
/// sequence number, so a full journey can be replayed in exact order.
enum AnalyticsEventType {
  sessionStart('session_start'),
  pageView('page_view'),
  sectionEnter('section_enter'),
  sectionDwell('section_dwell'),
  click('click'),
  externalLink('external_link'),
  scrollDepth('scroll_depth'),
  game('game'),
  theme('theme');

  const AnalyticsEventType(this.key);
  final String key;
}

/// A single tracked interaction.
class AnalyticsEvent {
  AnalyticsEvent({
    required this.seq,
    required this.type,
    required this.name,
    this.props = const {},
  }) : timestampMs = DateTime.now().millisecondsSinceEpoch;

  /// Session-scoped monotonically increasing sequence — journey order.
  final int seq;
  final AnalyticsEventType type;

  /// Event label, e.g. `resume_download`, `section:work`, `project:appname`.
  final String name;

  /// Extra context, e.g. `{dwellMs: 12400}` or `{url: ...}`.
  final Map<String, Object?> props;

  final int timestampMs;

  Map<String, Object?> toMap() => {
        'seq': seq,
        'type': type.key,
        'name': name,
        if (props.isNotEmpty) 'props': props,
        'ts': timestampMs,
      };
}
