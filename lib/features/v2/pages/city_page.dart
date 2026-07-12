import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/analytics/analytics_service.dart';
import '../core/district.dart';
import '../core/journey_scroll_engine.dart';
import '../core/motion_tokens.dart';
import '../core/sky_gradient.dart';
import '../districts/coming_soon_district.dart';
import '../districts/gate/gate_district.dart';
import '../districts/valley_district.dart';
import '../widgets/city_map_rail.dart';

/// `/beta` — the City of Code. One continuous scroll journey where every
/// district is a chapter of the career.
///
/// Composition (Wonderous pattern): the sky paints behind everything; each
/// district's scene is pinned for its scroll span (translated within its
/// tall sliver by local progress); scroll-derived ValueNotifiers drive all
/// animation with zero setState in the scroll path.
class CityPage extends StatefulWidget {
  const CityPage({super.key});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  static const _districts = <District>[
    GateDistrict(),
    ValleyDistrict(),
    ComingSoonDistrict(),
  ];

  late final JourneyScrollEngine _engine =
      JourneyScrollEngine(districts: _districts);
  late final ScrollController _scroller = ScrollController()
    ..addListener(() => _engine.onScroll(_scroller.position.pixels));

  int _lastTracked = -1;

  @override
  void initState() {
    super.initState();
    _engine.activeIndex.addListener(_trackDistrict);
  }

  /// District dwell flows into the existing analytics dashboard as
  /// `v2_<district>` sections.
  void _trackDistrict() {
    final i = _engine.activeIndex.value;
    if (i == _lastTracked) return;
    if (_lastTracked >= 0) {
      AnalyticsService.sectionExit('v2_${_districts[_lastTracked].id}');
    }
    AnalyticsService.sectionEnter('v2_${_districts[i].id}');
    _lastTracked = i;
  }

  void _jumpToDistrict(int i) {
    final target = _engine.startOf(i);
    if (V2MotionSettings.instance.reduced.value) {
      _scroller.jumpTo(target);
    } else {
      _scroller.animateTo(
        target,
        duration: V2Motion.slow,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _engine.activeIndex.removeListener(_trackDistrict);
    _scroller.dispose();
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191036),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final vp = constraints.maxHeight;
          _engine.layout(vp);

          return Stack(
            children: [
              Positioned.fill(child: SkyGradient(engine: _engine)),
              CustomScrollView(
                controller: _scroller,
                slivers: [
                  for (var i = 0; i < _districts.length; i++)
                    SliverToBoxAdapter(
                      child: _PinnedDistrict(
                        district: _districts[i],
                        height: _engine.heightOf(i),
                        viewport: vp,
                        progress: _engine.progressOf(_districts[i].id),
                      ),
                    ),
                ],
              ),
              CityMapRail(engine: _engine, onSelect: _jumpToDistrict),
              const _TopBar(),
            ],
          );
        },
      ),
    );
  }
}

/// Keeps a viewport-height scene on screen for the whole scroll span of its
/// district by translating it down through its (taller) sliver.
class _PinnedDistrict extends StatelessWidget {
  const _PinnedDistrict({
    required this.district,
    required this.height,
    required this.viewport,
    required this.progress,
  });

  final District district;
  final double height;
  final double viewport;
  final ValueNotifier<double> progress;

  @override
  Widget build(BuildContext context) {
    final travel = (height - viewport).clamp(0.0, double.infinity);

    return SizedBox(
      height: height,
      child: ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          child: ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (context, t, child) => Transform.translate(
              offset: Offset(0, t * travel),
              child: child,
            ),
            child: SizedBox(
              height: viewport,
              width: double.infinity,
              child: RepaintBoundary(
                child: district.build(context, progress),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 14,
      left: 14,
      right: 14,
      child: Row(
        children: [
          _GlassButton(
            icon: Icons.arrow_back_rounded,
            label: 'classic site',
            onTap: () {
              AnalyticsService.click('v2_exit_to_classic');
              Get.offAllNamed('/');
            },
          ),
          const Spacer(),
          _GlassButton(
            icon: Icons.animation_rounded,
            label: 'motion',
            onTap: () {
              V2MotionSettings.instance.toggle();
              AnalyticsService.click('v2_toggle_motion');
            },
          ),
        ],
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.30),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
