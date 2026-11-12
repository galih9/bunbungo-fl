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

    // Verify Brand title is rendered
    expect(find.text('Bun Bun Go'), findsOneWidget);

    // Verify Arena screen components
    expect(find.text('SCRIPT SELECTION'), findsOneWidget);
    expect(find.text('PRACTICE ROWS'), findsOneWidget);

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
  });
}
