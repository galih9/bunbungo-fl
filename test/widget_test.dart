import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bunbungo/main.dart';
import 'package:bunbungo/services/persistence_service.dart';

void main() {
  testWidgets('BunBunGo app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Bun Bun Go',
      packageName: 'com.bunbungo.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
      installerStore: null,
    );
    final persistence = await PersistenceService.getInstance();

    await tester.pumpWidget(BunBunGoFlutterApp(persistence: persistence));
    await tester.pumpAndSettle();

    // Verify Brand title is rendered in AppNavbar
    expect(find.text('Bun Bun Go'), findsOneWidget);

    // Verify SFX and Voice and Settings buttons are removed from AppBar
    expect(find.text('SFX'), findsNothing);
    expect(find.text('Voice'), findsNothing);

    // Verify Arena screen components (clean and minimal)
    expect(find.text('SCRIPT SELECTION'), findsOneWidget);
    expect(find.text('PRACTICE ROWS'), findsOneWidget);
    expect(find.text('Start Practice'), findsOneWidget);

    // Verify progression banner is NOT in Arena tab
    expect(find.textContaining('XP Progress'), findsNothing);

    // Verify bottom navigation tabs (icon only, minimal display)
    expect(find.byIcon(Icons.flash_on_rounded), findsOneWidget);
    expect(find.byIcon(Icons.insights_rounded), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

    // Tap on Dashboard tab
    await tester.tap(find.byIcon(Icons.insights_rounded));
    await tester.pumpAndSettle();
    expect(find.text('PERFORMANCE DASHBOARD'), findsOneWidget);

    // Verify LobbyProgressionBanner is now inside Dashboard tab
    expect(find.textContaining('XP Progress'), findsOneWidget);

    // Tap on Chart tab
    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();
    expect(find.text('SYLLABARY MATRIX'), findsOneWidget);

    // Tap on Stats tab
    await tester.tap(find.byIcon(Icons.emoji_events_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Analytics'), findsOneWidget);

    // Tap on Settings tab
    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();
    expect(find.text('SFX & SOUND EFFECTS'), findsOneWidget);
    expect(find.text('VOICE & PRONUNCIATION'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Save Configuration'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Save Configuration'), findsOneWidget);
  });
}
