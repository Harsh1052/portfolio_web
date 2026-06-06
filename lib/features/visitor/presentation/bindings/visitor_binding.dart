import 'package:get/get.dart';
import '../../../../core/services/firebase_service.dart';
import '../../data/repositories/visitor_repository_impl.dart';
import '../../data/sources/visitor_remote_source.dart';
import '../../domain/usecases/get_visitor_stats_usecase.dart';
import '../../domain/usecases/track_visit_usecase.dart';
import '../controllers/visitor_controller.dart';

/// Wires the entire visitor-tracking feature synchronously.
/// Firebase init and Firestore instance creation are deferred to the data
/// source's [_ensureReady()] method — nothing Firebase-related runs here.
class VisitorBinding {
  void dependencies() {
    Get.lazyPut<VisitorRemoteSource>(
      // Only FirebaseService is passed — FirebaseFirestore.instance is obtained
      // lazily inside VisitorRemoteSource after Firebase.initializeApp() runs.
      () => VisitorRemoteSource(Get.find<FirebaseService>()),
    );

    Get.lazyPut<VisitorRepositoryImpl>(
      () => VisitorRepositoryImpl(
        remoteSource: Get.find<VisitorRemoteSource>(),
      ),
    );

    Get.lazyPut<TrackVisitUsecase>(
      () => TrackVisitUsecase(Get.find<VisitorRepositoryImpl>()),
    );

    Get.lazyPut<GetVisitorStatsUsecase>(
      () => GetVisitorStatsUsecase(Get.find<VisitorRepositoryImpl>()),
    );

    Get.put<VisitorController>(
      VisitorController(
        trackVisit: Get.find<TrackVisitUsecase>(),
        getStats: Get.find<GetVisitorStatsUsecase>(),
      ),
      permanent: true,
    );
  }
}
