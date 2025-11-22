import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/resume_data.dart';

/// Service to load and watch resume data from JSON file
class ResumeService extends GetxController {
  static const String _resumePath = 'assets/data/resume.json';
  
  final Rx<ResumeData?> _resumeData = Rx<ResumeData?>(null);
  final RxBool _isLoading = true.obs;
  final RxString _error = ''.obs;
  final RxList<String> _validationErrors = <String>[].obs;
  
  StreamSubscription<FileSystemEvent>? _fileWatcher;

  ResumeData? get resumeData => _resumeData.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  List<String> get validationErrors => _validationErrors;
  bool get hasData => _resumeData.value != null;
  bool get hasError => _error.value.isNotEmpty;
  bool get isValid => _validationErrors.isEmpty;

  // Expose Rx observables for reactive listening (for backward compatibility)
  Rx<ResumeData?> get resumeDataRx => _resumeData;
  RxBool get isLoadingRx => _isLoading;
  RxString get errorRx => _error;

  @override
  void onInit() {
    super.onInit();
    loadResumeData();
    _setupFileWatcher();
  }

  @override
  void onClose() {
    _fileWatcher?.cancel();
    super.onClose();
  }

  /// Load resume data from JSON file
  Future<void> loadResumeData() async {
    try {
      _isLoading.value = true;
      _error.value = '';
      _validationErrors.clear();

      final String jsonString = await rootBundle.loadString(_resumePath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Validate JSON structure
      final validationResult = _validateJsonStructure(jsonData);
      if (!validationResult.isValid) {
        _validationErrors.addAll(validationResult.errors);
        if (kDebugMode) {
          print('Resume JSON validation errors:');
          for (var error in validationResult.errors) {
            print('  - $error');
          }
        }
      }

      // Parse resume data
      _resumeData.value = ResumeData.fromJson(jsonData);
      
      if (kDebugMode) {
        print('Resume data loaded successfully');
        print('- ${_resumeData.value!.experience.length} experiences');
        print('- ${_resumeData.value!.projects.length} projects');
        print('- ${_resumeData.value!.skills.length} skill categories');
        print('- ${_resumeData.value!.education.length} education entries');
      }
    } catch (e, stackTrace) {
      _error.value = 'Failed to load resume data: ${e.toString()}';
      if (kDebugMode) {
        print('Error loading resume data: $e');
        print(stackTrace);
      }
    } finally {
      _isLoading.value = false;
    }
  }

  /// Setup file watcher for hot reload in development
  void _setupFileWatcher() {
    if (!kDebugMode || kIsWeb) {
      // File watching only works in debug mode and not on web
      return;
    }

    try {
      // Get the project root directory
      final projectRoot = Directory.current;
      final resumeFile = File('${projectRoot.path}/$_resumePath');

      if (!resumeFile.existsSync()) {
        if (kDebugMode) {
          print('Resume file not found at: ${resumeFile.path}');
          print('File watching disabled.');
        }
        return;
      }

      _fileWatcher = resumeFile.watch(events: FileSystemEvent.modify).listen(
        (event) {
          if (kDebugMode) {
            print('Resume file changed, reloading...');
          }
          loadResumeData();
        },
        onError: (error) {
          if (kDebugMode) {
            print('File watcher error: $error');
          }
        },
      );

      if (kDebugMode) {
        print('File watcher enabled for: ${resumeFile.path}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Could not setup file watcher: $e');
        print('Hot reload for resume.json disabled.');
      }
    }
  }

  /// Validate JSON structure
  ValidationResult _validateJsonStructure(Map<String, dynamic> json) {
    final errors = <String>[];

    // Validate personalInfo
    if (!json.containsKey('personalInfo')) {
      errors.add('Missing required field: personalInfo');
    } else {
      final personal = json['personalInfo'] as Map<String, dynamic>?;
      if (personal != null) {
        if (!personal.containsKey('name')) errors.add('personalInfo.name is required');
        if (!personal.containsKey('title')) errors.add('personalInfo.title is required');
        if (!personal.containsKey('email')) errors.add('personalInfo.email is required');
        if (!personal.containsKey('bio')) errors.add('personalInfo.bio is required');
        if (!personal.containsKey('socialLinks')) {
          errors.add('personalInfo.socialLinks is required');
        }
      }
    }

    // Validate experience
    if (!json.containsKey('experience')) {
      errors.add('Missing required field: experience');
    } else if (json['experience'] is! List) {
      errors.add('experience must be an array');
    } else {
      final experiences = json['experience'] as List;
      for (var i = 0; i < experiences.length; i++) {
        final exp = experiences[i] as Map<String, dynamic>?;
        if (exp != null) {
          if (!exp.containsKey('position')) errors.add('experience[$i].position is required');
          if (!exp.containsKey('company')) errors.add('experience[$i].company is required');
          if (!exp.containsKey('startDate')) errors.add('experience[$i].startDate is required');
          if (!exp.containsKey('endDate')) errors.add('experience[$i].endDate is required');
        }
      }
    }

    // Validate projects
    if (!json.containsKey('projects')) {
      errors.add('Missing required field: projects');
    } else if (json['projects'] is! List) {
      errors.add('projects must be an array');
    }

    // Validate skills
    if (!json.containsKey('skills')) {
      errors.add('Missing required field: skills');
    } else if (json['skills'] is! List) {
      errors.add('skills must be an array');
    }

    // Validate education
    if (!json.containsKey('education')) {
      errors.add('Missing required field: education');
    } else if (json['education'] is! List) {
      errors.add('education must be an array');
    }

    return ValidationResult(errors.isEmpty, errors);
  }

  /// Reload resume data manually
  Future<void> reload() => loadResumeData();
}

/// Validation result class
class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult(this.isValid, this.errors);
}
