import '../../domain/entities/story_node.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/story_data_source.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryDataSource _dataSource;

  StoryRepositoryImpl(this._dataSource);

  @override
  Stream<StoryNode> getBootSequence() {
    return _dataSource.getStoryStream();
  }

  @override
  Future<List<StoryNode>> getFullStory() async {
    // TODO: Implement full story fetching
    return [];
  }

  @override
  Future<dynamic> getResume() {
    return _dataSource.loadResumeData();
  }

  @override
  Future<StoryNode?> getResponseForCommand(String command) async {
    // TODO: Implement interactive commands
    return null;
  }
}
