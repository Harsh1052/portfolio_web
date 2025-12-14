import 'package:auto_route/auto_route.dart';
import '../../features/story_mode/presentation/pages/portfolio_home_page.dart';
import '../../features/story_mode/presentation/pages/terminal_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: PortfolioHomeRoute.page, initial: true),
        AutoRoute(page: TerminalRoute.page),
      ];
}
