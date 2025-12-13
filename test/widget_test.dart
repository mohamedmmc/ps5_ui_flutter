// This is a basic Flutter widget test for PS5 UI Replica.

import 'package:flutter_test/flutter_test.dart';

import 'package:ps5_ui_flutter/main.dart';

void main() {
  testWidgets('PS5 UI App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PS5UIApp());

    // Verify that the intro screen appears initially
    expect(find.text('Press the PS button on your controller.'), findsOneWidget);
  });
}
