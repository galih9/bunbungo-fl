import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/achievements_data.dart';
import '../logic/progression_engine.dart';
import '../models/user_data_backup.dart';
import '../models/user_progression.dart';
import '../providers/app_providers.dart';
import '../services/backup_service.dart';
import '../services/device_info_helper.dart';
import '../services/persistence_service.dart';
import '../services/sample_data_seeder.dart';
import '../theme/app_theme.dart';
import '../widgets/achievement_toast.dart';

class AboutScreen extends StatefulWidget {
  final PersistenceService? persistence;
  final VoidCallback? onDataChanged;

  const AboutScreen({
    super.key,
    this.persistence,
    this.onDataChanged,
  });

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _packageInfo;
  bool _isLoading = true;
  bool _developerMode = false;
  PersistenceService? _persistence;
  UserDataBackupService? _backupService;
  UserProgression _progression = const UserProgression();

  Map<String, dynamic>? _currentDeviceInfo;
  String? _lastExportDate;
  Map<String, dynamic>? _lastExportDevice;
  String? _lastImportDate;
  Map<String, dynamic>? _lastImportDevice;
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    if (widget.persistence != null) {
      _persistence = widget.persistence;
      _backupService = UserDataBackupService(widget.persistence!);
      _progression = widget.persistence!.loadUserProgression();
      _lastExportDate = widget.persistence!.getLastExportDate();
      _lastExportDevice = widget.persistence!.getLastExportDevice();
      _lastImportDate = widget.persistence!.getLastImportDate();
      _lastImportDevice = widget.persistence!.getLastImportDevice();
    }
    _loadPackageInfo();
    _loadDeveloperMode();
    _initPersistence();
  }

  Future<void> _initPersistence() async {
    final p = widget.persistence ?? await PersistenceService.getInstance();
    final backupService = UserDataBackupService(p);
    Map<String, dynamic>? devInfo;
    try {
      devInfo = await DeviceInfoHelper.getDeviceInfo();
    } catch (_) {}

    if (mounted) {
      setState(() {
        _persistence = p;
        _backupService = backupService;
        _progression = p.loadUserProgression();
        _currentDeviceInfo = devInfo;
        _lastExportDate = p.getLastExportDate();
        _lastExportDevice = p.getLastExportDevice();
        _lastImportDate = p.getLastImportDate();
        _lastImportDevice = p.getLastImportDevice();
      });
    }
  }

  void _syncRiverpod() {
    try {
      final container = ProviderScope.containerOf(context, listen: false);
      container.read(userProgressionProvider.notifier).reload();
      container.read(characterMasteryProvider.notifier).reload();
      container.read(highScoresProvider.notifier).reload();
    } catch (_) {}
  }

  Future<void> _loadDeveloperMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _developerMode = prefs.getBool('developer_mode_enabled') ?? false;
        });
      }
    } catch (_) {}
  }

  Future<void> _setDeveloperMode(bool value) async {
    setState(() {
      _developerMode = value;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('developer_mode_enabled', value);
    } catch (_) {}
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _packageInfo = info;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          // Fallback info in case platform channel fails (e.g., in some test environments)
          _packageInfo = PackageInfo(
            appName: 'BunBunGo',
            packageName: 'com.galihriskipr.bunbungo',
            version: '1.0.0',
            buildNumber: '1',
            buildSignature: '',
            installerStore: null,
          );
          _isLoading = false;
        });
      }
    }
  }

  void _showSafeSnackBar(String message, {IconData? icon, Color? backgroundColor}) {
    final bg = backgroundColor ?? AppColors.emerald;
    final fg = bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: fg, size: 18),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: fg),
              ),
            ),
          ],
        ),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _copyDetailsToClipboard() {
    final info = _packageInfo;
    if (info == null) return;

    final details = '''
BunBunGo System Info:
• App Name: ${info.appName}
• Package Name: ${info.packageName}
• Version: ${info.version}
• Build Number: ${info.buildNumber}
• Platform: ${defaultTargetPlatform.name}
• Installer: ${info.installerStore ?? 'Local/Direct'}
''';

    Clipboard.setData(ClipboardData(text: details.trim()));
    HapticFeedback.lightImpact();

    _showSafeSnackBar('App details copied to clipboard!', icon: Icons.check_circle_outline);
  }

  void _checkUpdates() {
    HapticFeedback.lightImpact();
    _showSafeSnackBar(
      'BunBunGo v${_packageInfo?.version ?? '1.0.0'} is up to date!',
      icon: Icons.verified_rounded,
      backgroundColor: AppColors.sky,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.text),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'About BunBunGo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Copy Info',
            icon: Icon(Icons.copy_rounded, color: AppColors.textSecondary, size: 20),
            onPressed: _packageInfo != null ? _copyDetailsToClipboard : null,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.emerald),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBrandHeader(),
                  const SizedBox(height: 20),
                  _buildPackageInfoCard(),
                  const SizedBox(height: 16),
                  _buildFeaturesCard(),
                  const SizedBox(height: 16),
                  _buildArchitectureCard(),
                  const SizedBox(height: 16),
                  _buildActionsCard(),
                  const SizedBox(height: 20),
                  _buildDeveloperSection(),
                  const SizedBox(height: 24),
                  _buildFooter(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildBrandHeader() {
    final version = _packageInfo?.version ?? '1.0.0';
    final buildNumber = _packageInfo?.buildNumber ?? '1';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Glowing logo icon
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.emerald.withValues(alpha: 0.2),
                  AppColors.sky.withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.emerald.withValues(alpha: 0.4), width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              'あ',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _packageInfo?.appName.isNotEmpty == true
                ? _packageInfo!.appName
                : 'BunBunGo',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Japanese Kana Mastery Arena',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Text(
              'v$version · Build $buildNumber',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.emerald,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageInfoCard() {
    final info = _packageInfo;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: AppColors.sky, size: 18),
              SizedBox(width: 8),
              Text(
                'PACKAGE DETAILS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: AppColors.sky,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Application Name', info?.appName ?? 'BunBunGo'),
          Divider(color: AppColors.border, height: 16),
          _buildInfoRow('Package Identifier', info?.packageName ?? 'com.galihriskipr.bunbungo'),
          Divider(color: AppColors.border, height: 16),
          _buildInfoRow('Semantic Version', info?.version ?? '1.0.0'),
          Divider(color: AppColors.border, height: 16),
          _buildInfoRow('Build Code', info?.buildNumber ?? '1'),
          if (info?.installerStore != null && info!.installerStore!.isNotEmpty) ...[
            Divider(color: AppColors.border, height: 16),
            _buildInfoRow('Installer Source', info.installerStore!),
          ],
          if (info?.buildSignature != null && info!.buildSignature.isNotEmpty) ...[
            Divider(color: AppColors.border, height: 16),
            _buildInfoRow(
              'Build Signature',
              info.buildSignature.length > 16
                  ? '${info.buildSignature.substring(0, 16)}...'
                  : info.buildSignature,
            ),
          ],
          Divider(color: AppColors.border, height: 16),
          _buildInfoRow('Operating System', defaultTargetPlatform.name.toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars_rounded, color: AppColors.amber, size: 18),
              SizedBox(width: 8),
              Text(
                'CORE CAPABILITIES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFeatureBullet(
            icon: Icons.translate_rounded,
            title: 'Complete 104 Kana Syllabary',
            description: 'Comprehensive coverage of Gojūon, Dakuten, Handakuten, and Yōon compounds.',
          ),
          const SizedBox(height: 10),
          _buildFeatureBullet(
            icon: Icons.psychology_rounded,
            title: 'Adaptive Mastery Analytics',
            description: 'Track response speed, accuracy, and spaced review cues per character.',
          ),
          const SizedBox(height: 10),
          _buildFeatureBullet(
            icon: Icons.flash_on_rounded,
            title: 'Sprint, Time-Attack & Zen Modes',
            description: 'High-speed challenges with instant haptic and audio feedback.',
          ),
          const SizedBox(height: 10),
          _buildFeatureBullet(
            icon: Icons.shield_outlined,
            title: '100% Offline & Private',
            description: 'Local persistence engine with zero background tracking or telemetry.',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBullet({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.emerald),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArchitectureCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.terminal_rounded, color: AppColors.purple, size: 18),
              SizedBox(width: 8),
              Text(
                'STACK & DEPENDENCIES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('UI Framework', 'Flutter (Material 3)'),
          Divider(color: AppColors.border, height: 16),
          _buildInfoRow('Language', 'Dart 3.x with sound null-safety'),
          Divider(color: AppColors.border, height: 16),
          _buildInfoRow('Telemetry Package', 'package_info_plus ^10.2.2'),
          Divider(color: AppColors.border, height: 16),
          _buildInfoRow('Local Storage', 'shared_preferences ^2.5.6'),
          Divider(color: AppColors.border, height: 16),
          _buildInfoRow('Haptic & Audio', 'SystemSound & HapticFeedback'),
        ],
      ),
    );
  }

  Widget _buildActionsCard() {
    return Column(
      children: [
        InkWell(
          onTap: _checkUpdates,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.system_update_rounded, color: AppColors.emerald, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Check for Updates',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            showLicensePage(
              context: context,
              applicationName: _packageInfo?.appName ?? 'BunBunGo',
              applicationVersion: 'v${_packageInfo?.version ?? '1.0.0'}',
              applicationLegalese: 'Crafted with precision for Japanese learners worldwide.',
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.description_outlined, color: AppColors.sky, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Open Source Licenses',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperSection() {
    final persistence = _persistence;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _developerMode
              ? AppColors.amber.withValues(alpha: 0.6)
              : AppColors.border,
          width: _developerMode ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Developer Mode Master Switch
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _developerMode
                        ? AppColors.amber.withValues(alpha: 0.2)
                        : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.terminal_rounded,
                    color: _developerMode ? AppColors.amber : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Developer Menu',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        'Progression overrides, unlocks & telemetry tools',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _developerMode,
                  onChanged: (val) {
                    _setDeveloperMode(val);
                    _showSafeSnackBar(
                      val ? 'Developer Menu options enabled' : 'Developer Menu options disabled',
                      icon: Icons.terminal_rounded,
                      backgroundColor: AppColors.surfaceElevated,
                    );
                  },
                  activeThumbColor: AppColors.amber,
                ),
              ],
            ),
          ),

          // Child List (revealed when developer mode is switched on)
          if (_developerMode) ...[
            Divider(color: AppColors.border, height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section: Progression & Unlocks
                  Text(
                    'PROGRESSION & UNLOCKS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: AppColors.amber,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 1. Unlock All Kana Rows
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_open_rounded,
                          size: 18,
                          color: _progression.unlockAllRows ? AppColors.emerald : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unlock All Kana Rows',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.text,
                                ),
                              ),
                              Text(
                                'All 104 characters available in practice',
                                style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _progression.unlockAllRows,
                          onChanged: (val) {
                            final next = _progression.copyWith(unlockAllRows: val);
                            setState(() {
                              _progression = next;
                            });
                            _persistence?.saveUserProgression(next);
                            _syncRiverpod();
                            widget.onDataChanged?.call();
                            HapticFeedback.lightImpact();
                          },
                          activeThumbColor: AppColors.emerald,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 2. Achievements Unlocks
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final nowIso = DateTime.now().toIso8601String();
                            final allMap = <String, String>{};
                            int bonusXp = 0;
                            for (final def in achievementDefinitions) {
                              allMap[def.id] = nowIso;
                              bonusXp += def.xpReward;
                            }
                            final newXp = _progression.xp + bonusXp;
                            final next = _progression.copyWith(
                              xp: newXp,
                              level: calculateLevelFromXp(newXp),
                              unlockedAchievements: allMap,
                            );
                            setState(() {
                              _progression = next;
                            });
                            _persistence?.saveUserProgression(next);
                            _syncRiverpod();
                            widget.onDataChanged?.call();
                            HapticFeedback.mediumImpact();
                            if (achievementDefinitions.isNotEmpty) {
                              AchievementToast.show(context, achievementDefinitions.first);
                            }
                            _showSafeSnackBar('All achievements unlocked!', icon: Icons.military_tech_rounded);
                          },
                          icon: const Icon(Icons.military_tech_rounded, size: 16),
                          label: const Text('Unlock All Badges', style: TextStyle(fontSize: 11)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.amber,
                            side: BorderSide(color: AppColors.amber.withValues(alpha: 0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          final next = _progression.copyWith(
                            unlockedAchievements: const {},
                          );
                          setState(() {
                            _progression = next;
                          });
                          _persistence?.saveUserProgression(next);
                          _syncRiverpod();
                          widget.onDataChanged?.call();
                          HapticFeedback.lightImpact();
                          _showSafeSnackBar(
                            'Achievements reset to locked.',
                            backgroundColor: AppColors.textSecondary,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Lock Badges', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Section: Backup & Restore User Data (.bbg disguise)
                  _buildBackupRestoreSection(),

                  const SizedBox(height: 16),

                  // Section: Telemetry & Mock Data
                  Text(
                    'DATA & TELEMETRY GENERATOR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: AppColors.sky,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Seed Demo Telemetry
                  OutlinedButton.icon(
                    onPressed: persistence == null
                        ? null
                        : () {
                            final seeded = SampleDataSeeder.seed(persistence);
                            setState(() {
                              _progression = seeded.progression;
                            });
                            _syncRiverpod();
                            widget.onDataChanged?.call();
                            HapticFeedback.mediumImpact();
                            _showSafeSnackBar(
                              'Demo telemetry seeded! Check dashboard charts & stats.',
                              icon: Icons.science_outlined,
                            );
                          },
                    icon: const Icon(Icons.science_outlined, size: 16),
                    label: const Text('Seed Demo Telemetry'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.sky,
                      side: BorderSide(color: AppColors.sky.withValues(alpha: 0.6)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Reset All Progress Button
                  OutlinedButton.icon(
                    onPressed: persistence == null
                        ? null
                        : () {
                            _showResetConfirmationDialog(persistence);
                          },
                    icon: const Icon(Icons.delete_forever_rounded, size: 16),
                    label: const Text('Reset All Data & Progress'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.rose,
                      side: BorderSide(color: AppColors.rose.withValues(alpha: 0.6)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Section: UI Testing Utilities
                  Text(
                    'UI TESTING UTILITIES',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (achievementDefinitions.isNotEmpty) {
                              AchievementToast.show(context, achievementDefinitions.first);
                            }
                            HapticFeedback.lightImpact();
                          },
                          icon: const Icon(Icons.notification_important_outlined, size: 16),
                          label: const Text('Test Toast UI', style: TextStyle(fontSize: 11)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.amber,
                            side: BorderSide(color: AppColors.amber.withValues(alpha: 0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final newXp = _progression.xp + 1000;
                            final next = _progression.copyWith(
                              xp: newXp,
                              level: calculateLevelFromXp(newXp),
                            );
                            setState(() {
                              _progression = next;
                            });
                            _persistence?.saveUserProgression(next);
                            _syncRiverpod();
                            widget.onDataChanged?.call();
                            HapticFeedback.lightImpact();
                            _showSafeSnackBar('+1,000 XP granted!', icon: Icons.bolt_rounded);
                          },
                          icon: const Icon(Icons.bolt_rounded, size: 16),
                          label: const Text('+1,000 XP', style: TextStyle(fontSize: 11)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.emerald,
                            side: BorderSide(color: AppColors.emerald.withValues(alpha: 0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBackupRestoreSection() {
    final lastExportStr = _formatIsoDate(_lastExportDate);
    final lastExportDevStr = _lastExportDevice != null
        ? DeviceInfoHelper.formatDeviceSummary(_lastExportDevice)
        : null;
    final lastImportStr = _formatIsoDate(_lastImportDate);
    final lastImportDevStr = _lastImportDevice != null
        ? DeviceInfoHelper.formatDeviceSummary(_lastImportDevice)
        : null;
    final currentDevStr = DeviceInfoHelper.formatDeviceSummary(_currentDeviceInfo);
    final appVerStr = 'v${_packageInfo?.version ?? '1.1.0'}+${_packageInfo?.buildNumber ?? '2'}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'BACKUP & RESTORE USER DATA',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: AppColors.emerald,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.emerald.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.emerald.withValues(alpha: 0.4)),
              ),
              child: Text(
                '.bbg DISGUISED JSON',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackupMetaRow(
                icon: Icons.layers_outlined,
                label: 'App Version',
                value: appVerStr,
              ),
              Divider(height: 14, color: AppColors.border),
              _buildBackupMetaRow(
                icon: Icons.devices_rounded,
                label: 'Current Device',
                value: currentDevStr,
              ),
              Divider(height: 14, color: AppColors.border),
              _buildBackupMetaRow(
                icon: Icons.upload_file_rounded,
                label: 'Last Exported',
                value: lastExportStr,
                subtitle: lastExportDevStr,
              ),
              Divider(height: 14, color: AppColors.border),
              _buildBackupMetaRow(
                icon: Icons.download_rounded,
                label: 'Last Imported',
                value: lastImportStr,
                subtitle: lastImportDevStr,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                key: const Key('dev_export_user_data_button'),
                onPressed: _isExporting || _isImporting ? null : _handleExportUserData,
                icon: _isExporting
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.file_upload_outlined, size: 16),
                label: Text(
                  _isExporting ? 'Exporting...' : 'Export .bbg',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  foregroundColor: AppColors.emerald.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('dev_import_user_data_button'),
                onPressed: _isExporting || _isImporting ? null : _handleImportUserData,
                icon: _isImporting
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.sky),
                      )
                    : const Icon(Icons.file_download_outlined, size: 16),
                label: Text(
                  _isImporting ? 'Importing...' : 'Import .bbg',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.sky,
                  side: BorderSide(color: AppColors.sky.withValues(alpha: 0.6)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackupMetaRow({
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatIsoDate(String? iso) {
    if (iso == null || iso.isEmpty) return 'Never';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final y = dt.year.toString().padLeft(4, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      final hh = dt.hour.toString().padLeft(2, '0');
      final mm = dt.minute.toString().padLeft(2, '0');
      return '$y-$m-$d $hh:$mm';
    } catch (_) {
      return iso;
    }
  }

  Future<void> _handleExportUserData() async {
    final persistence = _persistence;
    if (persistence == null) return;
    final backupService = _backupService ?? UserDataBackupService(persistence);

    setState(() => _isExporting = true);
    try {
      final appVer = '${_packageInfo?.version ?? '1.1.0'}+${_packageInfo?.buildNumber ?? '2'}';
      final bbgFile = await backupService.exportUserData(
        appVersionOverride: appVer,
        deviceInfoOverride: _currentDeviceInfo,
      );

      if (mounted) {
        setState(() {
          _lastExportDate = persistence.getLastExportDate();
          _lastExportDevice = persistence.getLastExportDevice();
        });
      }

      HapticFeedback.mediumImpact();
      if (mounted) {
        _showExportSuccessDialog(bbgFile);
      }
    } catch (e) {
      if (mounted) {
        _showSafeSnackBar('Export failed: $e', icon: Icons.error_outline, backgroundColor: AppColors.rose);
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  void _showExportSuccessDialog(File bbgFile) {
    final prog = _progression;
    final fileName = bbgFile.path.split(Platform.pathSeparator).last;
    int fileSizeKb = 0;
    try {
      fileSizeKb = (bbgFile.lengthSync() / 1024).ceil();
    } catch (_) {}

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'User Data Exported',
                style: TextStyle(color: AppColors.text, fontSize: 16),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Data packed into JSON and disguised as a .bbg file for safe keeping & portability.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Size: ~$fileSizeKb KB · Format: Disguised JSON (.bbg)',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                    Divider(height: 12, color: AppColors.border),
                    Text(
                      'Full Path: ${bbgFile.path}',
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Contents: Level ${prog.level} (${prog.xp} XP), Streak: ${prog.currentDailyStreak}d, Badges: ${prog.unlockedAchievements.length}, Rows: ${prog.unlockedRowIds.length}',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: bbgFile.path));
              _showSafeSnackBar('File path copied to clipboard!', icon: Icons.copy_rounded);
            },
            icon: const Icon(Icons.copy_rounded, size: 14),
            label: const Text('Copy Path', style: TextStyle(fontSize: 11)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: BorderSide(color: AppColors.border),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await SharePlus.instance.share(
                  ShareParams(
                    files: [XFile(bbgFile.path)],
                    subject: 'BunBunGo User Data Backup ($fileName)',
                  ),
                );
              } catch (_) {}
            },
            icon: const Icon(Icons.ios_share_rounded, size: 14),
            label: const Text('Share File', style: TextStyle(fontSize: 11)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emerald,
              foregroundColor: AppColors.emerald.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImportUserData() async {
    final persistence = _persistence;
    if (persistence == null) return;
    final backupService = _backupService ?? UserDataBackupService(persistence);

    final localBackups = await backupService.listLocalBackups();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _buildImportSelectionSheet(ctx, backupService, localBackups),
    );
  }

  Widget _buildImportSelectionSheet(
    BuildContext sheetContext,
    UserDataBackupService backupService,
    List<File> localBackups,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.file_download_rounded, color: AppColors.sky, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Import User Data (.bbg)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(sheetContext),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Select a .bbg file to restore all progress, streaks, achievements, and kana mastery.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            // Browse File Button
            ElevatedButton.icon(
              key: const Key('browse_bbg_storage_button'),
              onPressed: () async {
                Navigator.pop(sheetContext);
                await _pickAndInspectBbgFile(backupService);
              },
              icon: const Icon(Icons.folder_open_rounded, size: 18),
              label: const Text('Browse Device Storage for .bbg'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sky,
                foregroundColor: AppColors.sky.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            if (localBackups.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'RECENT ON-DEVICE BACKUPS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: localBackups.length.clamp(0, 5),
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (_, index) {
                    final file = localBackups[index];
                    final name = file.path.split(Platform.pathSeparator).last;
                    String modDate = '';
                    try {
                      modDate = _formatIsoDate(file.lastModifiedSync().toIso8601String());
                    } catch (_) {}

                    return InkWell(
                      onTap: () {
                        Navigator.pop(sheetContext);
                        _previewAndConfirmImport(file, backupService);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.insert_drive_file_outlined, color: AppColors.sky, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  if (modDate.isNotEmpty)
                                    Text(
                                      modDate,
                                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                                    ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndInspectBbgFile(UserDataBackupService backupService) async {
    PlatformFile? picked;
    try {
      picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['bbg'],
      );
    } catch (_) {
      try {
        picked = await FilePicker.pickFile(type: FileType.any);
      } catch (e) {
        _showSafeSnackBar('Unable to open file picker: $e', icon: Icons.error_outline, backgroundColor: AppColors.rose);
        return;
      }
    }

    if (picked == null) return;

    final selectedPath = picked.path;
    if (selectedPath == null || selectedPath.isEmpty) {
      _showSafeSnackBar('No file selected.', backgroundColor: AppColors.textSecondary);
      return;
    }

    if (!selectedPath.toLowerCase().endsWith('.bbg')) {
      _showSafeSnackBar(
        'Selected file is not a .bbg backup. Please select a .bbg file.',
        icon: Icons.warning_amber_rounded,
        backgroundColor: AppColors.rose,
      );
      return;
    }

    final file = File(selectedPath);
    if (!mounted) return;
    _previewAndConfirmImport(file, backupService);
  }

  Future<void> _previewAndConfirmImport(
    File bbgFile,
    UserDataBackupService backupService,
  ) async {
    setState(() => _isImporting = true);
    final UserDataBackup backup;
    try {
      backup = await backupService.inspectBackupFile(bbgFile);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text('Invalid .bbg File', style: TextStyle(color: AppColors.rose)),
            content: Text(
              'Could not read user data from ${bbgFile.path.split(Platform.pathSeparator).last}.\n\nError: $e',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('OK', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          ),
        );
      }
      return;
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }

    if (!mounted) return;

    final fileName = bbgFile.path.split(Platform.pathSeparator).last;
    final devSummary = DeviceInfoHelper.formatDeviceSummary(backup.deviceInfo);
    final prog = backup.progression;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            Icon(Icons.restore_page_rounded, color: AppColors.sky, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Restore User Data?',
                style: TextStyle(color: AppColors.text, fontSize: 16),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'File: $fileName',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.sky,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Exported: ${_formatIsoDate(backup.exportedAt)} · App: ${backup.appVersion}',
                style: TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
              Text(
                'Origin Device: $devSummary',
                style: TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BACKUP DATA CONTENTS',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.emerald,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('• Level ${prog.level} · ${prog.xp} Total XP', style: TextStyle(fontSize: 11, color: AppColors.text)),
                    Text('• Streaks: ${prog.currentDailyStreak} days (Best: ${prog.bestDailyStreak})', style: TextStyle(fontSize: 11, color: AppColors.text)),
                    Text('• Unlocked Rows: ${prog.unlockedRowIds.length} rows (All unlocked: ${prog.unlockAllRows})', style: TextStyle(fontSize: 11, color: AppColors.text)),
                    Text('• Achievements: ${prog.unlockedAchievements.length} badges', style: TextStyle(fontSize: 11, color: AppColors.text)),
                    Text('• Kana Mastery: ${backup.mastery.length} characters tracked', style: TextStyle(fontSize: 11, color: AppColors.text)),
                    Text('• High Scores: ${backup.highScores.length} records', style: TextStyle(fontSize: 11, color: AppColors.text)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.amber.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Restoring will overwrite current progress with this backup.',
                        style: TextStyle(fontSize: 10, color: AppColors.amber),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isImporting = true);
              try {
                // When starting to process the file, backupService renames to .json, consumes it, and applies to database
                final applied = await backupService.importUserDataFromFile(bbgFile);

                if (mounted) {
                  setState(() {
                    _progression = applied.progression;
                    _lastImportDate = _persistence?.getLastImportDate();
                    _lastImportDevice = _persistence?.getLastImportDevice();
                  });
                }

                _syncRiverpod();
                widget.onDataChanged?.call();
                HapticFeedback.heavyImpact();

                if (mounted) {
                  _showSafeSnackBar(
                    'User data restored! Level ${applied.progression.level} · ${applied.progression.xp} XP',
                    icon: Icons.check_circle_rounded,
                    backgroundColor: AppColors.emerald,
                  );
                }
              } catch (e) {
                if (mounted) {
                  _showSafeSnackBar('Restore failed: $e', icon: Icons.error_outline, backgroundColor: AppColors.rose);
                }
              } finally {
                if (mounted) {
                  setState(() => _isImporting = false);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sky,
              foregroundColor: AppColors.sky.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            ),
            child: const Text('Apply & Restore'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmationDialog(PersistenceService persistence) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Reset All Progress?', style: TextStyle(color: AppColors.text)),
        content: Text(
          'This will permanently clear all mastery telemetry, unlocked rows, streaks, XP, and local high scores.',
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
              persistence.clearAllProgress();
              setState(() {
                _progression = const UserProgression();
              });
              _syncRiverpod();
              widget.onDataChanged?.call();
              HapticFeedback.heavyImpact();
              _showSafeSnackBar(
                'All progress and telemetry has been reset.',
                backgroundColor: AppColors.rose,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rose,
              foregroundColor: AppColors.rose.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            ),
            child: Text(
              'Reset',
              style: TextStyle(
                color: AppColors.rose.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'BunBunGo · Japanese Kana Learning System',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Crafted with Flutter & Dart · All Rights Reserved',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textMuted.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
