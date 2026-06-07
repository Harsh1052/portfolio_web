import 'package:get/get.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../features/github/data/repositories/github_repository_impl.dart';
import '../../../../features/github/data/sources/github_remote_source.dart';
import '../../../../features/github/domain/usecases/get_github_stats_usecase.dart';
import '../../../../features/github/presentation/controllers/github_stats_controller.dart';
import '../../../../features/visitor/presentation/bindings/visitor_binding.dart';
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

    // GitHub stats — pure HTTP, no Firebase dependency needed.
    Get.lazyPut<GitHubRemoteSource>(() => const GitHubRemoteSource());
    Get.lazyPut<GitHubRepositoryImpl>(
      () => GitHubRepositoryImpl(remoteSource: Get.find<GitHubRemoteSource>()),
    );
    Get.lazyPut<GetGitHubStatsUsecase>(
      () => GetGitHubStatsUsecase(Get.find<GitHubRepositoryImpl>()),
    );
    Get.put<GitHubStatsController>(
      GitHubStatsController(usecase: Get.find<GetGitHubStatsUsecase>()),
      permanent: true,
    );

    // Visitor tracking — wired after Firebase is available.
    // ensureInitialized is called lazily inside ContentRemoteSource;
    // we call it explicitly here so VisitorBinding can check isInitialized.
    Get.find<FirebaseService>().ensureInitialized().then((_) {
      VisitorBinding().dependencies();
    });
  }
}

