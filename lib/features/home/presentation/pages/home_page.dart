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
import '../widgets/tour_overlay.dart';
import '../controllers/tour_controller.dart';

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
          // Guided tour spotlight overlay.
          const TourOverlay(),
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

  // GlobalKeys for each tour-able section.
  final _heroKey = GlobalKey(debugLabel: 'tour_hero');
  final _nowKey = GlobalKey(debugLabel: 'tour_now');
  final _workKey = GlobalKey(debugLabel: 'tour_work');
  final _skillsKey = GlobalKey(debugLabel: 'tour_skills');
  final _githubKey = GlobalKey(debugLabel: 'tour_github');
  final _visitorKey = GlobalKey(debugLabel: 'tour_visitor');

  @override
  void initState() {
    super.initState();
    _registerTour();
  }

  void _registerTour() {
    final tourController = Get.put(TourController());
    tourController.registerSectionKeys(
      scrollController: _scrollController,
      steps: [
        TourStep(
          title: 'Welcome 👋',
          description:
              'This is the hero section — your first impression. '
              'It features animated particles, social links, and a resume download.',
          targetKey: _heroKey,
          icon: Icons.waving_hand_rounded,
        ),
        TourStep(
          title: 'What I\'m Up To',
          description:
              'The "Now" section shows what I\'m currently working on, '
              'learning, and building — always fresh.',
          targetKey: _nowKey,
          icon: Icons.bolt_rounded,
        ),
        TourStep(
          title: 'Selected Work',
          description:
              'Real-world projects I\'ve shipped. Click any card to see '
              'a detailed case study with architecture decisions.',
          targetKey: _workKey,
          icon: Icons.work_rounded,
        ),
        TourStep(
          title: 'Skills Timeline',
          description:
              'A year-by-year breakdown of technologies I\'ve learned '
              'and used professionally — hover each tag for details.',
          targetKey: _skillsKey,
          icon: Icons.timeline_rounded,
        ),
        TourStep(
          title: 'GitHub Activity',
          description:
              'Live contribution graph pulled from GitHub. Shows my '
              'coding consistency and open-source activity.',
          targetKey: _githubKey,
          icon: Icons.code_rounded,
        ),
        TourStep(
          title: 'Visitor Map',
          description:
              'A real-time map showing where portfolio visitors come from. '
              'Yes, you\'re on it right now! 🌍',
          targetKey: _visitorKey,
          icon: Icons.public_rounded,
        ),
      ],
    );
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
          KeyedSubtree(
            key: _heroKey,
            child: HeroSection(content: widget.content),
          ),
          KeyedSubtree(
            key: _nowKey,
            child: const NowSection(),
          ),
          KeyedSubtree(
            key: _workKey,
            child: WorkSection(projects: widget.content.projects),
          ),
          AboutSection(about: widget.content.about),
          WritingSection(articles: widget.content.articles),
          KeyedSubtree(
            key: _skillsKey,
            child: const SkillsTimelineSection(),
          ),
          KeyedSubtree(
            key: _githubKey,
            child: const ContributionGraphSection(),
          ),
          ContactSection(contact: widget.content.contact),
          KeyedSubtree(
            key: _visitorKey,
            child: const VisitorMapSection(),
          ),
          const FooterSection(),
        ],
      ),
    );
  }
}
