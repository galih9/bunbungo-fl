import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/achievements_data.dart';
import 'data/kana_data.dart';
import 'logic/mastery_analytics.dart';
import 'logic/progression_engine.dart';
import 'models/character_mastery.dart';
import 'models/game_settings.dart';
import 'models/user_progression.dart';
import 'screens/arena_screen.dart';
import 'screens/chart_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/stats_screen.dart';
import 'services/persistence_service.dart';
import 'theme/app_theme.dart';
import 'widgets/app_bottom_nav.dart';
import 'widgets/app_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final persistence = await PersistenceService.getInstance();
  final initialSettings = persistence.loadGameSettings();
  AppColors.applyTheme(initialSettings.themeMode);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: AppColors.isLight ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: AppColors.isLight ? Brightness.dark : Brightness.light,
    ),
  );

  runApp(BunBunGoFlutterApp(persistence: persistence));
}

class BunBunGoFlutterApp extends StatefulWidget {
  final PersistenceService persistence;

  const BunBunGoFlutterApp({super.key, required this.persistence});

  @override
  State<BunBunGoFlutterApp> createState() => _BunBunGoFlutterAppState();
}

class _BunBunGoFlutterAppState extends State<BunBunGoFlutterApp> {
  late StoredGameSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.persistence.loadGameSettings();
    AppColors.applyTheme(_settings.themeMode);
  }

  void _handleSettingsChanged() {
    setState(() {
      _settings = widget.persistence.loadGameSettings();
      AppColors.applyTheme(_settings.themeMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPlatformDark =
        MediaQuery.maybePlatformBrightnessOf(context) == Brightness.dark;
    AppColors.applyTheme(_settings.themeMode, isPlatformDark: isPlatformDark);
    final isOled = _settings.themeMode == AppThemeMode.oled;

    return MaterialApp(
      title: 'Bun Bun Go',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        AppThemeMode.light,
        accent: _settings.accentColor,
        isPlatformDark: false,
      ),
      darkTheme: AppTheme.getTheme(
        isOled ? AppThemeMode.oled : AppThemeMode.dark,
        accent: _settings.accentColor,
        isPlatformDark: true,
      ),
      themeMode: _settings.themeMode == AppThemeMode.light
          ? ThemeMode.light
          : (_settings.themeMode == AppThemeMode.system ? ThemeMode.system : ThemeMode.dark),
      home: MainShell(
        persistence: widget.persistence,
        onAppSettingsChanged: _handleSettingsChanged,
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final PersistenceService persistence;
  final VoidCallback? onAppSettingsChanged;

  const MainShell({
    super.key,
    required this.persistence,
    this.onAppSettingsChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _activeTabIndex = 0;

  late StoredGameSettings _settings;
  late UserProgression _progression;
  late Map<String, CharacterMastery> _masteryMap;

  final GlobalKey<ArenaScreenState> _arenaKey = GlobalKey<ArenaScreenState>();
  final GlobalKey<DashboardScreenState> _dashboardKey =
      GlobalKey<DashboardScreenState>();
  final GlobalKey<ChartScreenState> _chartKey = GlobalKey<ChartScreenState>();
  final GlobalKey<StatsScreenState> _statsKey = GlobalKey<StatsScreenState>();
  final GlobalKey<SettingsScreenState> _settingsKey =
      GlobalKey<SettingsScreenState>();

  @override
  void initState() {
    super.initState();
    _reloadPersistentState();
  }

  void _reloadPersistentState() {
    setState(() {
      _settings = widget.persistence.loadGameSettings();
      _progression = widget.persistence.loadUserProgression();
      _masteryMap = widget.persistence.loadMasteryMap();
      AppColors.applyTheme(_settings.themeMode);
    });
  }

  void _onDataChanged() {
    _reloadPersistentState();
    _arenaKey.currentState?.refreshData();
    _dashboardKey.currentState?.refreshData();
    _chartKey.currentState?.refreshData();
    _statsKey.currentState?.refreshData();
    _settingsKey.currentState?.refreshData();
    widget.onAppSettingsChanged?.call();
  }

  void _navigateToTab(int tabIndex) {
    setState(() {
      _activeTabIndex = tabIndex.clamp(0, 4);
    });
  }

  void _toggleSound() {
    final next = _settings.copyWith(soundEnabled: !_settings.soundEnabled);
    setState(() {
      _settings = next;
    });
    widget.persistence.saveGameSettings(next);
    _arenaKey.currentState?.refreshData();
    _settingsKey.currentState?.refreshData();
  }

  void _toggleVoice() {
    final next = _settings.copyWith(voiceEnabled: !_settings.voiceEnabled);
    setState(() {
      _settings = next;
    });
    widget.persistence.saveGameSettings(next);
    _arenaKey.currentState?.refreshData();
    _settingsKey.currentState?.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final isPlatformDark =
        MediaQuery.maybePlatformBrightnessOf(context) == Brightness.dark;
    AppColors.applyTheme(_settings.themeMode, isPlatformDark: isPlatformDark);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: AppColors.isLight ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: AppColors.isLight ? Brightness.dark : Brightness.light,
      ),
    );

    final analysis = analyzeKanaPerformance(_masteryMap);
    final achievements = getAchievementProgressList(_progression, _masteryMap);
    final unlockedAchievementsCount =
        achievements.where((a) => a.isUnlocked).length;

    return Scaffold(
      appBar: AppNavbar(
        level: _progression.level,
        totalAchievements: achievementDefinitions.length,
        unlockedAchievements: unlockedAchievementsCount,
        soundEnabled: _settings.soundEnabled,
        voiceEnabled: _settings.voiceEnabled,
        onToggleSound: _toggleSound,
        onToggleVoice: _toggleVoice,
        onOpenSettings: () => _navigateToTab(4),
        isSettingsActive: _activeTabIndex == 4,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _activeTabIndex,
          children: [
            ArenaScreen(
              key: _arenaKey,
              persistence: widget.persistence,
              onDataChanged: _onDataChanged,
              onNavigateTab: _navigateToTab,
            ),
            DashboardScreen(
              key: _dashboardKey,
              persistence: widget.persistence,
              onDataChanged: _onDataChanged,
              onNavigateTab: _navigateToTab,
            ),
            ChartScreen(
              key: _chartKey,
              persistence: widget.persistence,
              onDataChanged: _onDataChanged,
              onNavigateTab: _navigateToTab,
            ),
            StatsScreen(
              key: _statsKey,
              persistence: widget.persistence,
              onDataChanged: _onDataChanged,
              onNavigateTab: _navigateToTab,
            ),
            SettingsScreen(
              key: _settingsKey,
              persistence: widget.persistence,
              onDataChanged: _onDataChanged,
              onNavigateTab: _navigateToTab,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _activeTabIndex,
        onTabSelected: _navigateToTab,
        weakCount: analysis.weakItems.length,
        masteredCount: analysis.strongItems.length,
        totalKanaCount: kanaItems.length,
        unlockedAchievements: unlockedAchievementsCount,
      ),
    );
  }
}
