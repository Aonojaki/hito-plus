import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_repositories.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('vision board adds text card and persists updates', (
    WidgetTester tester,
  ) async {
    final fakes = FakeRepositoriesBundle();
    await pumpCalculatedLifeApp(tester, fakes: fakes);

    await tester.tap(find.text('vision board'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Text Card'));
    await tester.pumpAndSettle();

    expect(fakes.visionBoardRepository.itemsSnapshot.length, 1);
    final textEditor = find.byType(TextFormField);
    await tester.enterText(textEditor, 'Dream house');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    final after = fakes.visionBoardRepository.itemsSnapshot.single;
    expect(after.text, 'Dream house');
    expect(fakes.visionBoardRepository.upsertCount, greaterThan(0));
  });
}
