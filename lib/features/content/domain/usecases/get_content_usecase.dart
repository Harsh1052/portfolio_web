import '../../data/models/portfolio_content.dart';
import '../repositories/content_repository.dart';

class GetContentUsecase {
  const GetContentUsecase(this._repository);

  final ContentRepository _repository;

  Future<PortfolioContent> call() => _repository.getContent();
}
