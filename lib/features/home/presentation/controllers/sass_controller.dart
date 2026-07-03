import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A time-triggered roast message.
class _SassMessage {
  final int triggerSeconds;
  final String text;
  const _SassMessage(this.triggerSeconds, this.text);
}

/// Controls the "Sass Bot" — a humorous floating chat bot that drops
/// increasingly desperate/funny messages asking visitors to hire Harsh.
///
/// Messages are triggered by time spent on site and scroll depth.
class SassController extends GetxController {
  // ── Time-based messages (shown in order) ─────────────────────────────────
  static const List<_SassMessage> _timeMessages = [
    _SassMessage(
      10,
      '👀 Still here? Most people bounce faster than my try-catch blocks.',
    ),
    _SassMessage(
      30,
      '30 seconds in! That\'s longer than my app\'s cold start. Impressed.',
    ),
    _SassMessage(
      60,
      '1 whole minute?! You\'re basically my top fan now. 🏆',
    ),
    _SassMessage(
      90,
      'We\'ve been on this first date long enough. '
          'Should I send my resume... again? 📄',
    ),
    _SassMessage(
      120,
      '2 minutes! My mom doesn\'t even spend this long here. '
          'You MUST be a recruiter. 🕵️',
    ),
    _SassMessage(
      180,
      '3 minutes and you haven\'t hired me yet? Bold. Very bold. 🤨',
    ),
    _SassMessage(
      300,
      '5 min. I\'ll accept a job offer, a freelance gig, '
          'OR a pizza at this point. 🍕',
    ),
    _SassMessage(
      420,
      'If you\'re a recruiter: yes, I\'m available. '
          'If you\'re my ex: no, I\'m not. 💅',
    ),
  ];

  Timer? _timer;
  int _elapsedSeconds = 0;
  ScrollController? _scrollController;

  final currentMessage = Rx<String?>(null);
  final isTyping = false.obs;
  final showHireButton = false.obs;
  final isDismissed = false.obs;

  bool _contactRoastShown = false;
  bool _footerRoastShown = false;
  int _nextMessageIndex = 0;
  bool _isBusy = false;

  /// Called by _HomeContent to hook into its scroll position.
  void registerScrollController(ScrollController controller) {
    _scrollController = controller;
    controller.addListener(_onScroll);
  }

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      if (_elapsedSeconds >= 120) {
        showHireButton.value = true;
      }
      _tryNextTimeMessage();
    });
  }

  void _tryNextTimeMessage() {
    if (_isBusy || isDismissed.value) return;
    if (_nextMessageIndex >= _timeMessages.length) return;

    final next = _timeMessages[_nextMessageIndex];
    if (_elapsedSeconds >= next.triggerSeconds) {
      _nextMessageIndex++;
      _showMessage(next.text);
    }
  }

  Future<void> _showMessage(String text) async {
    if (isDismissed.value) return;
    _isBusy = true;

    // Phase 1: typing indicator
    isTyping.value = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    if (isDismissed.value) {
      _cleanup();
      return;
    }

    // Phase 2: reveal message
    isTyping.value = false;
    currentMessage.value = text;
    await Future.delayed(const Duration(seconds: 7));
    if (isDismissed.value) {
      _cleanup();
      return;
    }

    // Phase 3: hide
    currentMessage.value = null;
    _isBusy = false;
  }

  void _onScroll() {
    if (_scrollController == null || isDismissed.value || _isBusy) return;
    final pos = _scrollController!.position;
    if (pos.maxScrollExtent <= 0) return;
    final pct = pos.pixels / pos.maxScrollExtent;

    if (pct > 0.78 && !_contactRoastShown) {
      _contactRoastShown = true;
      _showMessage(
        'Oh, you found Contact! Don\'t be shy — '
        'my inbox is lonelier than a deprecated API. 📬',
      );
    } else if (pct > 0.95 && !_footerRoastShown) {
      _footerRoastShown = true;
      _showMessage(
        'You scrolled to the BOTTOM? That\'s commitment. '
        'I demand at least a LinkedIn connection for this. 🤝',
      );
    }
  }

  /// Scrolls to roughly the Contact section area.
  void scrollToContact() {
    if (_scrollController == null) return;
    final target = _scrollController!.position.maxScrollExtent * 0.82;
    _scrollController!.animateTo(
      target,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void dismiss() {
    isDismissed.value = true;
    _cleanup();
  }

  void _cleanup() {
    currentMessage.value = null;
    isTyping.value = false;
    _isBusy = false;
  }

  @override
  void onClose() {
    _timer?.cancel();
    _scrollController?.removeListener(_onScroll);
    super.onClose();
  }
}
