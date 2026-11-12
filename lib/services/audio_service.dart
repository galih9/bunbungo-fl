import 'package:flutter/services.dart';

class AudioService {
  static void playCorrect(int streak, bool enabled, {bool haptic = true}) {
    if (!enabled) return;
    try {
      if (haptic) {
        if (streak > 5) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.lightImpact();
        }
      }
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  static void playWrong(bool enabled, {bool haptic = true}) {
    if (!enabled) return;
    try {
      if (haptic) {
        HapticFeedback.heavyImpact();
      }
      SystemSound.play(SystemSoundType.alert);
    } catch (_) {}
  }

  static void playVictory(bool enabled, {bool haptic = true}) {
    if (!enabled) return;
    try {
      if (haptic) {
        HapticFeedback.heavyImpact();
      }
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  static void playClick(bool enabled, {bool haptic = true}) {
    if (!enabled) return;
    try {
      if (haptic) {
        HapticFeedback.selectionClick();
      }
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  static void playVoiceSample(bool enabled, {bool haptic = true}) {
    if (!enabled) return;
    try {
      if (haptic) {
        HapticFeedback.mediumImpact();
      }
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }
}
