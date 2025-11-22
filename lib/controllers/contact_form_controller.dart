import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/firebase_service.dart';

/// Controller for handling contact form submissions
class ContactFormController extends GetxController {
  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  // State management
  final isLoading = false.obs;
  final successMessage = ''.obs;
  final errorMessage = ''.obs;

  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }

  /// Submit the contact form
  Future<void> submitForm() async {
    // Clear previous messages
    successMessage.value = '';
    errorMessage.value = '';
    isLoading.value = true;

    try {
      // Prepare form data
      final formData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'subject': subjectController.text.trim(),
        'message': messageController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _firebaseService.submitContactMessage(formData);

      // Show success message
      successMessage.value = 'Thank you! Your message has been sent successfully. I\'ll get back to you soon.';

      // Clear form after successful submission
      await Future.delayed(const Duration(seconds: 2));
      _clearForm();

    } on FirebaseNotConfiguredException catch (e) {
      errorMessage.value = '${e.message}. Please add your Firebase config.';
    } catch (e, stackTrace) {
      errorMessage.value = 'Oops! Something went wrong. Please try again or email me directly.';
      debugPrint('Error submitting form: $e');
      debugPrint(stackTrace.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear all form fields
  void _clearForm() {
    nameController.clear();
    emailController.clear();
    subjectController.clear();
    messageController.clear();
  }

  /// Validate email format
  bool isValidEmail(String email) {
    return GetUtils.isEmail(email);
  }

  /// Reset all messages
  void clearMessages() {
    successMessage.value = '';
    errorMessage.value = '';
  }
}
