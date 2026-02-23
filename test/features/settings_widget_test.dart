import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_repositories.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('settings connects and disconnects API key', (
    WidgetTester tester,
  ) async {
    final fakes = FakeRepositoriesBundle();
    await pumpCalculatedLifeApp(tester, fakes: fakes);

    await tester.tap(find.text('settings'));
    await tester.pumpAndSettle();

    final keyField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'OpenAI API key',
    );

    await tester.enterText(keyField, 'abc123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Connect Key'));
    await tester.pumpAndSettle();

    expect(find.text('Status: connected'), findsOneWidget);
    expect(fakes.secretStore.key, 'abc123');

    await tester.tap(find.widgetWithText(OutlinedButton, 'Disconnect'));
    await tester.pumpAndSettle();

    expect(find.text('Status: not connected'), findsOneWidget);
    expect(fakes.secretStore.key, isNull);
  });
}
