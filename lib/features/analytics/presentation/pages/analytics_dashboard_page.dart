import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/analytics_models.dart';
import '../controllers/analytics_dashboard_controller.dart';

/// Hidden admin dashboard — `/analytics`.
///
/// Renders visitor analytics straight from Firestore: headline stats,
/// section dwell-time bars, top clicks, and per-session journey timelines.
class AnalyticsDashboardPage extends StatelessWidget {
  const AnalyticsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalyticsDashboardController>();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          switch (controller.status.value) {
            case DashboardStatus.loading:
              return const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.accent,
                  ),
                ),
              );
            case DashboardStatus.error:
              return _Message(
                text: 'Could not load analytics.\nIs Firebase configured?',
                onRetry: controller.loadSessions,
              );
            case DashboardStatus.empty:
              return _Message(
                text: 'No sessions recorded yet.\n'
                    'Visit the live site (release build) and check back.',
                onRetry: controller.loadSessions,
              );
            case DashboardStatus.loaded:
              return _Dashboard(controller: controller);
          }
        }),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.onRetry});

  final String text;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: AppTextStyles.body, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.controller});

  final AnalyticsDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Visitor Analytics', style: AppTextStyles.h2),
                    ),
                    IconButton(
                      tooltip: 'Refresh',
                      onPressed: controller.loadSessions,
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                    ),
                  ],
                ),
                Text(
                  'Last ${controller.totalSessions} sessions · first-party, no cookies',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 28),
                _StatRow(controller: controller),
                const SizedBox(height: 36),
                _SectionCard(
                  title: 'Time spent per section',
                  child: _DwellBars(entries: controller.dwellBySection),
                ),
                const SizedBox(height: 24),
                _SectionCard(
                  title: 'Top clicks',
                  child: _TopClicks(entries: controller.topClicks),
                ),
                const SizedBox(height: 24),
                _SectionCard(
                  title: 'Sessions',
                  child: _SessionList(controller: controller),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Headline stats ─────────────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  const _StatRow({required this.controller});

  final AnalyticsDashboardController controller;

  @override
  Widget build(BuildContext context) {
    final d = controller.avgDuration;
    final mins = d.inMinutes;
    final secs = d.inSeconds % 60;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _StatCard(label: 'Sessions', value: '${controller.totalSessions}'),
        _StatCard(
          label: 'Avg. time on site',
          value: mins > 0 ? '${mins}m ${secs}s' : '${secs}s',
        ),
        _StatCard(label: 'Avg. scroll depth', value: '${controller.avgScrollPct}%'),
        _StatCard(label: 'Events captured', value: '${controller.totalEvents}'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.metric),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

// ── Shared card shell ──────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h3),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// ── Dwell bars ─────────────────────────────────────────────────────────────

class _DwellBars extends StatelessWidget {
  const _DwellBars({required this.entries});

  final List<MapEntry<String, int>> entries;

  String _fmt(int ms) {
    final s = ms ~/ 1000;
    if (s < 60) return '${s}s';
    return '${s ~/ 60}m ${s % 60}s';
  }

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Text('No dwell data yet.', style: AppTextStyles.caption);
    }
    final max = entries.first.value.toDouble();
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  child: Text(
                    e.key,
                    style: GoogleFonts.jetBrainsMono(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: max <= 0 ? 0 : e.value / max,
                      minHeight: 10,
                      color: AppColors.accent,
                      backgroundColor: cs.outline.withValues(alpha: 0.35),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 64,
                  child: Text(
                    _fmt(e.value),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.jetBrainsMono(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Top clicks ─────────────────────────────────────────────────────────────

class _TopClicks extends StatelessWidget {
  const _TopClicks({required this.entries});

  final List<MapEntry<String, int>> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Text('No clicks recorded yet.', style: AppTextStyles.caption);
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final e in entries.take(20))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: Text(
              '${e.key} · ${e.value}',
              style: GoogleFonts.jetBrainsMono(fontSize: 12),
            ),
          ),
      ],
    );
  }
}

// ── Session list + journey timeline ───────────────────────────────────────

class _SessionList extends StatelessWidget {
  const _SessionList({required this.controller});

  final AnalyticsDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expanded = controller.expandedSessionId.value;
      return Column(
        children: [
          for (final s in controller.sessions)
            _SessionTile(
              session: s,
              isExpanded: expanded == s.id,
              journey: controller.journeys[s.id],
              onTap: () => controller.toggleSession(s.id),
            ),
        ],
      );
    });
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.session,
    required this.isExpanded,
    required this.journey,
    required this.onTap,
  });

  final SessionSummary session;
  final bool isExpanded;
  final List<JourneyEvent>? journey;
  final VoidCallback onTap;

  String _ago(DateTime? t) {
    if (t == null) return '—';
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final secs = session.durationMs ~/ 1000;
    final duration = secs < 60 ? '${secs}s' : '${secs ~/ 60}m ${secs % 60}s';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isExpanded ? AppColors.accent.withValues(alpha: 0.5) : cs.outline,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    session.isMobile
                        ? Icons.smartphone_rounded
                        : Icons.desktop_windows_rounded,
                    size: 16,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _ago(session.lastSeenAt),
                      style: AppTextStyles.body,
                    ),
                  ),
                  _Meta('${session.eventCount} events'),
                  _Meta(duration),
                  _Meta('${session.maxScrollPct}% scroll'),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 18,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) _JourneyTimeline(journey: journey),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(text, style: GoogleFonts.jetBrainsMono(fontSize: 11.5)),
    );
  }
}

class _JourneyTimeline extends StatelessWidget {
  const _JourneyTimeline({required this.journey});

  final List<JourneyEvent>? journey;

  static const _icons = <String, IconData>{
    'session_start': Icons.play_arrow_rounded,
    'page_view': Icons.visibility_rounded,
    'section_enter': Icons.south_rounded,
    'section_dwell': Icons.schedule_rounded,
    'click': Icons.touch_app_rounded,
    'external_link': Icons.open_in_new_rounded,
    'scroll_depth': Icons.swap_vert_rounded,
    'game': Icons.bug_report_rounded,
    'theme': Icons.dark_mode_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final events = journey;

    if (events == null) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: AppColors.accent,
          ),
        ),
      );
    }
    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text('No journey events.', style: AppTextStyles.caption),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: cs.outline, height: 16),
          for (final e in events)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${e.seq}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: cs.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  Icon(
                    _icons[e.type] ?? Icons.circle_outlined,
                    size: 14,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _describe(e),
                      style: GoogleFonts.jetBrainsMono(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _describe(JourneyEvent e) {
    switch (e.type) {
      case 'section_dwell':
        final ms = (e.props['dwellMs'] as num?)?.toInt() ?? 0;
        return '${e.name} · stayed ${(ms / 1000).toStringAsFixed(1)}s';
      case 'section_enter':
        return 'entered ${e.name}';
      case 'scroll_depth':
        return 'scrolled to ${e.props['pct']}%';
      case 'external_link':
        return '${e.name} → ${e.props['url'] ?? ''}';
      default:
        return e.name;
    }
  }
}
