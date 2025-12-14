import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/story_repository.dart';
import '../../domain/entities/story_node.dart';
import '../../data/mappers/story_mapper.dart';
import '../../../../models/resume.dart';
import 'story_event.dart';
import 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepository _repository;
  StreamSubscription? _storySubscription;

  StoryBloc(this._repository) : super(const StoryState()) {
    on<StoryStarted>(_onStoryStarted);
    on<StoryLogAdded>(_onStoryLogAdded);
    on<ChapterVisible>(_onChapterVisible);
  }

  void _onStoryStarted(StoryStarted event, Emitter<StoryState> emit) async {
    emit(state.copyWith(status: StoryStatus.streaming));

    // Fetch Resume Data & Map Chapters
    try {
      final resume = await _repository.getResume() as Resume;
      final mapper = StoryMapper();
      final chapters = mapper.mapResumeToChapters(resume);

      emit(state.copyWith(
        resume: resume,
        chapters: chapters,
      ));
    } catch (e) {
      // Handle error implicitly through the stream for now or separate error state
    }

    _storySubscription?.cancel();
    _storySubscription = _repository.getBootSequence().listen(
          (node) => add(StoryLogAdded(node)),
          onDone: () => {}, // Can add StoryCompleted event later
          onError: (error) => {}, // Handle error
        );
  }

  void _onStoryLogAdded(StoryLogAdded event, Emitter<StoryState> emit) {
    final node = event.node as StoryNode;
    final updatedLog = List<StoryNode>.from(state.log)..add(node);

    // Update active payload if the node has one
    String? newPayloadId = state.activePayloadId;
    if (node.payloadId != null) {
      newPayloadId = node.payloadId;
    }

    emit(state.copyWith(
      log: updatedLog,
      activePayloadId: newPayloadId,
    ));
  }

  void _onChapterVisible(ChapterVisible event, Emitter<StoryState> emit) {
    if (event.chapterIndex >= 0 && event.chapterIndex < state.chapters.length) {
      emit(state.copyWith(currentChapterIndex: event.chapterIndex));
    }
  }

  @override
  Future<void> close() {
    _storySubscription?.cancel();
    return super.close();
  }
}
