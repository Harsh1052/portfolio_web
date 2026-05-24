import '../../data/models/portfolio_content.dart';

abstract class ContentRepository {
  Future<PortfolioContent> getContent();
}
