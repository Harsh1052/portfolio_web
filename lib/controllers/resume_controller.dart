import 'package:get/get.dart';
import '../models/resume.dart';
import '../services/resume_service.dart';

/// DEPRECATED: Use ResumeService directly instead.
/// This controller is kept for backward compatibility.
/// It wraps the new ResumeService functionality.
class ResumeController extends GetxController {
  late final ResumeService _resumeService;

  // Observable variables (for backward compatibility)
  final Rx<Resume?> resume = Rx<Resume?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get the existing ResumeService instance
    _resumeService = Get.find<ResumeService>();

    // Listen to changes from ResumeService and update local observables
    ever(_resumeService.resumeDataRx, (_) => _updateResume());
    ever(_resumeService.isLoadingRx, (loading) => isLoading.value = loading);
    ever(_resumeService.errorRx, (error) => errorMessage.value = error);

    // Initialize values
    _updateResume();
    isLoading.value = _resumeService.isLoading;
    errorMessage.value = _resumeService.error;
  }

  void _updateResume() {
    final resumeData = _resumeService.resumeData;
    if (resumeData == null) {
      resume.value = null;
      return;
    }

    resume.value = Resume(
      personalInfo: resumeData.personalInfo,
      experience: resumeData.experience,
      projects: resumeData.projects,
      skills: resumeData.skills,
      education: resumeData.education,
    );
  }

  /// Load resume data from JSON file
  Future<void> loadResume() async {
    await _resumeService.loadResumeData();
  }

  /// Reload resume data
  Future<void> reloadResume() async {
    await _resumeService.reload();
  }

  @override
  void onClose() {
    // ResumeService is managed globally, don't dispose it here
    super.onClose();
  }
}
