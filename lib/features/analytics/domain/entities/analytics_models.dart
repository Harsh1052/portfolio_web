import 'package:cloud_firestore/cloud_firestore.dart';

/// Rollup summary of one visitor session (from the session doc).
class SessionSummary {
  const SessionSummary({
    required this.id,
    required this.startedAt,
    required this.lastSeenAt,
    required this.durationMs,
    required this.maxScrollPct,
    required this.eventCount,
    required this.dwell,
    required this.clicks,
    required this.userAgent,
    required this.screen,
    required this.referrer,
  });

  final String id;
  final DateTime? startedAt;
  final DateTime? lastSeenAt;
  final int durationMs;
  final int maxScrollPct;
  final int eventCount;

  /// Section name → total dwell ms.
  final Map<String, int> dwell;

  /// Click name → count.
  final Map<String, int> clicks;

  final String userAgent;
  final String screen;
  final String referrer;

  bool get isMobile =>
      userAgent.contains('Mobi') || userAgent.contains('Android');

  factory SessionSummary.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    Map<String, int> intMap(Object? raw) => {
          if (raw is Map)
            for (final e in raw.entries)
              e.key.toString(): (e.value as num?)?.toInt() ?? 0,
        };
    return SessionSummary(
      id: doc.id,
      startedAt: (d['startedAt'] as Timestamp?)?.toDate(),
      lastSeenAt: (d['lastSeenAt'] as Timestamp?)?.toDate(),
      durationMs: (d['durationMs'] as num?)?.toInt() ?? 0,
      maxScrollPct: (d['maxScrollPct'] as num?)?.toInt() ?? 0,
      eventCount: (d['eventCount'] as num?)?.toInt() ?? 0,
      dwell: intMap(d['dwell']),
      clicks: intMap(d['clicks']),
      userAgent: d['userAgent'] as String? ?? '',
      screen: d['screen'] as String? ?? '',
      referrer: d['referrer'] as String? ?? '',
    );
  }
}

/// One step of a visitor's journey (from the events subcollection).
class JourneyEvent {
  const JourneyEvent({
    required this.seq,
    required this.type,
    required this.name,
    required this.props,
    required this.timestampMs,
  });

  final int seq;
  final String type;
  final String name;
  final Map<String, Object?> props;
  final int timestampMs;

  factory JourneyEvent.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    return JourneyEvent(
      seq: (d['seq'] as num?)?.toInt() ?? 0,
      type: d['type'] as String? ?? '',
      name: d['name'] as String? ?? '',
      props: (d['props'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v as Object?),
          ) ??
          const {},
      timestampMs: (d['ts'] as num?)?.toInt() ?? 0,
    );
  }
}
