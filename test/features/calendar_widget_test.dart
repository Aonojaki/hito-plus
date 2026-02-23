import 'package:calculated_life/core/models/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_repositories.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('calendar updates lifespan and saves settings', (
    WidgetTester tester,
  ) async {
    final fakes = FakeRepositoriesBundle(
      initialSettings: AppSettings(
        birthDate: DateTime(2000, 1, 1),
        lifespanYears: 5,
        yearDotRows: 4,
        notebookAiAccessEnabled: false,
      ),
    );

    await pumpCalculatedLifeApp(tester, fakes: fakes);

    expect(find.text('End: 31 Dec 2004'), findsOneWidget);

    final lifespanField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Lifespan Years',
    );

    await tester.enterText(lifespanField, '1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(fakes.settingsRepository.current.lifespanYears, 1);
    expect(find.text('End: 31 Dec 2000'), findsOneWidget);
  });

  testWidgets('calendar reflects settings-driven year row count', (
    WidgetTester tester,
  ) async {
    final fakes = FakeRepositoriesBundle(
      initialSettings: AppSettings(
        birthDate: DateTime(2000, 1, 1),
        lifespanYears: 5,
        yearDotRows: 6,
        notebookAiAccessEnabled: false,
      ),
    );

    await pumpCalculatedLifeApp(tester, fakes: fakes);

    expect(find.text('Rows/Year: 6'), findsOneWidget);
  });
}
