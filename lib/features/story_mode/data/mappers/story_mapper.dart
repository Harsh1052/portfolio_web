import '../../../../models/resume.dart';
import '../../domain/entities/resume_section.dart';
import '../../domain/entities/story_chapter.dart';

class StoryMapper {
  List<StoryChapter> mapResumeToChapters(Resume resume) {
    return [
      // Chapter 1: Landing (Bio)
      StoryChapter(
        id: 'CH1_IDENTITY',
        terminalCommand: '> INITIALIZING_IDENTITY...',
        narrativeText:
            "In a digital landscape of spaghetti code, one signal remains constant. 99.9% Uptime. Welcome to the archive.",
        relatedData: BioSection(resume.personalInfo),
      ),

      // Chapter 2: Education
      StoryChapter(
        id: 'CH2_KERNEL',
        terminalCommand: '> LOADING_KERNEL_MODULES...',
        narrativeText:
            "Forged at GTU. Compiled with CS logic. Beta tested at 'Across the Glob'. The foundation is stable.",
        relatedData: EducationSection(resume.education),
      ),

      // Chapter 3: Experience 1 (Elision & Tagline - indices 1 and 2 usually, need to check data)
      // Assuming Resume Experience is sorted: 0=Present, 1=Previous, 2=Oldest
      StoryChapter(
        id: 'CH3_SCALE',
        terminalCommand: '> EXECUTING_SCALE_PROTOCOL...',
        narrativeText:
            "Scaling to 50k users. Optimizing payments. The code became a fortress at Elision & Tagline.",
        relatedData: ExperienceSection(
          resume.experience.length >= 3
              ? [resume.experience[1], resume.experience[2]]
              : [],
        ),
      ),

      // Chapter 4: Experience 2 (FarmSetu - Present - index 0)
      StoryChapter(
        id: 'CH4_MAINFRAME',
        terminalCommand: '> ACCESSING_MAINFRAME...',
        narrativeText:
            "Architecting the Agri-Food ecosystem at FarmSetu. 10k+ Farmers. Clean Architecture is survival.",
        relatedData: ExperienceSection(
          resume.experience.isNotEmpty ? [resume.experience[0]] : [],
        ),
      ),

      // Chapter 5: Skills
      StoryChapter(
        id: 'CH5_INVENTORY',
        terminalCommand: '> LIST_INVENTORY --VERBOSE',
        narrativeText: "Arsenal loaded. Dart. Flutter. BLoC. Ready to deploy.",
        relatedData: SkillsSection(resume.skills),
      ),
    ];
  }
}
