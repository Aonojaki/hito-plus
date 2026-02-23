import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculated_life/core/models/entities.dart';

import '../support/fake_repositories.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('notebook flow creates notebook, adds page, and shuffles', (
    WidgetTester tester,
  ) async {
    final fakes = FakeRepositoriesBundle();
    await pumpCalculatedLifeApp(tester, fakes: fakes);

    await tester.tap(find.text('notebook'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'New Notebook'));
    await tester.pumpAndSettle();

    final dialog = find.byType(AlertDialog);
    final titleField = find
        .descendant(of: dialog, matching: find.byType(TextField))
        .first;
    await tester.enterText(titleField, 'Diary One');
    await tester.tap(
      find.descendant(
        of: dialog,
        matching: find.widgetWithText(ElevatedButton, 'Create'),
      ),
    );
    await tester.pumpAndSettle();

    expect(fakes.notebookRepository.notebooksSnapshot.length, 1);
    final notebookId = fakes.notebookRepository.notebooksSnapshot.first.id;
    expect(fakes.notebookRepository.pagesSnapshot(notebookId).length, 1);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Page'));
    await tester.pumpAndSettle();

    expect(fakes.notebookRepository.pagesSnapshot(notebookId).length, 2);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Shuffle'));
    await tester.pumpAndSettle();

    expect(fakes.notebookRepository.shuffleCalled, isTrue);
  });

  testWidgets('notebook stacks panels on narrow width and persists style', (
    WidgetTester tester,
  ) async {
    final fakes = FakeRepositoriesBundle();
    await pumpCalculatedLifeApp(
      tester,
      fakes: fakes,
      windowSize: const Size(1000, 900),
    );

    await tester.tap(find.text('notebook'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(OutlinedButton, 'Panels'), findsOneWidget);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Panels'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'New Notebook'));
    await tester.pumpAndSettle();

    final dialog = find.byType(AlertDialog);
    final titleField = find
        .descendant(of: dialog, matching: find.byType(TextField))
        .first;
    await tester.enterText(titleField, 'Style Test');
    await tester.tap(
      find.descendant(
        of: dialog,
        matching: find.widgetWithText(ElevatedButton, 'Create'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(16, 16));
    await tester.pumpAndSettle();

    expect(find.text('Calligraphy'), findsOneWidget);
    await tester.tap(find.text('Classic'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Script').last);
    await tester.pumpAndSettle();

    final notebookId = fakes.notebookRepository.notebooksSnapshot.first.id;
    final page = fakes.notebookRepository.pagesSnapshot(notebookId).first;
    expect(page.fontPreset, EditorFontPreset.script);
  });
}
