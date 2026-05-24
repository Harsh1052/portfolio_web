import 'package:get/get.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/work/presentation/pages/case_study_page.dart';

abstract final class AppRoutes {
  static const String home = '/';
  static const String caseStudy = '/work/:slug';
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
  ];
}
