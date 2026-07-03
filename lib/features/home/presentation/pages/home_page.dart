import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../content/data/models/portfolio_content.dart';
import '../../../content/presentation/controllers/content_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/hero_section.dart';
import '../widgets/work_section.dart';
import '../widgets/about_section.dart';
import '../widgets/writing_section.dart';
import '../../../github/presentation/widgets/contribution_graph_section.dart';
import '../../../now/presentation/widgets/now_section.dart';
import '../../../skills/presentation/widgets/skills_timeline_section.dart';
import '../../../visitor/presentation/widgets/visitor_map_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';
import '../../../../core/widgets/welcome_toast.dart';
import '../controllers/sass_controller.dart';
import '../widgets/sass_bubble.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContentController>();
    // Register early so SassBubble can find it while content is loading.
    Get.put(SassController());

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading) {
              return const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.accent,
                  ),
                ),
              );
            }

            final content = controller.content.value;
            if (content == null) return const SizedBox.shrink();

            return _HomeContent(content: content);
          }),
          // Geo-personalized welcome toast — slides in from bottom-right
          // once the visitor's location resolves from Firestore.
          const WelcomeToast(),
          // The roasting sass bot — drops funny messages based on time on site.
          const SassBubble(),
        ],
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent({required this.content});

  final PortfolioContent content;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Hook SassController to the scroll position so it can fire
    // scroll-based roasts (contact, footer).
    if (Get.isRegistered<SassController>()) {
      Get.find<SassController>()
          .registerScrollController(_scrollController);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeroSection(content: widget.content),
          const NowSection(),
          WorkSection(projects: widget.content.projects),
          AboutSection(about: widget.content.about),
          WritingSection(articles: widget.content.articles),
          const SkillsTimelineSection(),
          const ContributionGraphSection(),
          ContactSection(contact: widget.content.contact),
          const VisitorMapSection(),
          const FooterSection(),
        ],
      ),
    );
  }
}
