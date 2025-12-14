import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../models/resume.dart';
import '../../domain/entities/story_node.dart';
import '../mappers/story_mapper.dart';

class StoryDataSource {
  Future<Resume> loadResumeData() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/resume.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Resume.fromJson(jsonMap);
  }

  Stream<StoryNode> getStoryStream() async* {
    // 1. Boot Sequence
    yield* _generateBootSequence();

    // 2. Load Data
    yield const StoryNode(
      id: 'loading_data',
      text: 'ACCESSING ENCRYPTED ARCHIVES...',
      type: StoryNodeType.system,
      delay: Duration(milliseconds: 500),
    );

    Resume? resume;
    try {
      resume = await loadResumeData();
    } catch (e) {
      yield StoryNode(
        id: 'error_load',
        text: 'CRITICAL ERROR: DATA CORRUPTION DETECTED. $e',
        type: StoryNodeType.system,
        delay: const Duration(milliseconds: 100),
      );
      return;
    }

    // 3. Map Chapters
    final mapper = StoryMapper();
    final chapters = mapper.mapResumeToChapters(resume);

    // 4. Play Chapters
    for (final chapter in chapters) {
      // Command Line
      yield StoryNode(
        id: '${chapter.id}_cmd',
        text: chapter.terminalCommand,
        type: StoryNodeType.command,
        delay: const Duration(milliseconds: 600),
      );

      // Narrative
      yield StoryNode(
        id: '${chapter.id}_narrative',
        text: chapter.narrativeText,
        type: StoryNodeType.text,
        delay: const Duration(milliseconds: 800),
      );

      // Trigger Payload (Glitch effect to show data)
      yield StoryNode(
        id: '${chapter.id}_payload',
        text: 'Visualizing Data Block [${chapter.id}]...',
        type: StoryNodeType.glitch,
        payloadId: chapter.id,
        delay: const Duration(milliseconds: 2000),
      );
    }

    yield const StoryNode(
      id: 'end_stream',
      text: 'END OF STREAM. WAITING FOR INPUT...',
      type: StoryNodeType.system,
      delay: Duration(milliseconds: 0),
    );
  }

  Stream<StoryNode> _generateBootSequence() async* {
    final bootNodes = [
      const StoryNode(
        id: 'boot_0',
        text: 'INITIALIZING KERNEL...',
        type: StoryNodeType.system,
        delay: Duration(milliseconds: 100),
      ),
      const StoryNode(
        id: 'boot_1',
        text: 'LOADING MODULES: [GRAPHICS, SOUND, NETWORK, AI]',
        type: StoryNodeType.system,
        delay: Duration(milliseconds: 200),
      ),
      const StoryNode(
        id: 'boot_2',
        text: 'SUCCESS: SYSTEM ONLINE',
        type: StoryNodeType.system,
        delay: Duration(milliseconds: 100),
      ),
    ];

    for (final node in bootNodes) {
      await Future.delayed(node.delay);
      yield node;
    }
  }
}
