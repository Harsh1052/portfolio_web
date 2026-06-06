import 'package:get/get.dart';
import '../../../content/data/models/portfolio_content.dart';
import '../../../content/domain/usecases/get_content_usecase.dart';

enum ContentStatus { initial, loading, loaded, error }

class ContentController extends GetxController {
  ContentController(this._getContent);

  final GetContentUsecase _getContent;

  final status = ContentStatus.initial.obs;
  final Rxn<PortfolioContent> content = Rxn<PortfolioContent>();

  @override
  void onInit() {
    super.onInit();
    loadContent();
  }

  Future<void> loadContent() async {
    status.value = ContentStatus.loading;
    try {
      content.value = await _getContent();
      status.value = ContentStatus.loaded;
    } catch (_) {
      status.value = ContentStatus.error;
    }
  }

  bool get isLoaded => status.value == ContentStatus.loaded;
  bool get isLoading => status.value == ContentStatus.loading;
}
