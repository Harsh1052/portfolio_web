import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'core/theme/terminal_theme.dart';
import 'core/router/app_router.dart';
import 'utils/design_constants.dart';
import 'controllers/theme_controller.dart';
import 'services/resume_service.dart';
import 'services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (non-blocking if config is missing)
  final firebaseService = Get.put(FirebaseService(), permanent: true);
  await firebaseService.init();

  // Initialize GetX controllers (Keeping purely for legacy service support if needed)
  Get.put(ThemeController());
  Get.put(ResumeService());

  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'The Architect\'s Log',
      debugShowCheckedModeBanner: false,
      theme: TerminalTheme.theme, // Enforce Terminal Theme
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
      routerConfig: _appRouter.config(),
    );
  }
}
