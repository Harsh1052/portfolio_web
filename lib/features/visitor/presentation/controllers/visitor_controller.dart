import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../domain/entities/visitor_stats.dart';
import '../../domain/usecases/get_visitor_stats_usecase.dart';
import '../../domain/usecases/track_visit_usecase.dart';

enum VisitorStatus { initial, loading, loaded, error }

class VisitorController extends GetxController {
  /// Global flag: flipped to `true` once this controller is registered and
  /// its initial data fetch completes. Widgets observe this to avoid the
  /// first-load race where `Get.isRegistered` returns `false` while Firebase
  /// is still initializing asynchronously in [ContentBinding].
  static final isReady = false.obs;

  VisitorController({
    required TrackVisitUsecase trackVisit,
    required GetVisitorStatsUsecase getStats,
  })  : _trackVisit = trackVisit,
        _getStats = getStats;

  final TrackVisitUsecase _trackVisit;
  final GetVisitorStatsUsecase _getStats;

  final status = VisitorStatus.initial.obs;
  final stats = VisitorStats.empty.obs;

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
      stats.value = await _getStats();
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
