import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../content/data/models/portfolio_content.dart';
import '../../../content/presentation/controllers/content_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/hero_section.dart';
import '../widgets/work_section.dart';
import '../widgets/about_section.dart';
import '../widgets/writing_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContentController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Obx(() {
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
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.content});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeroSection(content: content),
          WorkSection(projects: content.projects),
          AboutSection(about: content.about),
          WritingSection(articles: content.articles),
          ContactSection(contact: content.contact),
          const FooterSection(),
        ],
      ),
    );
  }
}
