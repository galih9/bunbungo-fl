// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bunbungo/data/achievements_data.dart';
import 'package:bunbungo/data/kana_data.dart';
import 'package:bunbungo/logic/dashboard_analytics.dart';
import 'package:bunbungo/main.dart';
import 'package:bunbungo/models/achievement.dart';
import 'package:bunbungo/models/character_mastery.dart';
import 'package:bunbungo/models/game_settings.dart';
import 'package:bunbungo/models/high_score.dart';
import 'package:bunbungo/models/user_progression.dart';
import 'package:bunbungo/providers/app_providers.dart';
import 'package:bunbungo/screens/about_screen.dart';
import 'package:bunbungo/screens/arena_screen.dart';
import 'package:bunbungo/screens/dashboard_screen.dart';
import 'package:bunbungo/services/persistence_service.dart';
import 'package:bunbungo/theme/app_theme.dart';
import 'package:bunbungo/widgets/achievement_toast.dart';
import 'package:bunbungo/widgets/dashboard_charts.dart';
import 'package:bunbungo/widgets/lobby_deck_customizer.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'BunBunGo',
      packageName: 'com.bunbungo.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
      installerStore: null,
    );
  });

  group('Dashboard Charts Tests', () {
    testWidgets('renders DuolingoDailyActivityChart with bars and streak info', (tester) async {
      final now = DateTime.now();
      final dailyPoints = List.generate(7, (i) {
        final d = now.subtract(Duration(days: 6 - i));
        return DailyActivityDataPoint(
          date: d,
          dateKey: '2026-11-0${i + 1}',
          dayName: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d.weekday - 1],
          lettersPracticed: (i + 1) * 8,
          isToday: i == 6,
          goalReached: (i + 1) * 8 >= 20,
        );
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: DuolingoDailyActivityChart(
                dailyActivity: dailyPoints,
                streakDays: 5,
                dailyGoal: 20,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('DAILY ACTIVITY'), findsOneWidget);
      expect(find.text('Letters Practiced'), findsOneWidget);
      expect(find.text('5 Day Streak'), findsOneWidget);
      expect(find.textContaining('Kana'), findsOneWidget);
    });

    testWidgets('renders RecallSpeedPerformanceChart with speed metrics and toggle', (tester) async {
      final speedPoints = [
        const SpeedPerformancePoint(
          sessionLabel: 'S1',
          dateLabel: '11/10',
          secondsPerLetter: 1.8,
          cardsPerMinute: 33,
          cardsCleared: 20,
          accuracy: 90,
          modeName: 'sprint',
        ),
        const SpeedPerformancePoint(
          sessionLabel: 'S2',
          dateLabel: '11/11',
          secondsPerLetter: 1.2,
          cardsPerMinute: 50,
          cardsCleared: 25,
          accuracy: 96,
          modeName: 'sprint',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: RecallSpeedPerformanceChart(
                speedPoints: speedPoints,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PRACTICE PERFORMANCE'), findsOneWidget);
      expect(find.text('Letter Recall Speed'), findsOneWidget);
      expect(find.text('Sec/Letter'), findsOneWidget);
      expect(find.text('Cards/Min'), findsOneWidget);
      expect(find.text('AVG RESPONSE'), findsOneWidget);
      expect(find.text('BEST SPEED'), findsOneWidget);

      // Toggle to Cards/Min
      await tester.tap(find.text('Cards/Min'));
      await tester.pumpAndSettle();
      expect(find.text('AVG THROUGHPUT'), findsOneWidget);
    });
  });

  group('Sticky Floating Start Practice Button Tests', () {
    testWidgets('shows Start Practice floating button in Arena lobby', (tester) async {
      final persistence = await PersistenceService.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            persistenceProvider.overrideWithValue(persistence),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: ArenaScreen(
                persistence: persistence,
                onDataChanged: () {},
                onNavigateTab: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Start Practice'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });
  });

  group('Hide Bottom Nav During Practice Tests', () {
    testWidgets('hides bottom navigation bar when practicing', (tester) async {
      final persistence = await PersistenceService.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            persistenceProvider.overrideWithValue(persistence),
          ],
          child: BunBunGoFlutterApp(persistence: persistence),
        ),
      );
      await tester.pumpAndSettle();

      // Bottom nav is visible in lobby
      expect(find.text('Arena'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);

      // Tap Start Practice to enter practice session
      await tester.tap(find.text('Start Practice'));
      await tester.pumpAndSettle();

      // Bottom nav is now hidden
      expect(find.text('Dashboard'), findsNothing);
      expect(find.text('Chart'), findsNothing);
      expect(find.text('Settings'), findsNothing);
    });
  });

  group('Achievement Toast Tests', () {
    testWidgets('shows achievement toast overlay in top right corner', (tester) async {
      const testAchievement = AchievementDefinition(
        id: 'test-badge',
        title: 'Master of Kana',
        description: 'Complete all tests with 100% accuracy',
        category: AchievementCategory.performance,
        badgeSymbol: '🏆',
        targetValue: 10,
        xpReward: 100,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () {
                    AchievementToast.show(context, testAchievement);
                  },
                  child: const Text('Show Toast'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap to trigger toast
      await tester.tap(find.text('Show Toast'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('ACHIEVEMENT UNLOCKED'), findsOneWidget);
      expect(find.text('Master of Kana'), findsOneWidget);
      expect(find.text('+100 XP'), findsOneWidget);
      expect(find.text('🏆'), findsOneWidget);

      // Let toast timer finish
      await tester.pump(const Duration(seconds: 4));
    });
  });

  group('Developer Menu in AboutScreen Tests', () {
    testWidgets('developer options are hidden until switch is enabled', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final persistence = await PersistenceService.getInstance();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: AboutScreen(
            persistence: persistence,
            onDataChanged: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -800));
      await tester.pumpAndSettle();

      // Switch is visible but child list is hidden
      expect(find.text('Developer Menu'), findsOneWidget);
      expect(find.text('PROGRESSION & UNLOCKS'), findsNothing);
      expect(find.text('Unlock All Kana Rows'), findsNothing);

      // Toggle Developer Mode switch on
      final switchFinder = find.byType(Switch).last;
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Child developer tools are now visible
      expect(find.text('PROGRESSION & UNLOCKS'), findsOneWidget);
      expect(find.text('Unlock All Kana Rows'), findsOneWidget);
      expect(find.text('Unlock All Badges'), findsOneWidget);
      expect(find.text('Seed Demo Telemetry'), findsOneWidget);
      expect(find.text('Reset All Data & Progress'), findsOneWidget);
      expect(find.text('Test Toast UI'), findsOneWidget);
    });

    testWidgets('unlock switch is hidden from LobbyDeckCustomizer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: LobbyDeckCustomizer(
                settings: const StoredGameSettings(),
                progression: const UserProgression(),
                onUpdateSettings: (_) {},
                onToggleRow: (_) {},
                onSelectPreset: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PRACTICE ROWS'), findsOneWidget);
      // "Unlock All" switch is removed from lobby
      expect(find.text('Unlock All'), findsNothing);
    });
  });
}
