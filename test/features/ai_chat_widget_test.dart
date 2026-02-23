import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_repositories.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('ai chat sends message and stores history', (
    WidgetTester tester,
  ) async {
    final fakes = FakeRepositoriesBundle();
    fakes.secretStore.key = 'test-key';
    fakes.aiClient.responseText = 'Plan saved as idea.';

    await pumpCalculatedLifeApp(tester, fakes: fakes);

    await tester.tap(find.text('ai chat'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'New Chat'));
    await tester.pumpAndSettle();

    final inputField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText ==
              'Ask AI to plan, summarize, or reflect...',
    );

    await tester.enterText(inputField, 'Help me plan this week');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Send'));
    await tester.pumpAndSettle();

    expect(find.text('Plan saved as idea.'), findsOneWidget);

    final sessions = fakes.aiChatRepository.sessionsSnapshot;
    expect(sessions.length, 1);
    final messages = fakes.aiChatRepository.messagesSnapshot(sessions.first.id);
    expect(messages.length, 2);
  });
}
