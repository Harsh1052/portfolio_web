import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/github_stats.dart';

/// Renders a GitHub-style contribution heatmap grid.
///
/// Each column = 1 week, each cell = 1 day.
/// Hovering a cell shows a tooltip with date + count.
class ContributionGraph extends StatelessWidget {
  const ContributionGraph({super.key, required this.stats});

  final GitHubStats stats;

  // Shade levels 0-4 (matches GitHub's design)
  static const List<Color> _levelColors = [
    Color(0xFFEBEDF0), // 0 — no contributions
    Color(0xFF9BE9A8), // 1 — low
    Color(0xFF40C463), // 2 — medium
    Color(0xFF30A14E), // 3 — high
    Color(0xFF216E39), // 4 — very high
  ];

  static const double _cellSize = 11.0;
  static const double _cellGap = 2.0;
  static const double _radius = 2.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // On mobile, scale the cell size down so the graph fits.
        final availableWidth = constraints.maxWidth;
        final weekCount = stats.weeks.length.toDouble();
        final naturalWidth = weekCount * (_cellSize + _cellGap);
        final scale = availableWidth < naturalWidth
            ? availableWidth / naturalWidth
            : 1.0;

        return Transform.scale(
          scale: scale,
          alignment: Alignment.centerLeft,
          child: _GraphGrid(
            weeks: stats.weeks,
            levelColors: _levelColors,
            cellSize: _cellSize,
            cellGap: _cellGap,
            radius: _radius,
          ),
        );
      },
    );
  }
}

class _GraphGrid extends StatelessWidget {
  const _GraphGrid({
    required this.weeks,
    required this.levelColors,
    required this.cellSize,
    required this.cellGap,
    required this.radius,
  });

  final List<ContributionWeek> weeks;
  final List<Color> levelColors;
  final double cellSize;
  final double cellGap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final week in weeks)
          Padding(
            padding: EdgeInsets.only(right: cellGap),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final day in week.days)
                  Padding(
                    padding: EdgeInsets.only(bottom: cellGap),
                    child: _DayCell(
                      day: day,
                      levelColors: levelColors,
                      size: cellSize,
                      radius: radius,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DayCell extends StatefulWidget {
  const _DayCell({
    required this.day,
    required this.levelColors,
    required this.size,
    required this.radius,
  });

  final ContributionDay day;
  final List<Color> levelColors;
  final double size;
  final double radius;

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _hovered = false;

  String get _tooltip {
    final count = widget.day.count;
    final date = widget.day.date;
    final label = count == 0
        ? 'No contributions'
        : '$count contribution${count > 1 ? 's' : ''}';
    final dateStr =
        '${_monthName(date.month)} ${date.day}, ${date.year}';
    return '$label on $dateStr';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final level = widget.day.level.clamp(0, 4);
    final baseColor = widget.levelColors[level];

    return Tooltip(
      message: _tooltip,
      textStyle: GoogleFonts.inter(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(4),
      ),
      waitDuration: const Duration(milliseconds: 200),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _hovered ? baseColor.withValues(alpha: 0.7) : baseColor,
            borderRadius: BorderRadius.circular(widget.radius),
            border: _hovered
                ? Border.all(color: AppColors.textSecondary, width: 0.5)
                : null,
          ),
        ),
      ),
    );
  }
}
