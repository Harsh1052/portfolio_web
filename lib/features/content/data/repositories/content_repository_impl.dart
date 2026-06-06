import '../../domain/repositories/content_repository.dart';
import '../models/portfolio_content.dart';
import '../sources/content_mock_source.dart';
import '../sources/content_remote_source.dart';

class ContentRepositoryImpl implements ContentRepository {
  const ContentRepositoryImpl({
    required this.remoteSource,
    required this.mockSource,
    // TODO: set to false once `content/portfolio` Firestore document is populated
    this.useMock = true,
  });

  final ContentRemoteSource remoteSource;
  final ContentMockSource mockSource;
  final bool useMock;

  @override
  Future<PortfolioContent> getContent() async {
    if (useMock) return mockSource.getContent();
    try {
      return await remoteSource.getContent();
    } catch (_) {
      // Firestore unavailable — fall back to mock so the site still renders
      return mockSource.getContent();
    }
  }
}
