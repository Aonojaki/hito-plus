import 'package:flutter_test/flutter_test.dart';

import '../support/fake_repositories.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('left navigation switches between all sections', (
    WidgetTester tester,
  ) async {
    final fakes = FakeRepositoriesBundle();
    await pumpCalculatedLifeApp(tester, fakes: fakes);

    expect(find.text('Lifespan Years'), findsOneWidget);

    await tester.tap(find.text('notebook'));
    await tester.pumpAndSettle();
    expect(find.text('New Notebook'), findsOneWidget);

    await tester.tap(find.text('vision board'));
    await tester.pumpAndSettle();
    expect(find.text('Add Text Card'), findsOneWidget);

    await tester.tap(find.text('planner'));
    await tester.pumpAndSettle();
    expect(find.text('New Goal'), findsOneWidget);

    await tester.tap(find.text('scrapper'));
    await tester.pumpAndSettle();
    expect(find.textContaining('This text is temporary'), findsOneWidget);

    await tester.tap(find.text('ai chat'));
    await tester.pumpAndSettle();
    expect(find.text('New Chat'), findsOneWidget);

    await tester.tap(find.text('settings'));
    await tester.pumpAndSettle();
    expect(find.text('Save Settings'), findsOneWidget);
  });

  testWidgets('back button returns to previous tab', (
    WidgetTester tester,
  ) async {
    final fakes = FakeRepositoriesBundle();
    await pumpCalculatedLifeApp(tester, fakes: fakes);

    await tester.tap(find.text('notebook'));
    await tester.pumpAndSettle();
    expect(find.text('New Notebook'), findsOneWidget);

    await tester.tap(find.text('planner'));
    await tester.pumpAndSettle();
    expect(find.text('New Goal'), findsOneWidget);
    expect(find.textContaining('Back: notebook'), findsOneWidget);

    await tester.tap(find.textContaining('Back: notebook'));
    await tester.pumpAndSettle();
    expect(find.text('New Notebook'), findsOneWidget);
  });
}
