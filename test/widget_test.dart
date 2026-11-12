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
    expect(find.textContaining('Start Bun Bun Go Session'), findsOneWidget);

    // Verify progression banner is NOT in Arena tab
    expect(find.textContaining('XP Progress'), findsNothing);

    // Verify bottom navigation tabs
    expect(find.text('Arena'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Chart'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Tap on Dashboard tab
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('PERFORMANCE DASHBOARD'), findsOneWidget);

    // Verify LobbyProgressionBanner is now inside Dashboard tab
    expect(find.textContaining('XP Progress'), findsOneWidget);

    // Tap on Chart tab
    await tester.tap(find.text('Chart'));
    await tester.pumpAndSettle();
    expect(find.text('SYLLABARY MATRIX'), findsOneWidget);

    // Tap on Stats tab
    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();
    expect(find.text('Codex Analytics'), findsOneWidget);

    // Tap on Settings tab
    await tester.tap(find.text('Settings'));
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
