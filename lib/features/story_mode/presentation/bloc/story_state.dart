import 'package:equatable/equatable.dart';
import '../../domain/entities/story_chapter.dart';
import '../../domain/entities/story_node.dart';

enum StoryStatus { initial, streaming, completed, failure }

class StoryState extends Equatable {
  final StoryStatus status;
  final List<StoryNode> log;
  final String? activePayloadId;
  final String? errorMessage;
  final List<StoryChapter> chapters;
  final int currentChapterIndex;
  final dynamic resume;

  const StoryState({
    this.status = StoryStatus.initial,
    this.log = const [],
    this.activePayloadId,
    this.errorMessage,
    this.chapters = const [],
    this.currentChapterIndex = 0,
    this.resume,
  });

  StoryState copyWith({
    StoryStatus? status,
    List<StoryNode>? log,
    String? activePayloadId,
    String? errorMessage,
    List<StoryChapter>? chapters,
    int? currentChapterIndex,
    dynamic resume,
  }) {
    return StoryState(
      status: status ?? this.status,
      log: log ?? this.log,
      activePayloadId: activePayloadId ?? this.activePayloadId,
      errorMessage: errorMessage ?? this.errorMessage,
      chapters: chapters ?? this.chapters,
      currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
      resume: resume ?? this.resume,
    );
  }

  @override
  List<Object?> get props => [
        status,
        log,
        activePayloadId,
        errorMessage,
        chapters,
        currentChapterIndex,
        resume
      ];
}
