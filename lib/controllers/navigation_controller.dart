import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Navigation Controller for managing smooth scrolling and section tracking
class NavigationController extends GetxController {
  // Scroll controller for the main page
  final ScrollController scrollController = ScrollController();

  // Current active section
  final RxString activeSection = 'home'.obs;

  // Scroll progress for indicators (0.0 - 1.0)
  final RxDouble scrollProgress = 0.0.obs;

  // Section keys for scroll tracking
  final Map<String, GlobalKey> sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'experience': GlobalKey(),
    'projects': GlobalKey(),
    'contact': GlobalKey(),
  };

  // Whether the floating nav bar should be visible
  final RxBool showFloatingNav = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Handle scroll events
  void _onScroll() {
    // Show floating nav after scrolling 100 pixels
    showFloatingNav.value = scrollController.offset > 100;

    // Update active section based on scroll position
    _updateActiveSection();

    // Update scroll progress for indicators
    _updateScrollProgress();
  }

  /// Update active section based on current scroll position
  void _updateActiveSection() {
    final currentOffset = scrollController.offset;
    final viewportHeight = scrollController.position.viewportDimension;

    // Find which section is currently in view
    for (final entry in sectionKeys.entries) {
      final key = entry.value;
      final context = key.currentContext;

      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          final sectionTop = position.dy + currentOffset;
          final sectionBottom = sectionTop + renderBox.size.height;

          // Check if section is in the viewport (with some offset for better UX)
          if (currentOffset >= sectionTop - (viewportHeight * 0.3) &&
              currentOffset < sectionBottom - (viewportHeight * 0.3)) {
            if (activeSection.value != entry.key) {
              activeSection.value = entry.key;
            }
            break;
          }
        }
      }
    }
  }

  void _updateScrollProgress() {
    if (!scrollController.hasClients) {
      scrollProgress.value = 0.0;
      return;
    }

    final position = scrollController.position;
    final maxExtent = position.maxScrollExtent;
    if (maxExtent <= 0) {
      scrollProgress.value = 0.0;
      return;
    }

    final progress = (position.pixels / maxExtent).clamp(0.0, 1.0);
    scrollProgress.value = progress;
  }

  /// Scroll to a specific section with smooth animation
  Future<void> scrollToSection(String section) async {
    final key = sectionKeys[section];
    if (key?.currentContext != null) {
      final context = key!.currentContext!;
      final renderBox = context.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        final offset = position.dy + scrollController.offset;

        // Animate to the section
        await scrollController.animateTo(
          offset - 80, // Offset for app bar
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );

        // Update active section
        activeSection.value = section;
      }
    }
  }

  /// Scroll to top of the page
  Future<void> scrollToTop() async {
    await scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
    activeSection.value = 'home';
  }
}
