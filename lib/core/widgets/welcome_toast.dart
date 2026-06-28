import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../features/visitor/presentation/controllers/visitor_controller.dart';

/// A glassmorphic geo-personalized welcome toast that slides in from the
/// bottom-right when the visitor's location is resolved.
///
/// Shows a localized greeting and the visitor's city.
/// Auto-dismisses after 8 seconds. Skipped if VisitorController is not ready.
class WelcomeToast extends StatefulWidget {
  const WelcomeToast({super.key});

  @override
  State<WelcomeToast> createState() => _WelcomeToastState();
}

class _WelcomeToastState extends State<WelcomeToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  bool _visible = false;
  Worker? _readyWorker;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    // Listen reactively for when VisitorController becomes ready
    _readyWorker = ever(VisitorController.isReady, (bool isReady) {
      if (isReady && mounted) {
        // Small delay so the hero section renders first, then show toast
        Future<void>.delayed(const Duration(milliseconds: 1400), () {
          if (mounted && !_visible) _show();
        });
        _readyWorker?.dispose();
        _readyWorker = null;
      }
    });

    // In case VisitorController is already ready when this widget mounts
    if (VisitorController.isReady.value && mounted) {
      Future<void>.delayed(const Duration(milliseconds: 1400), () {
        if (mounted && !_visible) _show();
      });
    }
  }

  void _show() {
    if (_visible || !mounted) return;
    setState(() => _visible = true);
    _animController.forward();
    _dismissTimer = Timer(const Duration(seconds: 8), _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _animController.reverse().then((_) {
      if (mounted) setState(() => _visible = false);
    });
    _dismissTimer?.cancel();
  }

  @override
  void dispose() {
    _animController.dispose();
    _dismissTimer?.cancel();
    _readyWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    // Read city/country only when VisitorController is registered and ready
    final city = _resolveCity();
    final country = _resolveCountry();
    final greeting = _greetingFor(country);
    final flagEmoji = _flagFor(country);

    return Positioned(
      bottom: 28,
      right: 24,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _ToastCard(
            greeting: greeting,
            flag: flagEmoji,
            city: city,
            onDismiss: _dismiss,
          ),
        ),
      ),
    );
  }

  String _resolveCity() {
    try {
      if (!Get.isRegistered<VisitorController>()) return '';
      final locations = Get.find<VisitorController>().locations;
      if (locations.isEmpty) return '';
      return locations.first.city;
    } catch (_) {
      return '';
    }
  }

  String _resolveCountry() {
    try {
      if (!Get.isRegistered<VisitorController>()) return '';
      final locations = Get.find<VisitorController>().locations;
      if (locations.isEmpty) return '';
      return locations.first.country;
    } catch (_) {
      return '';
    }
  }

  static const Map<String, String> _greetings = {
    'india': 'Namaste!',
    'germany': 'Hallo!',
    'austria': 'Hallo!',
    'france': 'Bonjour!',
    'belgium': 'Bonjour!',
    'switzerland': 'Bonjour!',
    'spain': '¡Hola!',
    'mexico': '¡Hola!',
    'argentina': '¡Hola!',
    'colombia': '¡Hola!',
    'japan': 'こんにちは!',
    'italy': 'Ciao!',
    'brazil': 'Olá!',
    'portugal': 'Olá!',
    'netherlands': 'Hoi!',
    'russia': 'Привет!',
  };

  static const Map<String, String> _flags = {
    'india': '🇮🇳',
    'united states': '🇺🇸',
    'united kingdom': '🇬🇧',
    'germany': '🇩🇪',
    'france': '🇫🇷',
    'canada': '🇨🇦',
    'australia': '🇦🇺',
    'japan': '🇯🇵',
    'spain': '🇪🇸',
    'mexico': '🇲🇽',
    'italy': '🇮🇹',
    'brazil': '🇧🇷',
    'netherlands': '🇳🇱',
    'singapore': '🇸🇬',
    'russia': '🇷🇺',
  };

  static String _greetingFor(String country) {
    final lower = country.toLowerCase();
    for (final entry in _greetings.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }
    return 'Hello there!';
  }

  static String _flagFor(String country) {
    final lower = country.toLowerCase();
    for (final entry in _flags.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }
    return '👋';
  }
}

// ─── Toast Card UI ────────────────────────────────────────────────────────────

class _ToastCard extends StatelessWidget {
  const _ToastCard({
    required this.greeting,
    required this.flag,
    required this.city,
    required this.onDismiss,
  });

  final String greeting;
  final String flag;
  final String city;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 14, 16),
        decoration: BoxDecoration(
          // Glassmorphic: semi-transparent surface with blur border
          color: isDark
              ? cs.surface.withValues(alpha: 0.88)
              : cs.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.08),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flag + accent bar on the left
            Column(
              children: [
                Container(
                  width: 3,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        greeting,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.accent,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    city.isNotEmpty
                        ? 'Visiting from $city?\nWelcome to my corner of the internet! 🚀'
                        : 'Welcome to my portfolio!\nGlad you stopped by. 🚀',
                    style: AppTextStyles.caption.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.72),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            // Close button
            GestureDetector(
              onTap: onDismiss,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
