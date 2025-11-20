import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/resume.dart';

class ResumeService {
  static Resume? _cachedResume;

  /// Loads and parses the resume from assets/data/resume.json
  /// Returns cached resume if already loaded
  static Future<Resume> loadResume() async {
    if (_cachedResume != null) {
      return _cachedResume!;
    }

    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString('assets/data/resume.json');

      // Parse the JSON string
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Create Resume object from JSON
      _cachedResume = Resume.fromJson(jsonData);

      return _cachedResume!;
    } catch (e) {
      throw Exception('Failed to load resume: $e');
    }
  }

  /// Clears the cached resume data
  /// Useful for refreshing data or during testing
  static void clearCache() {
    _cachedResume = null;
  }

  /// Validates if the resume data is properly loaded
  static bool isResumeLoaded() {
    return _cachedResume != null;
  }

  /// Gets the cached resume without reloading
  /// Returns null if not loaded yet
  static Resume? getCachedResume() {
    return _cachedResume;
  }

  /// Reloads the resume data from the asset file
  /// Forces a fresh load even if data is cached
  static Future<Resume> reloadResume() async {
    clearCache();
    return loadResume();
  }
}
