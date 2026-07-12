import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/analytics/presentation/controllers/analytics_dashboard_controller.dart';
import '../../features/analytics/presentation/pages/analytics_dashboard_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/v2/pages/city_page.dart' deferred as v2;
import '../../features/work/presentation/pages/case_study_page.dart';
import '../services/firebase_service.dart';
import '../theme/app_colors.dart';

abstract final class AppRoutes {
  static const String home = '/';
  static const String caseStudy = '/work/:slug';

  /// Hidden admin dashboard — not linked anywhere in the UI.
  static const String analytics = '/analytics';

  /// City of Code — the v2 scroll-journey portfolio (beta).
  static const String beta = '/beta';
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
    GetPage(
      name: AppRoutes.beta,
      // Deferred import: v1 visitors download zero v2 code.
      page: () => const _DeferredCityPage(),
    ),
  ];
}

class _DeferredCityPage extends StatelessWidget {
  const _DeferredCityPage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: v2.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFF191036),
            body: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.accent,
                ),
              ),
            ),
          );
        }
        return v2.CityPage();
      },
    );
  }
}
