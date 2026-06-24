import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../domain/entities/visitor_location.dart';
import '../../domain/entities/visitor_stats.dart';
import '../../domain/usecases/track_visit_usecase.dart';
import '../../domain/usecases/watch_visitor_locations_usecase.dart';
import '../../domain/usecases/watch_visitor_stats_usecase.dart';

enum VisitorStatus { initial, loading, loaded, error }

class VisitorController extends GetxController {
  /// Global flag: flipped to `true` once this controller is registered and
  /// its initial data fetch completes. Widgets observe this to avoid the
  /// first-load race where `Get.isRegistered` returns `false` while Firebase
  /// is still initializing asynchronously in [ContentBinding].
  static final isReady = false.obs;

  VisitorController({
    required TrackVisitUsecase trackVisit,
    required WatchVisitorStatsUsecase watchStats,
    required WatchVisitorLocationsUsecase watchLocations,
  })  : _trackVisit = trackVisit,
        _watchStats = watchStats,
        _watchLocations = watchLocations;

  final TrackVisitUsecase _trackVisit;
  final WatchVisitorStatsUsecase _watchStats;
  final WatchVisitorLocationsUsecase _watchLocations;

  final status = VisitorStatus.initial.obs;
  final stats = VisitorStats.empty.obs;
  final locations = <VisitorLocation>[].obs;

  bool get isLoaded => status.value == VisitorStatus.loaded;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    status.value = VisitorStatus.loading;
    try {
      // Fire-and-forget track — doesn't block stats display.
      _trackVisit().catchError((e) {
        if (kDebugMode) debugPrint('[VisitorController] trackVisit error: $e');
        return;
      });

      // Bind reactive streams from Firestore snapshots.
      // GetX's bindStream() automatically subscribes and disposes.
      stats.bindStream(
        _watchStats().handleError((e) {
          if (kDebugMode) debugPrint('[VisitorController] stats stream error: $e');
        }),
      );

      locations.bindStream(
        _watchLocations().handleError((e) {
          if (kDebugMode) debugPrint('[VisitorController] locations stream error: $e');
        }),
      );

      // Wait for the first emission from both streams so the UI has
      // initial data before we mark the controller as ready.
      await Future.wait([
        _watchStats().first,
        _watchLocations().first,
      ]);

      if (kDebugMode) {
        debugPrint('[VisitorController] streams bound, stats: ${stats.value}');
      }

      status.value = VisitorStatus.loaded;
      VisitorController.isReady.value = true;
    } catch (e) {
      if (kDebugMode) debugPrint('[VisitorController] init error: $e');
      status.value = VisitorStatus.error;
    }
  }

  @override
  void onClose() {
    isReady.value = false;
    super.onClose();
  }
}
