import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../content/data/models/portfolio_content.dart';
import '../../../content/presentation/controllers/content_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/hero_section.dart';
import '../widgets/work_section.dart';
import '../widgets/about_section.dart';
import '../../../../features/experience/presentation/widgets/experience_section.dart';
import '../widgets/writing_section.dart';
import '../../../github/presentation/widgets/contribution_graph_section.dart';
import '../../../now/presentation/widgets/now_section.dart';
import '../../../skills/presentation/widgets/skills_timeline_section.dart';
import '../../../visitor/presentation/widgets/visitor_map_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';
import '../../../../core/analytics/tracked_section.dart';
import '../../../../core/widgets/beta_banner.dart';
import '../../../../core/widgets/welcome_toast.dart';
import '../widgets/bug_game_overlay.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContentController>();

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
          // 🐛 Bug Hunt mini-game — bugs crawl across the screen.
          const BugGameOverlay(),
          // 🏙️ v1 → v2 bridge — invitation to the City of Code beta.
          const BetaBanner(),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.content});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    // Every section reports enter/exit → dwell time; the scroll listener
    // records how deep each visitor gets (25/50/75/100%).
    return ScrollDepthTracker(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TrackedSection(
              name: 'hero',
              child: HeroSection(content: content),
            ),
            const TrackedSection(name: 'now', child: NowSection()),
            TrackedSection(
              name: 'work',
              child: WorkSection(projects: content.projects),
            ),
            TrackedSection(
              name: 'about',
              child: AboutSection(about: content.about),
            ),
            const TrackedSection(
              name: 'experience',
              child: ExperienceSection(),
            ),
            TrackedSection(
              name: 'writing',
              child: WritingSection(articles: content.articles),
            ),
            const TrackedSection(
              name: 'skills',
              child: SkillsTimelineSection(),
            ),
            const TrackedSection(
              name: 'github',
              child: ContributionGraphSection(),
            ),
            TrackedSection(
              name: 'contact',
              child: ContactSection(contact: content.contact),
            ),
            const TrackedSection(
              name: 'visitors',
              child: VisitorMapSection(),
            ),
            const TrackedSection(name: 'footer', child: FooterSection()),
          ],
        ),
      ),
    );
  }
}
