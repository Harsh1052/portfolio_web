/// Represents a single day's contribution data.
class ContributionDay {
  const ContributionDay({
    required this.date,
    required this.count,
    required this.level, // 0-4 (GitHub's shade levels)
  });

  final DateTime date;
  final int count;
  final int level;
}

/// Represents a full contribution week (up to 7 days).
class ContributionWeek {
  const ContributionWeek({required this.days});
  final List<ContributionDay> days;
}

/// Aggregated GitHub contribution stats for a user.
class GitHubStats {
  const GitHubStats({
    required this.username,
    required this.totalContributions,
    required this.weeks,
  });

  final String username;
  final int totalContributions;

  /// 52–53 weeks ordered oldest→newest.
  final List<ContributionWeek> weeks;

  /// Longest streak of consecutive contribution days.
  int get longestStreak {
    int best = 0;
    int current = 0;
    for (final week in weeks) {
      for (final day in week.days) {
        if (day.count > 0) {
          current++;
          if (current > best) best = current;
        } else {
          current = 0;
        }
      }
    }
    return best;
  }

  /// Current streak (counting backwards from today).
  int get currentStreak {
    final allDays = weeks.expand((w) => w.days).toList();
    int streak = 0;
    final today = DateTime.now();
    // Walk backward from today
    for (int i = allDays.length - 1; i >= 0; i--) {
      final d = allDays[i];
      final diff = today.difference(d.date).inDays;
      if (diff > 1) break; // Gap — streak broken
      if (d.count > 0) {
        streak++;
      } else if (diff == 0) {
        // Today with 0 contributions is ok — check yesterday
        continue;
      } else {
        break;
      }
    }
    return streak;
  }

  static const GitHubStats empty = GitHubStats(
    username: '',
    totalContributions: 0,
    weeks: [],
  );
}
