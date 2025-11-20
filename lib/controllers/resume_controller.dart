import 'package:get/get.dart';
import '../models/resume.dart';
import '../services/resume_service.dart';

class ResumeController extends GetxController {
  // Observable variables
  final Rx<Resume?> resume = Rx<Resume?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadResume();
  }

  /// Load resume data from JSON file
  Future<void> loadResume() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final loadedResume = await ResumeService.loadResume();
      resume.value = loadedResume;

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load resume data: ${e.toString()}';
      // Log error for debugging
      // ignore: avoid_print
      print('Error loading resume: $e');
    }
  }

  /// Reload resume data
  Future<void> reloadResume() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final loadedResume = await ResumeService.reloadResume();
      resume.value = loadedResume;

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to reload resume data: ${e.toString()}';
      // Log error for debugging
      // ignore: avoid_print
      print('Error reloading resume: $e');
    }
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}
