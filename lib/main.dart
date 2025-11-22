import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'utils/app_theme.dart';
import 'utils/design_constants.dart';
import 'utils/shader_warmup.dart';
import 'controllers/theme_controller.dart';
import 'services/resume_service.dart';
import 'services/firebase_service.dart';
import 'screens/home_screen.dart';
import 'screens/not_found_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (non-blocking if config is missing)
  final firebaseService = Get.put(FirebaseService(), permanent: true);
  await firebaseService.init();

  // Initialize GetX controllers
  Get.put(ThemeController());

  // Initialize Resume Service for auto-loading and hot reload
  Get.put(ResumeService());

  // Run app with shader warmup for smooth animations
  runApp(
    ShaderWarmup.builder(
      child: const PortfolioApp(),
    ),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: 'Harsh Sureja Portfolio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(
              start: 0,
              end: DesignConstants.breakpointMobile,
              name: MOBILE,
            ),
            const Breakpoint(
              start: DesignConstants.breakpointMobile,
              end: DesignConstants.breakpointTablet,
              name: TABLET,
            ),
            const Breakpoint(
              start: DesignConstants.breakpointTablet,
              end: double.infinity,
              name: DESKTOP,
            ),
          ],
        ),
        initialRoute: '/',
        getPages: [
          GetPage(
            name: '/',
            page: () => const HomeScreen(),
            transition: Transition.fadeIn,
            transitionDuration: DesignConstants.animationNormal,
          ),
          GetPage(
            name: '/404',
            page: () => const NotFoundScreen(),
            transition: Transition.fade,
            transitionDuration: DesignConstants.animationFast,
          ),
        ],
        unknownRoute: GetPage(
          name: '/404',
          page: () => const NotFoundScreen(),
        ),
      ),
    );
  }
}
