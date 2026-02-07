// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voish_app/main.dart';

void main() {
  testWidgets('Voish app launch smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: VoishApp()));

    // Verify that the Splash Screen appears.
    // The splash screen has "Voish" text.
    expect(find.text('Voish'), findsOneWidget);
    expect(find.text('The Voice-First Super-App'), findsOneWidget);

    // Pump to advance time for the Splash Screen delay (3 seconds).
    // This resolves the pending timer assertion and triggers navigation.
    await tester.pump(const Duration(seconds: 3));
    // Pump again to settle the navigation transition (800ms fade).
    await tester.pumpAndSettle();

    // Verify we are now on the Onboarding Screen
    // Onboarding has "Welcome" text.
    expect(find.text('Welcome'), findsOneWidget);
  });
}
