import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_repositories.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('planner stacks secondary panel on narrow width', (
    WidgetTester tester,
  ) async {
    final fakes = FakeRepositoriesBundle();
    await pumpCalculatedLifeApp(
      tester,
      fakes: fakes,
      windowSize: const Size(1000, 900),
    );

    await tester.tap(find.text('planner'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(OutlinedButton, 'Panels'), findsOneWidget);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Panels'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'New Goal'), findsOneWidget);
  });
}
