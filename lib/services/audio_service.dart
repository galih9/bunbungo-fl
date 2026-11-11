import 'package:flutter/services.dart';

class AudioService {
  static void playCorrect(int streak, bool enabled) {
    if (!enabled) return;
    try {
      if (streak > 5) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  static void playWrong(bool enabled) {
    if (!enabled) return;
    try {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.alert);
    } catch (_) {}
  }

  static void playVictory(bool enabled) {
    if (!enabled) return;
    try {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  static void playClick(bool enabled) {
    if (!enabled) return;
    try {
      HapticFeedback.selectionClick();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }
}
