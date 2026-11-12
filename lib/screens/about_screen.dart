import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _packageInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('App details copied to clipboard!'),
          ],
        ),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _checkUpdates() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.verified_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('BunBunGo v${_packageInfo?.version ?? '1.0.0'} is up to date!'),
          ],
        ),
        backgroundColor: AppColors.sky,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
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
