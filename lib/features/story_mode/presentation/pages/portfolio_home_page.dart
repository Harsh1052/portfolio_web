import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../core/theme/terminal_theme.dart';
import '../../domain/entities/resume_section.dart';
import '../../domain/entities/story_chapter.dart';
import '../bloc/story_bloc.dart';
import '../bloc/story_event.dart';
import '../bloc/story_state.dart';
import '../widgets/education_card.dart';
import '../widgets/experience_card.dart';
import '../widgets/holo_card.dart';
import '../widgets/skills_card.dart';
import '../widgets/terminal_typer.dart';

import '../../data/datasources/story_data_source.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../domain/repositories/story_repository.dart';

@RoutePage()
class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<StoryRepository>(
      create: (context) => StoryRepositoryImpl(StoryDataSource()),
      child: BlocProvider(
        create: (context) => StoryBloc(
          context.read<StoryRepository>(),
        )..add(StoryStarted()),
        child: Scaffold(
          backgroundColor: TerminalTheme.voidBlack,
          body: BlocBuilder<StoryBloc, StoryState>(
            builder: (context, state) {
              if (state.chapters.isEmpty) {
                return Center(
                  child: Text('INITIALIZING SYSTEM...',
                      style: TerminalTheme.terminalText),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 900;
                  if (isDesktop) {
                    return _buildDesktopLayout(context, state);
                  } else {
                    return _buildMobileLayout(context, state);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, StoryState state) {
    // Current Chapter Data
    final currentChapter = state.chapters[state.currentChapterIndex];

    return Row(
      children: [
        // Left Panel: Sticky Terminal (40%)
        Expanded(
          flex: 4,
          child: Container(
            color: TerminalTheme.voidBlack,
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '> SYSTEM_STATUS: ONLINE',
                  style: TerminalTheme.terminalDim,
                ),
                const SizedBox(height: 32),
                // Animated Command
                TerminalTyper(
                  key: ValueKey('${currentChapter.id}_cmd'),
                  text: currentChapter.terminalCommand,
                  speed: const Duration(milliseconds: 30),
                ),
                const SizedBox(height: 24),
                // Animated Narrative
                Container(
                  padding: const EdgeInsets.only(left: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: TerminalTheme.neonGreen, width: 2)),
                  ),
                  child: Text(
                    currentChapter.narrativeText,
                    style: TerminalTheme.terminalText
                        .copyWith(height: 1.5, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right Panel: Scrollable Content (60%)
        Expanded(
          flex: 6,
          child: ListView.builder(
            padding: const EdgeInsets.all(48),
            itemCount: state.chapters.length,
            itemBuilder: (context, index) {
              final chapter = state.chapters[index];
              return VisibilityDetector(
                key: Key(chapter.id),
                onVisibilityChanged: (info) {
                  if (info.visibleFraction > 0.5) {
                    context.read<StoryBloc>().add(ChapterVisible(index));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 64),
                  child: _buildChapterContent(chapter),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, StoryState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.chapters.length,
      itemBuilder: (context, index) {
        final chapter = state.chapters[index];
        return VisibilityDetector(
          key: Key(chapter.id),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0.6) {
              // Keep track but maybe less impactful on mobile
              // as everything scrolls together
              context.read<StoryBloc>().add(ChapterVisible(index));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sticky-ish Header for Mobile
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: TerminalTheme.dimText),
                  color: TerminalTheme.voidBlack,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chapter.terminalCommand,
                        style: TerminalTheme.terminalHeader
                            .copyWith(fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(chapter.narrativeText,
                        style: TerminalTheme.terminalDim),
                  ],
                ),
              ),
              _buildChapterContent(chapter),
              const SizedBox(height: 48),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChapterContent(StoryChapter chapter) {
    final data = chapter.relatedData;

    // Bio
    if (data is BioSection) {
      return HoloCard(
        borderColor: TerminalTheme.neonGreen,
        child: Column(
          children: [
            const Icon(Icons.person, size: 64, color: TerminalTheme.neonGreen),
            const SizedBox(height: 16),
            Text(data.info.name, style: TerminalTheme.terminalHeader),
            Text(data.info.title, style: TerminalTheme.terminalText),
            const SizedBox(height: 16),
            Text(data.info.bio,
                textAlign: TextAlign.center, style: TerminalTheme.terminalText),
          ],
        ),
      );
    }

    // Education
    if (data is EducationSection) {
      // Assuming EducationSection has a list, but chapter mapping logic currently implies
      // singular chapters or list handling.
      // Looking at StoryMapper: "CH2_KERNEL" -> EducationSection(resume.education)
      // which is List<Education>.
      return Column(
        children: data.education
            .map((edu) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: EducationCard(education: edu),
                ))
            .toList(),
      );
    }

    // Experience with Index (Scale vs Mainframe)
    // StoryMapper:
    // CH3_SCALE -> ExperienceSection(resume.experience, startIndex: 1)
    // CH4_MAINFRAME -> ExperienceSection([resume.experience[0]])
    if (data is ExperienceSection) {
      return Column(
        children: data.experiences
            .map((exp) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ExperienceCard(experience: exp),
                ))
            .toList(),
      );
    }

    // Skills
    if (data is SkillsSection) {
      return SkillsCard(skills: data.skills);
    }

    return Text('DATA CORRUPTED [${chapter.id}]',
        style: TerminalTheme.terminalWarning);
  }
}
