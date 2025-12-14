import 'package:equatable/equatable.dart';

abstract class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object> get props => [];
}

class StoryStarted extends StoryEvent {}

class StoryLogAdded extends StoryEvent {
  final dynamic
      node; // Temporarily dynamic to avoid circular imports during creation, will fix

  const StoryLogAdded(this.node);

  @override
  List<Object> get props => [node];
}

class ChapterVisible extends StoryEvent {
  final int chapterIndex;

  const ChapterVisible(this.chapterIndex);

  @override
  List<Object> get props => [chapterIndex];
}
