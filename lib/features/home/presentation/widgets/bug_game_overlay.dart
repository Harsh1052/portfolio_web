import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/analytics/analytics_event.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../content/presentation/controllers/content_controller.dart';

// ─── Bug Model ──────────────────────────────────────────────────────────────

class _Bug {
  final String id;
  double x, y;
  final double speed;
  final double angle;
  final bool movesRight;
  bool isAlive;
  double squashProgress; // 0 → 1 during squash anim

  _Bug({
    required this.id,
    required this.x,
    required this.y,
    required this.speed,
    required this.angle,
  })  : isAlive = true,
        squashProgress = 0.0,
        movesRight = math.cos(angle) > 0;

  void update(double dt) {
    if (!isAlive) return;
    x += math.cos(angle) * speed * dt;
    y += math.sin(angle) * speed * dt;
  }

  bool isOffScreen(Size size) {
    return x < -50 ||
        x > size.width + 50 ||
        y < -50 ||
        y > size.height + 50;
  }

  bool get isDone => !isAlive && squashProgress >= 1.0;
}

// ─── Bug Game Overlay ───────────────────────────────────────────────────────

/// Full-screen overlay that spawns crawling bugs which the visitor can click
/// to squash. After squashing 5, an achievement card with a CTA appears.
class BugGameOverlay extends StatefulWidget {
  const BugGameOverlay({super.key});

  @override
  State<BugGameOverlay> createState() => _BugGameOverlayState();
}

