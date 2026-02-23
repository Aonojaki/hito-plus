import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_repositories.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('scrapper text is cleared after leaving the tab', (
    WidgetTester tester,
  ) async {
    final fakes = FakeRepositoriesBundle();
    await pumpCalculatedLifeApp(tester, fakes: fakes);

    await tester.tap(find.text('scrapper'));
    await tester.pumpAndSettle();

    final scrapperField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText ==
              'Vent freely here. This will not be stored.',
    );

    await tester.enterText(scrapperField, 'stress dump text');
    await tester.pumpAndSettle();
    expect(find.text('stress dump text'), findsOneWidget);

    await tester.tap(find.text('cal'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('scrapper'));
    await tester.pumpAndSettle();

    expect(find.text('stress dump text'), findsNothing);
  });
}
