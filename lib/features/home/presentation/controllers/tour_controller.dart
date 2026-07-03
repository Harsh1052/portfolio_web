import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Defines a single step in the guided tour.
class TourStep {
  final String title;
  final String description;
  final GlobalKey targetKey;
  final IconData icon;

  const TourStep({
    required this.title,
    required this.description,
    required this.targetKey,
    required this.icon,
  });
}

/// Manages the guided-tour lifecycle.
///
/// Sections register their [GlobalKey]s via [registerSectionKeys].
/// The overlay reads [isActive], [currentStepIndex], and calls
/// [nextStep] / [prevStep] / [endTour] to drive the flow.
class TourController extends GetxController {
  final isActive = false.obs;
  final currentStepIndex = 0.obs;
  final spotlightRect = Rx<Rect?>(null);

  final List<TourStep> _steps = [];
  ScrollController? _scrollController;

  List<TourStep> get steps => _steps;
  int get totalSteps => _steps.length;
  TourStep? get currentStep =>
      _steps.isNotEmpty && currentStepIndex.value < _steps.length
          ? _steps[currentStepIndex.value]
          : null;

  /// Must be called once with the page's [ScrollController] and ordered keys.
  void registerSectionKeys({
    required ScrollController scrollController,
    required List<TourStep> steps,
  }) {
    _scrollController = scrollController;
    _steps
      ..clear()
      ..addAll(steps);
  }

  void startTour() {
    if (_steps.isEmpty) return;
    currentStepIndex.value = 0;
    isActive.value = true;
    _scrollToCurrentStep();
  }

  void nextStep() {
    if (currentStepIndex.value < _steps.length - 1) {
      currentStepIndex.value++;
      _scrollToCurrentStep();
    } else {
      endTour();
    }
  }

  void prevStep() {
    if (currentStepIndex.value > 0) {
      currentStepIndex.value--;
      _scrollToCurrentStep();
    }
  }

  void endTour() {
    isActive.value = false;
    spotlightRect.value = null;
  }

  /// Scrolls the section into view and then computes the spotlight rect.
  void _scrollToCurrentStep() {
    final step = currentStep;
    if (step == null || _scrollController == null) return;

    final renderBox =
        step.targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Calculate the widget's position relative to the scroll view.
    final scrollOffset = _scrollController!.offset;
    final viewportHeight = _scrollController!.position.viewportDimension;
    final widgetPosition = renderBox.localToGlobal(Offset.zero);
    final widgetHeight = renderBox.size.height;

    // Target: center the widget in the viewport (or align to top if too tall).
    double targetScroll;
    if (widgetHeight >= viewportHeight) {
      // Widget is taller than viewport — align to top.
      targetScroll = scrollOffset + widgetPosition.dy;
    } else {
      targetScroll = scrollOffset +
          widgetPosition.dy -
          (viewportHeight - widgetHeight) / 2;
    }

    targetScroll = targetScroll.clamp(
      0.0,
      _scrollController!.position.maxScrollExtent,
    );

    _scrollController!.animateTo(
      targetScroll,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );

    // Compute spotlight rect after scroll animation settles.
    Future.delayed(const Duration(milliseconds: 650), () {
      _updateSpotlightRect();
    });
  }

  /// Reads the current step's RenderBox and sets the spotlight rect
  /// relative to the screen.
  void _updateSpotlightRect() {
    final step = currentStep;
    if (step == null) return;

    final renderBox =
        step.targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Add padding around the spotlight.
    const padding = 12.0;
    spotlightRect.value = Rect.fromLTWH(
      position.dx - padding,
      position.dy - padding,
      size.width + padding * 2,
      size.height + padding * 2,
    );
  }
}
