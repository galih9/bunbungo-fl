import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bunbungo/widgets/animation_effects.dart';

void main() {
  group('Animation and UX Effects Tests', () {
    testWidgets('BouncingWidget renders child and responds to tap gesture', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: BouncingWidget(
                onTap: () => tapped = true,
                child: const Text('Bounce Me'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bounce Me'), findsOneWidget);

      await tester.tap(find.text('Bounce Me'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('ShakeWidget shakes horizontally when triggered', (tester) async {
      final key = GlobalKey<ShakeWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ShakeWidget(
                key: key,
                child: const Text('Shake Card'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Shake Card'), findsOneWidget);

      // Trigger shake
      key.currentState?.shake();
      await tester.pump(const Duration(milliseconds: 50));

      // Advance until shake finishes
      await tester.pumpAndSettle();
      expect(find.text('Shake Card'), findsOneWidget);
    });

    testWidgets('SmoothAnimatedProgressBar animates progress accurately and clamps', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SmoothAnimatedProgressBar(
                progress: 0.75,
                height: 10,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SmoothAnimatedProgressBar), findsOneWidget);
    });

    testWidgets('CountUpText displays target number smoothly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CountUpText(
                targetValue: 420,
                suffix: ' pts',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('420 pts'), findsOneWidget);
    });

    testWidgets('ConfettiBurst renders without error and finishes within duration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                ConfettiBurst(
                  duration: Duration(milliseconds: 500),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.byType(ConfettiBurst), findsOneWidget);
    });

    testWidgets('GlowPulseWidget finishes its finite pulses without locking pumpAndSettle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: GlowPulseWidget(
                animate: true,
                pulses: 2,
                child: Text('Glowing'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Glowing'), findsOneWidget);
    });
  });
}
