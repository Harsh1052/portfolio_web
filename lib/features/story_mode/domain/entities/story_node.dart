import 'package:equatable/equatable.dart';

enum StoryNodeType {
  text, // Simple narrative text
  command, // User input command style
  system, // System notification/success/error
  glitch, // Special effect text
}

/// Represents a single unit of the story (a line in the terminal log)
class StoryNode extends Equatable {
  final String id;
  final String text;
  final StoryNodeType type;

  /// Determines if this node triggers a UI update on the right panel
  /// null = no update
  final String? payloadId;

  /// Adding a small delay before showing the next node creates a "typing" feel
  final Duration delay;

  const StoryNode({
    required this.id,
    required this.text,
    this.type = StoryNodeType.text,
    this.payloadId,
    this.delay = const Duration(milliseconds: 50),
  });

  @override
  List<Object?> get props => [id, text, type, payloadId, delay];
}
