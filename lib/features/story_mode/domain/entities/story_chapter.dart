import 'resume_section.dart';

class StoryChapter {
  final String id;
  final String terminalCommand;
  final String narrativeText;
  final ResumeSection relatedData;

  const StoryChapter({
    required this.id,
    required this.terminalCommand,
    required this.narrativeText,
    required this.relatedData,
  });
}
