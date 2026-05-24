import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_pages.dart';
import 'features/content/presentation/bindings/content_binding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase is NOT initialized here — ContentBinding defers it until needed.
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Harsh Sureja',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
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
      backgroundColor: const Color(0xFFFAFAFA),
      body: Center(
        child: Text(
          '404',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