class _BugGameOverlayState extends State<BugGameOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  final List<_Bug> _bugs = [];
  final _rng = math.Random();

  int _squashCount = 0;
  bool _showAchievement = false;
  bool _achievementDismissed = false;
  Timer? _spawnTimer;
  DateTime _lastFrameTime = DateTime.now();
  Size _screenSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _anim.addListener(_onTick);

    // First bug spawns 15-20s after page load.
    final initialDelay = 15 + _rng.nextInt(6);
    _spawnTimer = Timer(Duration(seconds: initialDelay), () {
      _spawnBug();
      _scheduleNextSpawn();
    });
  }

  void _scheduleNextSpawn() {
    final delay = 25 + _rng.nextInt(20); // 25-45s between spawns
    _spawnTimer = Timer(Duration(seconds: delay), () {
      final aliveCount = _bugs.where((b) => b.isAlive).length;
      if (aliveCount < 2) {
        _spawnBug();
      }
      _scheduleNextSpawn();
    });
  }

  void _spawnBug() {
    if (_screenSize == Size.zero) return;

    final edge = _rng.nextInt(4);
    double startX, startY, baseAngle;

    switch (edge) {
      case 0: // top → crawls down
        startX = 60 + _rng.nextDouble() * (_screenSize.width - 120);
        startY = -30;
        baseAngle = math.pi / 2;
      case 1: // right → crawls left
        startX = _screenSize.width + 30;
        startY = 60 + _rng.nextDouble() * (_screenSize.height - 120);
        baseAngle = math.pi;
      case 2: // bottom → crawls up
        startX = 60 + _rng.nextDouble() * (_screenSize.width - 120);
        startY = _screenSize.height + 30;
        baseAngle = -math.pi / 2;
      default: // left → crawls right
        startX = -30;
        startY = 60 + _rng.nextDouble() * (_screenSize.height - 120);
        baseAngle = 0;
    }

    // Add ±30° random spread to direction.
    final spread = (_rng.nextDouble() - 0.5) * math.pi / 3;
    final angle = baseAngle + spread;
    final speed = 35.0 + _rng.nextDouble() * 25; // 35-60 px/s

    _bugs.add(_Bug(
      id: '${DateTime.now().millisecondsSinceEpoch}_${_rng.nextInt(9999)}',
      x: startX,
      y: startY,
      speed: speed,
      angle: angle,
    ));

    // Start frame loop if not already running.
    if (!_anim.isAnimating) {
      _lastFrameTime = DateTime.now();
      _anim.repeat();
    }
  }

  void _onTick() {
    final now = DateTime.now();
    final dt = now.difference(_lastFrameTime).inMicroseconds / 1000000.0;
    _lastFrameTime = now;

    if (dt > 0.15) return; // skip frame-drops / background returns

    for (final bug in _bugs) {
      if (bug.isAlive) {
        bug.update(dt);
      } else {
        bug.squashProgress = (bug.squashProgress + dt * 3.5).clamp(0.0, 1.0);
      }
    }

    // Remove bugs that are done animating or crawled off screen.
    _bugs.removeWhere(
        (b) => b.isDone || (b.isAlive && b.isOffScreen(_screenSize)));

    // Pause frame loop when nothing to animate.
    if (_bugs.isEmpty) {
      _anim.stop();
    }

    setState(() {});
  }

  void _squashBug(_Bug bug) {
    if (!bug.isAlive) return;
    bug.isAlive = false;
    _squashCount++;
    AnalyticsService.log(
      AnalyticsEventType.game,
      'bug_squashed',
      {'count': _squashCount},
    );
    if (_squashCount >= 5 && !_achievementDismissed) {
      _showAchievement = true;
      AnalyticsService.log(AnalyticsEventType.game, 'bug_hunt_achievement');
    }
  }

  void _dismissAchievement() {
    setState(() {
      _achievementDismissed = true;
      _showAchievement = false;
    });
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _anim.removeListener(_onTick);
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    final hasContent =
        _bugs.isNotEmpty || _squashCount > 0 || _showAchievement;
    if (!hasContent) return const SizedBox.shrink();

    return Stack(
      children: [
        // ── Bugs ──
        for (final bug in _bugs) _buildBug(bug),

        // ── Squash Counter Badge ──
        if (_squashCount > 0 && !_showAchievement)
          Positioned(
            right: 20,
            bottom: 20,
            child: _SquashCounter(count: _squashCount),
          ),

        // ── Achievement Card ──
        if (_showAchievement && !_achievementDismissed)
          _AchievementCard(
            count: _squashCount,
            onDismiss: _dismissAchievement,
          ),
      ],
    );
  }

  Widget _buildBug(_Bug bug) {
    double scale = 1.0;
    double opacity = 1.0;

    if (!bug.isAlive) {
      // Squash animation: scale up + fade out.
      scale = 1.0 + bug.squashProgress * 0.6;
      opacity = (1.0 - bug.squashProgress).clamp(0.0, 1.0);
    }

    return Positioned(
      left: bug.x - 16,
      top: bug.y - 16,
      child: MouseRegion(
        cursor:
            bug.isAlive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: bug.isAlive ? () => _squashBug(bug) : null,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Transform(
                alignment: Alignment.center,
                // Flip horizontally when bug moves right so 🐛 faces
                // the movement direction on most platforms.
                transform: bug.movesRight
                    ? Matrix4.identity()
                    : Matrix4.diagonal3Values(-1, 1, 1),
                child: const Text('🐛', style: TextStyle(fontSize: 28)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Squash Counter Badge ───────────────────────────────────────────────────

class _SquashCounter extends StatelessWidget {
  const _SquashCounter({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.10)
                  : Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🐛', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                '× $count',
                style: AppTextStyles.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Achievement Card ───────────────────────────────────────────────────────

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.count,
    required this.onDismiss,
  });

  final int count;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned.fill(
      child: GestureDetector(
        onTap: onDismiss,
        child: Container(
          color: Colors.black.withValues(alpha: 0.35),
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.8 + value * 0.2,
                    child: child,
                  ),
                );
              },
              child: GestureDetector(
                onTap: () {}, // absorb tap so card isn't dismissed
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      width: 340,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.black.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: isDark ? 0.4 : 0.15),
                            blurRadius: 40,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🏆',
                              style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 16),
                          Text(
                            'Bug Hunter!',
                            style: AppTextStyles.h3.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'You squashed $count bugs!\n'
                            'You\'ve got serious debugging skills.\n'
                            'Imagine what we could build together.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 14,
                              height: 1.6,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const _LetsTalkButton(),
                          const SizedBox(height: 12),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: onDismiss,
                              child: Text(
                                'Keep squashing 🐛',
                                style: AppTextStyles.caption.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── "Let's Talk" CTA Button ────────────────────────────────────────────────

class _LetsTalkButton extends StatefulWidget {
  const _LetsTalkButton();

  @override
  State<_LetsTalkButton> createState() => _LetsTalkButtonState();
}

class _LetsTalkButtonState extends State<_LetsTalkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          final content =
              Get.find<ContentController>().content.value;
          if (content != null) {
            launchUrl(Uri.parse('mailto:${content.contact.email}'));
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accent
                : AppColors.accent.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            'Let\'s Talk 🚀',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
