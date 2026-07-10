import 'package:get/get.dart';
import '../../features/analytics/presentation/controllers/analytics_dashboard_controller.dart';
import '../../features/analytics/presentation/pages/analytics_dashboard_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/work/presentation/pages/case_study_page.dart';
import '../services/firebase_service.dart';

abstract final class AppRoutes {
  static const String home = '/';
  static const String caseStudy = '/work/:slug';

  /// Hidden admin dashboard — not linked anywhere in the UI.
  static const String analytics = '/analytics';
}

abstract final class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppRoutes.caseStudy,
      page: () => const CaseStudyPage(),
    ),
    GetPage(
      name: AppRoutes.analytics,
      page: () => const AnalyticsDashboardPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AnalyticsDashboardController>(
          () => AnalyticsDashboardController(Get.find<FirebaseService>()),
        );
      }),
    ),
  ];
}
