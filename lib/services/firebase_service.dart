import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Handles Firebase initialization and Firestore interactions.
class FirebaseService extends GetxService {
  final RxBool isInitialized = false.obs;
  final RxBool isInitializing = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> init() async {
    if (isInitialized.value || isInitializing.value) return;

    isInitializing.value = true;
    try {
      final options = await _loadOptions();
      if (options == null) {
        errorMessage.value =
            'Firebase config missing. Update assets/config/firebase_options.json';
        return;
      }

      await Firebase.initializeApp(options: options);
      isInitialized.value = true;
      errorMessage.value = '';
      if (kDebugMode) {
        print('Firebase initialized for project: ${options.projectId}');
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'Firebase initialization failed: $e';
      if (kDebugMode) {
        print(errorMessage.value);
        print(stackTrace);
      }
    } finally {
      isInitializing.value = false;
    }
  }

  /// Persist a contact form submission to Firestore.
  Future<void> submitContactMessage(Map<String, dynamic> formData) async {
    if (!isInitialized.value) {
      await init();
    }

    if (!isInitialized.value) {
      throw FirebaseNotConfiguredException(errorMessage.value);
    }

    final payload = {
      ...formData,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
    };

    await FirebaseFirestore.instance.collection('contactMessages').add(payload);
  }

  Future<FirebaseOptions?> _loadOptions() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/config/firebase_options.json');
      final Map<String, dynamic> data =
          json.decode(jsonString) as Map<String, dynamic>;

      if (_hasMissingValues(data)) {
        return null;
      }

      return FirebaseOptions(
        apiKey: data['apiKey'] as String,
        authDomain: data['authDomain'] as String,
        projectId: data['projectId'] as String,
        storageBucket: data['storageBucket'] as String,
        messagingSenderId: data['messagingSenderId'] as String,
        appId: data['appId'] as String,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Could not load Firebase options: $e');
        print(stackTrace);
      }
      return null;
    }
  }

  bool _hasMissingValues(Map<String, dynamic> data) {
    const requiredKeys = [
      'apiKey',
      'authDomain',
      'projectId',
      'storageBucket',
      'messagingSenderId',
      'appId',
    ];

    for (final key in requiredKeys) {
      final value = (data[key] as String? ?? '').trim();
      if (value.isEmpty || value.startsWith('YOUR_')) {
        return true;
      }
    }
    return false;
  }
}

class FirebaseNotConfiguredException implements Exception {
  final String message;
  FirebaseNotConfiguredException(this.message);

  @override
  String toString() => message;
}
