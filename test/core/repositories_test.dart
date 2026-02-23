import 'package:calculated_life/core/db/app_database.dart';
import 'package:calculated_life/core/models/entities.dart';
import 'package:calculated_life/core/repositories/drift_repositories.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase database;
  late NotebookDriftRepository notebookRepository;
  late SettingsDriftRepository settingsRepository;
  late AiChatDriftRepository aiChatRepository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    notebookRepository = NotebookDriftRepository(database, const Uuid());
    settingsRepository = SettingsDriftRepository(database);
    aiChatRepository = AiChatDriftRepository(database, const Uuid());
  });

  tearDown(() async {
    await database.close();
  });

  test('createNotebook creates notebook with first page', () async {
    final notebook = await notebookRepository.createNotebook(title: 'Diary');

    final notebooks = await notebookRepository.watchNotebooks().first;
    final pages = await notebookRepository.watchPages(notebook.id).first;

    expect(notebooks.length, 1);
    expect(notebooks.first.id, notebook.id);
    expect(pages.length, 1);
    expect(pages.first.orderIndex, 0);
  });

  test('reorderPages updates order indexes', () async {
    final notebook = await notebookRepository.createNotebook(
      title: 'Work Notes',
    );
    final initialPages = await notebookRepository.watchPages(notebook.id).first;
    final firstPage = initialPages.first;
    final page2 = await notebookRepository.addPage(notebook.id);
    final page3 = await notebookRepository.addPage(notebook.id);

    await notebookRepository.reorderPages(notebook.id, [
      page3.id,
      page2.id,
      firstPage.id,
    ]);

    final pages = await notebookRepository.watchPages(notebook.id).first;

    expect(pages.length, 3);
    expect(pages[0].id, page3.id);
    expect(pages[1].id, page2.id);
    expect(pages[2].id, firstPage.id);
  });

  test('updateSettings rejects future birth date', () async {
    await expectLater(
      () => settingsRepository.updateSettings(
        AppSettings(
          birthDate: DateTime.now().add(const Duration(days: 4)),
          lifespanYears: 80,
          yearDotRows: 4,
          notebookAiAccessEnabled: false,
        ),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('updatePageStyle persists preset and font size', () async {
    final notebook = await notebookRepository.createNotebook(title: 'Diary');
    final page = (await notebookRepository.watchPages(notebook.id).first).first;

    await notebookRepository.updatePageStyle(
      page.id,
      EditorFontPreset.script,
      22,
    );

    final updated = (await notebookRepository.watchPages(notebook.id).first)
        .firstWhere((item) => item.id == page.id);

    expect(updated.fontPreset, EditorFontPreset.script);
    expect(updated.fontSize, 22);
  });

  test('ai chat session/message CRUD and settings update works', () async {
    final session = await aiChatRepository.createSession(title: 'Plan');

    await aiChatRepository.addMessage(
      AiChatMessage(
        id: const Uuid().v4(),
        sessionId: session.id,
        role: AiRole.user,
        content: 'hello',
        createdAt: DateTime.now(),
      ),
    );

    final messages = await aiChatRepository.watchMessages(session.id).first;
    expect(messages.length, 1);
    expect(messages.first.content, 'hello');

    final defaults = await aiChatRepository.getAiSettings();
    expect(defaults.selectedModel, 'gpt-4.1-mini');
    expect(defaults.notebookContextEnabled, isFalse);

    await aiChatRepository.updateAiSettings(
      defaults.copyWith(selectedModel: 'gpt-4.1', notebookContextEnabled: true),
    );

    final updated = await aiChatRepository.getAiSettings();
    expect(updated.selectedModel, 'gpt-4.1');
    expect(updated.notebookContextEnabled, isTrue);

    await aiChatRepository.deleteSession(session.id);
    final sessions = await aiChatRepository.watchSessions().first;
    expect(sessions, isEmpty);
  });
}
