import 'package:get/get.dart';
import '../../../../core/services/firebase_service.dart';
import '../../data/repositories/content_repository_impl.dart';
import '../../data/sources/content_mock_source.dart';
import '../../data/sources/content_remote_source.dart';
import '../../domain/usecases/get_content_usecase.dart';
import '../controllers/content_controller.dart';

/// Registered as [initialBinding] in GetMaterialApp — runs once at app start.
class ContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FirebaseService>(FirebaseService(), permanent: true);

    Get.lazyPut<ContentMockSource>(() => ContentMockSource());

    Get.lazyPut<ContentRemoteSource>(
      () => ContentRemoteSource(Get.find<FirebaseService>()),
    );

    Get.lazyPut<ContentRepositoryImpl>(
      () => ContentRepositoryImpl(
        remoteSource: Get.find<ContentRemoteSource>(),
        mockSource: Get.find<ContentMockSource>(),
      ),
    );

    Get.lazyPut<GetContentUsecase>(
      () => GetContentUsecase(Get.find<ContentRepositoryImpl>()),
    );

    Get.put<ContentController>(
      ContentController(Get.find<GetContentUsecase>()),
      permanent: true,
    );
  }
}
