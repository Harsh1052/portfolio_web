import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web/web.dart' as web;
import '../analytics/analytics_service.dart';
import '../routing/app_pages.dart';
import '../theme/app_colors.dart';

/// v1 → v2 bridge: a small dismissible pill inviting visitors into the
/// City of Code beta. Dismissal persists in localStorage.
class BetaBanner extends StatefulWidget {
  const BetaBanner({super.key});

  @override
  State<BetaBanner> createState() => _BetaBannerState();
}

class _BetaBannerState extends State<BetaBanner> {
  static const _dismissKey = 'beta_banner_dismissed';
  bool _visible = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _visible = !_isDismissed();
  }

  bool _isDismissed() {
    if (!kIsWeb) return false;
    try {
      return web.window.localStorage.getItem(_dismissKey) == 'true';
    } catch (_) {
      return false;
    }
  }

  void _dismiss() {
    setState(() => _visible = false);
    AnalyticsService.click('beta_banner_dismiss');
    if (!kIsWeb) return;
    try {
      web.window.localStorage.setItem(_dismissKey, 'true');
    } catch (_) {
      // Safari private mode — non-fatal.
    }
  }

  void _open() {
    AnalyticsService.click('beta_banner_open');
    Get.toNamed(AppRoutes.beta);
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return Positioned(
      left: 20,
      bottom: 20,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1220).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: _hovered ? 0.9 : 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: _hovered ? 0.3 : 0.15),
                blurRadius: 18,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _open,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_city_rounded,
                        size: 16, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Text(
                      'A new city is being built — visit the beta',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _dismiss,
                child: const Icon(Icons.close_rounded,
                    size: 15, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
