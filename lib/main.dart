import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/achievements_data.dart';
import 'data/kana_data.dart';
import 'models/game_settings.dart';
import 'providers/app_providers.dart';
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

  runApp(
    ProviderScope(
      overrides: [
        persistenceProvider.overrideWithValue(persistence),
      ],
      child: BunBunGoFlutterApp(persistence: persistence),
    ),
  );
}

class BunBunGoFlutterApp extends StatelessWidget {
  final PersistenceService persistence;

  const BunBunGoFlutterApp({super.key, required this.persistence});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        persistenceProvider.overrideWithValue(persistence),
      ],
      child: _BunBunGoAppRoot(persistence: persistence),
    );
  }
}

class _BunBunGoAppRoot extends ConsumerWidget {
  final PersistenceService persistence;

  const _BunBunGoAppRoot({required this.persistence});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(gameSettingsProvider);
    final isPlatformDark =
        MediaQuery.maybePlatformBrightnessOf(context) == Brightness.dark;
    AppColors.applyTheme(settings.themeMode, isPlatformDark: isPlatformDark);
    final isOled = settings.themeMode == AppThemeMode.oled;

    final isLightMode = settings.themeMode == AppThemeMode.light ||
        settings.themeMode == AppThemeMode.lightMinimal;

    return MaterialApp(
      title: 'BunBunGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        settings.themeMode == AppThemeMode.lightMinimal
            ? AppThemeMode.lightMinimal
            : AppThemeMode.light,
        accent: settings.accentColor,
        isPlatformDark: false,
      ),
      darkTheme: AppTheme.getTheme(
        settings.themeMode == AppThemeMode.darkMinimal
            ? AppThemeMode.darkMinimal
            : (isOled ? AppThemeMode.oled : AppThemeMode.dark),
        accent: settings.accentColor,
        isPlatformDark: true,
      ),
      themeMode: isLightMode
          ? ThemeMode.light
          : (settings.themeMode == AppThemeMode.system ? ThemeMode.system : ThemeMode.dark),
      home: MainShell(
        persistence: persistence,
      ),
    );
  }
}

class MainShell extends ConsumerStatefulWidget {
  final PersistenceService persistence;
  final VoidCallback? onAppSettingsChanged;

  const MainShell({
    super.key,
    required this.persistence,
    this.onAppSettingsChanged,
  });

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ArenaScreenState> _arenaKey = GlobalKey<ArenaScreenState>();
  final GlobalKey<DashboardScreenState> _dashboardKey =
      GlobalKey<DashboardScreenState>();
  final GlobalKey<ChartScreenState> _chartKey = GlobalKey<ChartScreenState>();
  final GlobalKey<StatsScreenState> _statsKey = GlobalKey<StatsScreenState>();
  final GlobalKey<SettingsScreenState> _settingsKey =
      GlobalKey<SettingsScreenState>();

  late final AnimationController _tabTransitionController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  int _lastTab = 0;

  @override
  void initState() {
    super.initState();
    _tabTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _tabTransitionController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.02),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _tabTransitionController,
      curve: Curves.easeOutCubic,
    ));
    _tabTransitionController.value = 1.0;
  }

  @override
  void dispose() {
    _tabTransitionController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    _arenaKey.currentState?.refreshData();
    _dashboardKey.currentState?.refreshData();
    _chartKey.currentState?.refreshData();
    _statsKey.currentState?.refreshData();
    _settingsKey.currentState?.refreshData();
    widget.onAppSettingsChanged?.call();
  }

  void _navigateToTab(int tabIndex) {
    ref.read(activeTabProvider.notifier).state = tabIndex.clamp(0, 4);
  }

  @override
  Widget build(BuildContext context) {
    final activeTabIndex = ref.watch(activeTabProvider);
    if (activeTabIndex != _lastTab) {
      _lastTab = activeTabIndex;
      _tabTransitionController.forward(from: 0.0);
    }

    final isPracticing = ref.watch(isPracticingSessionProvider);
    final settings = ref.watch(gameSettingsProvider);
    final progression = ref.watch(userProgressionProvider);
    final unlockedAchievementsCount = ref.watch(unlockedAchievementsCountProvider);
    final analysis = ref.watch(kanaPerformanceAnalysisProvider);

    final isPlatformDark =
        MediaQuery.maybePlatformBrightnessOf(context) == Brightness.dark;
    AppColors.applyTheme(settings.themeMode, isPlatformDark: isPlatformDark);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: AppColors.isLight ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: AppColors.isLight ? Brightness.dark : Brightness.light,
      ),
    );

    return Scaffold(
      appBar: AppNavbar(
        level: progression.level,
        totalAchievements: achievementDefinitions.length,
        unlockedAchievements: unlockedAchievementsCount,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: IndexedStack(
              index: activeTabIndex,
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
                  onStartWeakLetters: () {
                    _navigateToTab(0);
                    _arenaKey.currentState?.startWeakLettersSession();
                  },
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
        ),
      ),
      bottomNavigationBar: isPracticing
          ? null
          : AppBottomNav(
              currentIndex: activeTabIndex,
              onTabSelected: _navigateToTab,
              weakCount: analysis.weakItems.length,
              masteredCount: analysis.strongItems.length,
              totalKanaCount: kanaItems.length,
              unlockedAchievements: unlockedAchievementsCount,
            ),
    );
  }
}
