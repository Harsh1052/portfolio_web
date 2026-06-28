import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/routing/app_pages.dart';
import 'features/content/presentation/bindings/content_binding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase is NOT initialized here — ContentBinding defers it until needed.
  Get.put(ThemeController());
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
      unknownRoute: GetPage(
        name: '/404',
        page: () => const _NotFoundPage(),
      ),
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '404',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
