import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_web/core/theme/app_theme.dart';
import 'package:portfolio_web/core/theme/theme_controller.dart';
import 'package:portfolio_web/core/ambience/ambience_controller.dart';
import 'package:portfolio_web/core/analytics/analytics_service.dart';
import 'package:portfolio_web/core/routing/app_pages.dart';
import 'package:portfolio_web/features/content/presentation/bindings/content_binding.dart';
import 'package:portfolio_web/features/home/presentation/pages/not_found_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase is NOT initialized here — ContentBinding defers it until needed.
  Get.put(ThemeController());
  Get.put(AmbienceController());
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: 'Harsh Sureja',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.currentThemeMode,
      initialBinding: ContentBinding(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      // Journey tracking: every route change (incl. /work/:slug case
      // studies) becomes a page_view event.
      routingCallback: (routing) {
        final route = routing?.current;
        if (route != null) AnalyticsService.page(route);
      },
      unknownRoute: GetPage(
        name: '/404',
        page: () => const NotFoundPage(),
      ),
    );
  }
}
