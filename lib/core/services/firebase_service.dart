import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Lazy Firebase initializer — NOT called in main().
/// Call [ensureInitialized] before any Firestore access.
class FirebaseService extends GetxService {
  static const _configPath = 'assets/config/firebase_options.json';

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    try {
      final options = await _loadOptions();
      if (options == null) {
        if (kDebugMode) debugPrint('Firebase config missing or incomplete.');
        return;
      }
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: options);
      }
      _initialized = true;
    } catch (e) {
      if (kDebugMode) debugPrint('Firebase init failed: $e');
    }
  }

  Future<FirebaseOptions?> _loadOptions() async {
    try {
      final raw = await rootBundle.loadString(_configPath);
      final data = jsonDecode(raw) as Map<String, dynamic>;
      for (final key in ['apiKey', 'authDomain', 'projectId', 'storageBucket', 'messagingSenderId', 'appId']) {
        final v = (data[key] as String? ?? '').trim();
        if (v.isEmpty || v.startsWith('YOUR_')) return null;
      }
      return FirebaseOptions(
        apiKey: data['apiKey'] as String,
        authDomain: data['authDomain'] as String,
        projectId: data['projectId'] as String,
        storageBucket: data['storageBucket'] as String,
        messagingSenderId: data['messagingSenderId'] as String,
        appId: data['appId'] as String,
      );
    } catch (_) {
      return null;
    }
  }
}
