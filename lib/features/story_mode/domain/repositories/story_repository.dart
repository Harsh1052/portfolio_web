import '../entities/story_node.dart';

abstract class StoryRepository {
  /// Fetches the initial boot sequence story
  Stream<StoryNode> getBootSequence();

  /// Fetches the full parsed Resume object
  Future<dynamic>
      getResume(); // using dynamic temporarily to avoid importing Resume in domain if possible, or usually we move Resume entity to domain.
  // Actually, Resume IS a domain entity in this case, or closest to it. I'll import it.

  /// Fetches the main story sequence
  Future<List<StoryNode>> getFullStory();

  /// Gets a specific response for a user typed command (if we add interactivity later)
  Future<StoryNode?> getResponseForCommand(String command);
}
