import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/game_settings.dart';
import '../providers/app_providers.dart';
import '../services/audio_service.dart';
import '../services/persistence_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animation_effects.dart';
import 'about_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final PersistenceService persistence;
  final VoidCallback onDataChanged;
  final ValueChanged<int>? onNavigateTab;

  const SettingsScreen({
    super.key,
    required this.persistence,
    required this.onDataChanged,
    this.onNavigateTab,
  });

  @override
  ConsumerState<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  late StoredGameSettings _savedSettings;
  late StoredGameSettings _draftSettings;
  bool _isSaving = false;
  String _appVersion = '1.0.0';
  String _buildNumber = '1';
  String? _audioFeedbackMessage;
  Timer? _feedbackTimer;

  bool get _hasChanges => _draftSettings != _savedSettings;

  @override
  void initState() {
    super.initState();
    _loadState();
    _loadVersion();
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    super.dispose();
  }

  void _loadState() {
    final loaded = widget.persistence.loadGameSettings();
    setState(() {
      _savedSettings = loaded;
      _draftSettings = loaded;
    });
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = info.version;
          _buildNumber = info.buildNumber;
        });
      }
    } catch (_) {}
  }

  void refreshData() {
    try {
      ref.read(gameSettingsProvider.notifier).reload();
    } catch (_) {}
    _loadState();
  }

  void _updateDraft(StoredGameSettings updated) {
    setState(() {
      _draftSettings = updated;
    });
  }

  void _showAudioFeedback(String message) {
    _feedbackTimer?.cancel();
    setState(() {
      _audioFeedbackMessage = message;
    });
    _feedbackTimer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() {
          if (_audioFeedbackMessage == message) {
            _audioFeedbackMessage = null;
          }
        });
      }
    });
  }

  Future<void> _saveConfiguration() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    AudioService.playClick(_draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);

    // Smooth delay so the overlay loading is cleanly visible and avoids UI stutter
    await Future.delayed(const Duration(milliseconds: 450));

    // Persist to offline storage & Riverpod
    try {
      ref.read(gameSettingsProvider.notifier).updateSettings(_draftSettings);
    } catch (_) {}
    await widget.persistence.saveGameSettings(_draftSettings);

    // Apply the active theme
    AppColors.applyTheme(_draftSettings.themeMode);

    if (mounted) {
      setState(() {
        _savedSettings = _draftSettings;
        _isSaving = false;
      });

      // Notify the app shell to reload state across all screens
      widget.onDataChanged();

      AudioService.playVictory(_draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Configuration applied & saved successfully!'),
            ],
          ),
          backgroundColor: AppColors.emerald,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Reset Settings to Defaults?', style: TextStyle(color: AppColors.text)),
        content: Text(
          'This will reset the drafted preferences to their factory defaults. Click "Save Configuration" to apply and persist.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _updateDraft(const StoredGameSettings());
              _showAudioFeedback('Draft reset to defaults. Click "Save Configuration" to apply.');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emerald,
              foregroundColor: Colors.black,
            ),
            child: const Text('Reset Draft'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18, top: 16, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Preferences & Config',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  color: _draftSettings.accentColor.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Settings',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (_hasChanges) ...[
                                InkWell(
                                  onTap: _saveConfiguration,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _draftSettings.accentColor.color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: _draftSettings.accentColor.color),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.save_rounded,
                                          size: 14,
                                          color: _draftSettings.accentColor.color,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Save',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: _draftSettings.accentColor.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              IconButton(
                                tooltip: 'Reset to Defaults',
                                icon: Icon(Icons.restart_alt_rounded, color: AppColors.textSecondary),
                                onPressed: _resetToDefaults,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Customize sound effects, voice pronunciation, aesthetic theme, and app info.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (_audioFeedbackMessage != null) ...[
                        const SizedBox(height: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.emerald.withValues(alpha: 0.5)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.volume_up_rounded, size: 16, color: AppColors.emerald),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _audioFeedbackMessage!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.emerald,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // SFX Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: _buildSfxSection(),
                ),
              ),

              // Voice Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: _buildVoiceSection(),
                ),
              ),

              // Theme Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: _buildThemeSection(),
                ),
              ),

              // Practice & Gameplay Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: _buildGameplaySection(),
                ),
              ),

              // About Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: _buildAboutSection(),
                ),
              ),

              // Save Configuration Section at the End
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: _buildSaveSection(),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 36),
              ),
            ],
          ),

          // Loading Overlay when applying configuration
          if (_isSaving)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.65),
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: _draftSettings.accentColor.color,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Applying Configuration...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Persisting audio, voice, and visual theme settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================
  // SFX Configuration Section
  // ==========================================
  Widget _buildSfxSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.music_note_rounded, size: 18, color: AppColors.emerald),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SFX & SOUND EFFECTS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.emerald,
                      ),
                    ),
                    Text(
                      'Game interaction and feedback audio',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _draftSettings.soundEnabled,
                activeThumbColor: AppColors.emerald,
                activeTrackColor: AppColors.emerald.withValues(alpha: 0.3),
                onChanged: (val) {
                  _updateDraft(_draftSettings.copyWith(soundEnabled: val));
                  AudioService.playClick(val, haptic: _draftSettings.hapticEnabled);
                  _showAudioFeedback(val ? 'SFX Enabled (Unsaved)' : 'SFX Muted (Unsaved)');
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),

          // Haptic Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Haptic Vibration',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    'Vibration pulses on answer taps and combos',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
              Switch(
                value: _draftSettings.hapticEnabled,
                activeThumbColor: AppColors.emerald,
                activeTrackColor: AppColors.emerald.withValues(alpha: 0.3),
                onChanged: (val) {
                  _updateDraft(_draftSettings.copyWith(hapticEnabled: val));
                  AudioService.playClick(_draftSettings.soundEnabled, haptic: val);
                  _showAudioFeedback(val ? 'Haptics Activated (Unsaved)' : 'Haptics Disabled (Unsaved)');
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // SFX Volume Slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SFX Volume',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    '${(_draftSettings.sfxVolume * 100).round()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.emerald,
                  inactiveTrackColor: AppColors.surfaceElevated,
                  thumbColor: AppColors.emerald,
                  overlayColor: AppColors.emerald.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: _draftSettings.sfxVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  onChanged: (val) {
                    _updateDraft(_draftSettings.copyWith(sfxVolume: val));
                  },
                ),
              ),
            ],
          ),

          // Sound Preview Pad
          const SizedBox(height: 6),
          Text(
            'TEST SOUND EFFECTS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSoundTestButton(
                label: 'Correct',
                icon: Icons.check_circle_rounded,
                color: AppColors.emerald,
                onTap: () {
                  AudioService.playCorrect(1, _draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);
                  _showAudioFeedback('Tested: Correct Answer SFX');
                },
              ),
              _buildSoundTestButton(
                label: 'Wrong',
                icon: Icons.cancel_rounded,
                color: AppColors.rose,
                onTap: () {
                  AudioService.playWrong(_draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);
                  _showAudioFeedback('Tested: Wrong Alert SFX');
                },
              ),
              _buildSoundTestButton(
                label: 'Victory',
                icon: Icons.emoji_events_rounded,
                color: AppColors.amber,
                onTap: () {
                  AudioService.playVictory(_draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);
                  _showAudioFeedback('Tested: Victory Chime SFX');
                },
              ),
              _buildSoundTestButton(
                label: 'Tap',
                icon: Icons.touch_app_rounded,
                color: AppColors.sky,
                onTap: () {
                  AudioService.playClick(_draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);
                  _showAudioFeedback('Tested: Click SFX');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundTestButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Voice Configuration Section
  // ==========================================
  Widget _buildVoiceSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.record_voice_over_rounded, size: 18, color: AppColors.sky),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VOICE & PRONUNCIATION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.sky,
                      ),
                    ),
                    Text(
                      'Spoken audio cues and Kana pronunciation',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _draftSettings.voiceEnabled,
                activeThumbColor: AppColors.sky,
                activeTrackColor: AppColors.sky.withValues(alpha: 0.3),
                onChanged: (val) {
                  _updateDraft(_draftSettings.copyWith(voiceEnabled: val));
                  AudioService.playVoiceSample(val, haptic: _draftSettings.hapticEnabled);
                  _showAudioFeedback(val ? 'Voice Enabled (Unsaved)' : 'Voice Muted (Unsaved)');
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),

          // Auto-Play Voice on Reveal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto-Speak Kana Cards',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    'Pronounce automatically when cards appear',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
              Switch(
                value: _draftSettings.autoPlayVoice,
                activeThumbColor: AppColors.sky,
                activeTrackColor: AppColors.sky.withValues(alpha: 0.3),
                onChanged: (val) {
                  _updateDraft(_draftSettings.copyWith(autoPlayVoice: val));
                  AudioService.playClick(_draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);
                  _showAudioFeedback(val ? 'Auto-Pronounce On (Unsaved)' : 'Auto-Pronounce Off (Unsaved)');
                },
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Speech Rate Selector
          Text(
            'Pronunciation Pace',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSpeedChip(label: 'Slow (0.8x)', speed: 0.8),
              const SizedBox(width: 8),
              _buildSpeedChip(label: 'Standard (1.0x)', speed: 1.0),
              const SizedBox(width: 8),
              _buildSpeedChip(label: 'Fast (1.2x)', speed: 1.2),
            ],
          ),
          const SizedBox(height: 14),

          // Voice Preview Tester
          InkWell(
            onTap: () {
              AudioService.playVoiceSample(_draftSettings.voiceEnabled, haptic: _draftSettings.hapticEnabled);
              _showAudioFeedback('🔊 Speaking: "あ (a)" at ${_draftSettings.voiceSpeed}x');
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.sky.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.volume_up_rounded, color: AppColors.sky, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Kana Voice Sample',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          'Preview native phonetics and pronunciation cadence',
                          style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.sky.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.sky,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedChip({required String label, required double speed}) {
    final isSelected = (_draftSettings.voiceSpeed - speed).abs() < 0.05;
    return Expanded(
      child: InkWell(
        onTap: () {
          _updateDraft(_draftSettings.copyWith(voiceSpeed: speed));
          AudioService.playClick(_draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);
          _showAudioFeedback('Speed set to ${speed}x (Unsaved)');
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.sky.withValues(alpha: 0.2) : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.sky : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.sky : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Theme Configuration Section
  // ==========================================
  Widget _buildThemeSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.palette_rounded, size: 18, color: AppColors.purple),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APP THEME & DISPLAY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.purple,
                      ),
                    ),
                    Text(
                      'Aesthetic presentation and color accents',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),

          // Theme Mode Selector Cards
          Text(
            'Visual Atmosphere',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 10),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.8,
            children: [
              _buildThemeOptionCard(
                mode: AppThemeMode.dark,
                title: 'Dark Zinc',
                subtitle: 'Sleek dark theme',
                bgPreview: const Color(0xFF09090B),
                cardPreview: const Color(0xFF18181B),
                accentPreview: const Color(0xFF34D399),
              ),
              _buildThemeOptionCard(
                mode: AppThemeMode.oled,
                title: 'Midnight OLED',
                subtitle: 'True deep black',
                bgPreview: const Color(0xFF000000),
                cardPreview: const Color(0xFF0C0C0E),
                accentPreview: const Color(0xFF38BDF8),
              ),
              _buildThemeOptionCard(
                mode: AppThemeMode.light,
                title: 'Light Zen',
                subtitle: 'Crisp white paper',
                bgPreview: const Color(0xFFF4F4F6),
                cardPreview: const Color(0xFFFFFFFF),
                accentPreview: const Color(0xFF059669),
              ),
              _buildThemeOptionCard(
                mode: AppThemeMode.system,
                title: 'System Default',
                subtitle: 'Device appearance',
                bgPreview: const Color(0xFF27272A),
                cardPreview: const Color(0xFF3F3F46),
                accentPreview: const Color(0xFFFBBF24),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Primary Accent Selector
          Text(
            'Primary Accent Tone',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: AppAccentColor.values.map((accent) {
              final isSelected = _draftSettings.accentColor == accent;
              return GestureDetector(
                onTap: () {
                  _updateDraft(_draftSettings.copyWith(accentColor: accent));
                  AudioService.playClick(_draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);
                  _showAudioFeedback('Accent set to ${accent.label} (Unsaved)');
                },
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accent.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: accent.color.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check_rounded, color: Colors.black, size: 20)
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      accent.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.text : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOptionCard({
    required AppThemeMode mode,
    required String title,
    required String subtitle,
    required Color bgPreview,
    required Color cardPreview,
    required Color accentPreview,
  }) {
    final isSelected = _draftSettings.themeMode == mode;

    return InkWell(
      onTap: () {
        _updateDraft(_draftSettings.copyWith(themeMode: mode));
        AudioService.playClick(_draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);
        _showAudioFeedback('Theme selected: $title (Click Save to apply)');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _draftSettings.accentColor.color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Preview Swatch
            Container(
              width: 32,
              height: 38,
              decoration: BoxDecoration(
                color: bgPreview,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 8,
                    decoration: BoxDecoration(
                      color: cardPreview,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 12,
                    height: 4,
                    decoration: BoxDecoration(
                      color: accentPreview,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? _draftSettings.accentColor.color : AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: _draftSettings.accentColor.color, size: 16),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Gameplay Section
  // ==========================================
  Widget _buildGameplaySection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.sports_esports_rounded, size: 18, color: AppColors.amber),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRACTICE & DRILLS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.amber,
                      ),
                    ),
                    Text(
                      'Flashcard controls and challenge sizes',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),

          // Touch Keyboard
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Touch Keyboard',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    'Display on-screen keyboard during typing drills',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
              Switch(
                value: _draftSettings.showTouchKeyboard,
                activeThumbColor: AppColors.amber,
                activeTrackColor: AppColors.amber.withValues(alpha: 0.3),
                onChanged: (val) {
                  _updateDraft(_draftSettings.copyWith(showTouchKeyboard: val));
                  AudioService.playClick(_draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);
                  _showAudioFeedback(val ? 'Keyboard Enabled (Unsaved)' : 'Keyboard Disabled (Unsaved)');
                },
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Sprint Deck Size
          Text(
            'Default Sprint Challenge Size',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [10, 20, 30, 50].map((size) {
              final isSelected = _draftSettings.sprintDeckSize == size;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () {
                      _updateDraft(_draftSettings.copyWith(sprintDeckSize: size));
                      AudioService.playClick(_draftSettings.soundEnabled, haptic: _draftSettings.hapticEnabled);
                      _showAudioFeedback('Sprint deck set to $size (Unsaved)');
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.amber.withValues(alpha: 0.2)
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.amber : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$size cards',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.amber : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // About Section
  // ==========================================
  Widget _buildAboutSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.info_outline_rounded, size: 18, color: AppColors.rose),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APPLICATION & ABOUT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.rose,
                      ),
                    ),
                    Text(
                      'Version info, licenses, and architecture',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),

          // Primary Navigation Tile to AboutScreen
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AboutScreen(
                    persistence: widget.persistence,
                    onDataChanged: widget.onDataChanged,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.rose.withValues(alpha: 0.4)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'あ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About BunBunGo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'v$_appVersion · Build $_buildNumber',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 22),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Open Source Licenses Tile
          InkWell(
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'BunBunGo',
                applicationVersion: 'v$_appVersion · Build $_buildNumber',
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.sky, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Open Source Licenses',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Save Configuration Section (End of Page)
  // ==========================================
  Widget _buildSaveSection() {
    final hasChanges = _hasChanges;
    final accent = _draftSettings.accentColor.color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasChanges ? accent : AppColors.border,
          width: hasChanges ? 1.5 : 1.0,
        ),
        boxShadow: hasChanges
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasChanges
                      ? accent.withValues(alpha: 0.15)
                      : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  hasChanges ? Icons.pending_actions_rounded : Icons.check_circle_outline_rounded,
                  size: 20,
                  color: hasChanges ? accent : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasChanges ? 'UNSAVED PREFERENCES' : 'SETTINGS UP TO DATE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: hasChanges ? accent : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasChanges
                          ? 'Click below to apply and save your changes.'
                          : 'All audio, voice, and theme options are applied.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GlowPulseWidget(
            glowColor: accent,
            animate: hasChanges,
            minScale: 1.0,
            maxScale: 1.015,
            duration: const Duration(milliseconds: 1400),
            child: BouncingWidget(
              scaleFactor: 0.96,
              onTap: _saveConfiguration,
              child: ElevatedButton(
                onPressed: _saveConfiguration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasChanges ? accent : AppColors.text,
                  foregroundColor: hasChanges ? Colors.black : AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: hasChanges ? 3 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.save_rounded,
                      size: 18,
                      color: hasChanges ? Colors.black : AppColors.background,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Save Configuration',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: hasChanges ? Colors.black : AppColors.background,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
