import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bunbungo/models/game_settings.dart';
import 'package:bunbungo/screens/about_screen.dart';
import 'package:bunbungo/screens/settings_screen.dart';
import 'package:bunbungo/services/persistence_service.dart';
import 'package:bunbungo/theme/app_theme.dart';

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Bun Bun Go',
      packageName: 'com.bunbungo.app',
      version: '2.0.1',
      buildNumber: '10',
      buildSignature: 'sig1234567890',
      installerStore: 'Google Play',
    );
  });

  group('StoredGameSettings Serialization Tests', () {
    test('default settings have audio, voice, and theme presets', () {
      const settings = StoredGameSettings();
      expect(settings.soundEnabled, isTrue);
      expect(settings.voiceEnabled, isTrue);
      expect(settings.hapticEnabled, isTrue);
      expect(settings.themeMode, AppThemeMode.dark);
      expect(settings.accentColor, AppAccentColor.emerald);
      expect(settings.sfxVolume, 1.0);
      expect(settings.autoPlayVoice, isFalse);
      expect(settings.voiceSpeed, 1.0);
    });

    test('toJson and fromJson preserves all settings values', () {
      const original = StoredGameSettings(
        soundEnabled: false,
        voiceEnabled: true,
        hapticEnabled: false,
        themeMode: AppThemeMode.oled,
        accentColor: AppAccentColor.purple,
        sfxVolume: 0.7,
        autoPlayVoice: true,
        voiceSpeed: 1.2,
        voiceVolume: 0.8,
        sprintDeckSize: 50,
      );

      final json = original.toJson();
      final restored = StoredGameSettings.fromJson(json);

      expect(restored.soundEnabled, isFalse);
      expect(restored.voiceEnabled, isTrue);
      expect(restored.hapticEnabled, isFalse);
      expect(restored.themeMode, AppThemeMode.oled);
      expect(restored.accentColor, AppAccentColor.purple);
      expect(restored.sfxVolume, 0.7);
      expect(restored.autoPlayVoice, isTrue);
      expect(restored.voiceSpeed, 1.2);
      expect(restored.voiceVolume, 0.8);
      expect(restored.sprintDeckSize, 50);
    });

    test('AppColors applyTheme dynamically updates background, surface, and typography', () {
      // Dark
      AppColors.applyTheme(AppThemeMode.dark);
      expect(AppColors.isLight, isFalse);
      expect(AppColors.surface, const Color(0xFF18181B));
      expect(AppColors.text, const Color(0xFFF4F4F5));

      // Light
      AppColors.applyTheme(AppThemeMode.light);
      expect(AppColors.isLight, isTrue);
      expect(AppColors.surface, const Color(0xFFFFFFFF));
      expect(AppColors.background, const Color(0xFFF4F4F6));
      expect(AppColors.text, const Color(0xFF09090B));

      // OLED
      AppColors.applyTheme(AppThemeMode.oled);
      expect(AppColors.isLight, isFalse);
      expect(AppColors.isOled, isTrue);
      expect(AppColors.background, const Color(0xFF000000));

      // Light Minimal
      AppColors.applyTheme(AppThemeMode.lightMinimal);
      expect(AppColors.isLight, isTrue);
      expect(AppColors.isMinimal, isTrue);
      expect(AppColors.background, const Color(0xFFFFFFFF));
      expect(AppColors.text, const Color(0xFF000000));
      expect(AppColors.emerald, const Color(0xFF000000));

      // Dark Minimal
      AppColors.applyTheme(AppThemeMode.darkMinimal);
      expect(AppColors.isLight, isFalse);
      expect(AppColors.isMinimal, isTrue);
      expect(AppColors.background, const Color(0xFF000000));
      expect(AppColors.text, const Color(0xFFFFFFFF));
      expect(AppColors.emerald, const Color(0xFFFFFFFF));

      // Restore dark for subsequent tests
      AppColors.applyTheme(AppThemeMode.dark);
    });
  });

  group('AboutScreen Widget Tests', () {
    testWidgets('renders package info details from platform', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const AboutScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify app bar title
      expect(find.text('About BunBunGo'), findsOneWidget);

      // Verify PackageInfo details are loaded
      expect(find.text('v2.0.1 · Build 10'), findsOneWidget);
      expect(find.text('com.bunbungo.app'), findsOneWidget);
      expect(find.text('2.0.1'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      // Scroll down to action buttons
      await tester.scrollUntilVisible(
        find.text('Check for Updates'),
        200,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      expect(find.text('Check for Updates'), findsOneWidget);
      expect(find.text('Open Source Licenses'), findsOneWidget);

      // Tap Check for Updates
      await tester.tap(find.text('Check for Updates'));
      await tester.pump();
      expect(find.text('BunBunGo v2.0.1 is up to date!'), findsOneWidget);
    });

    testWidgets('developer mode toggle reveals backup and restore section with export/import buttons', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'developer_mode_enabled': true});
      final persistence = await PersistenceService.getInstance();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: AboutScreen(persistence: persistence),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll down to developer section buttons
      await tester.scrollUntilVisible(
        find.byKey(const Key('dev_export_user_data_button')),
        200,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      expect(find.text('BACKUP & RESTORE USER DATA'), findsOneWidget);
      expect(find.text('.bbg DISGUISED JSON'), findsOneWidget);
      expect(find.text('App Version'), findsOneWidget);
      expect(find.text('Current Device'), findsOneWidget);
      expect(find.text('Last Exported'), findsOneWidget);
      expect(find.text('Last Imported'), findsOneWidget);
      expect(find.byKey(const Key('dev_export_user_data_button')), findsOneWidget);
      expect(find.byKey(const Key('dev_import_user_data_button')), findsOneWidget);

      // Tap Export .bbg button with runAsync to allow filesystem I/O
      await tester.runAsync(() async {
        await tester.tap(find.byKey(const Key('dev_export_user_data_button')));
        await Future<void>.delayed(const Duration(milliseconds: 150));
      });
      await tester.pumpAndSettle();

      // Verify success dialog appears with disguised JSON .bbg info
      expect(find.text('User Data Exported'), findsOneWidget);
      expect(find.textContaining('disguised as a .bbg file'), findsOneWidget);
      expect(find.text('Copy Path'), findsOneWidget);
      expect(find.text('Share File'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify persistence recorded the export
      expect(persistence.getLastExportDate(), isNotNull);
      expect(persistence.getLastExportPath(), isNotNull);
      expect(persistence.getLastExportPath()!.endsWith('.bbg'), isTrue);
    });

    testWidgets('tapping Import .bbg opens import selection sheet asking for .bbg file', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'developer_mode_enabled': true});
      final persistence = await PersistenceService.getInstance();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: AboutScreen(persistence: persistence),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll down to developer section buttons
      await tester.scrollUntilVisible(
        find.byKey(const Key('dev_import_user_data_button')),
        200,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      // Tap Import .bbg button
      await tester.runAsync(() async {
        await tester.tap(find.byKey(const Key('dev_import_user_data_button')));
        await Future<void>.delayed(const Duration(milliseconds: 150));
      });
      await tester.pumpAndSettle();

      // Verify import bottom sheet asks for .bbg file
      expect(find.text('Import User Data (.bbg)'), findsOneWidget);
      expect(find.text('Browse Device Storage for .bbg'), findsOneWidget);
      expect(find.textContaining('Select a .bbg file to restore all progress'), findsOneWidget);

      // Close bottom sheet
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
    });
  });

  group('SettingsScreen Widget Tests', () {
    testWidgets('modifying draft does not immediately apply until Save Configuration is clicked', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final persistence = await PersistenceService.getInstance();
      bool dataChangedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: SettingsScreen(
            persistence: persistence,
            onDataChanged: () => dataChangedCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify header and top sections
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('SFX & SOUND EFFECTS'), findsOneWidget);
      expect(find.text('VOICE & PRONUNCIATION'), findsOneWidget);

      // Test sound effect test buttons
      expect(find.text('Correct'), findsOneWidget);
      expect(find.text('Wrong'), findsOneWidget);
      expect(find.text('Victory'), findsOneWidget);
      expect(find.text('Tap'), findsOneWidget);

      await tester.tap(find.text('Correct'));
      await tester.pump();
      expect(find.text('Tested: Correct Answer SFX'), findsOneWidget);

      // Scroll to voice speed chips
      await tester.scrollUntilVisible(
        find.text('Fast (1.2x)'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // Tap Fast (1.2x) -> updates draft, but does NOT trigger expensive persistence/onDataChanged
      await tester.tap(find.text('Fast (1.2x)'));
      await tester.pump();
      expect(dataChangedCalled, isFalse, reason: 'Settings should not be persisted until saved');

      // Scroll to Theme section
      await tester.scrollUntilVisible(
        find.text('APP THEME & DISPLAY'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('APP THEME & DISPLAY'), findsOneWidget);

      // Tap Midnight OLED -> updates draft, does NOT trigger expensive persistence/onDataChanged
      await tester.tap(find.text('Midnight OLED'));
      await tester.pump();
      expect(dataChangedCalled, isFalse);

      // Scroll to Save Configuration section
      await tester.scrollUntilVisible(
        find.text('Save Configuration'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('UNSAVED PREFERENCES'), findsOneWidget);
      expect(find.text('Save Configuration'), findsOneWidget);

      // Tap Save Configuration
      await tester.tap(find.text('Save Configuration'));
      // Immediate pump shows overlay loading!
      await tester.pump();
      expect(find.text('Applying Configuration...'), findsOneWidget);

      // Advance clock past the save transition
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Verify persistence and dataChanged were called
      expect(dataChangedCalled, isTrue);
      final loaded = persistence.loadGameSettings();
      expect(loaded.themeMode, AppThemeMode.oled);
      expect(loaded.voiceSpeed, 1.2);
      expect(find.text('Configuration applied & saved successfully!'), findsOneWidget);

      // Scroll to About section and tap About BunBunGo
      await tester.scrollUntilVisible(
        find.text('About BunBunGo'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('About BunBunGo'));
      await tester.pumpAndSettle();
      expect(find.text('PACKAGE DETAILS'), findsOneWidget);

      // Let timer finish
      await tester.pump(const Duration(seconds: 2));
    });
  });
}
