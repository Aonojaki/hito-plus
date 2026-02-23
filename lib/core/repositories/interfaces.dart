import '../models/entities.dart';

abstract class SettingsRepository {
  Future<AppSettings> getSettings();

  Future<void> updateSettings(AppSettings settings);
}

abstract class NotebookRepository {
  Stream<List<Notebook>> watchNotebooks();

  Future<Notebook> createNotebook({required String title, String? subtitle});

  Future<void> updateNotebook(Notebook notebook);

  Future<void> deleteNotebook(String notebookId);

  Stream<List<NotebookPage>> watchPages(String notebookId);

  Future<NotebookPage> addPage(String notebookId);

  Future<void> updatePageContent(String pageId, String content);

  Future<void> updatePageStyle(
    String pageId,
    EditorFontPreset preset,
    double fontSize,
  );

  Future<void> deletePage(String pageId);

  Future<void> reorderPages(String notebookId, List<String> orderedPageIds);

  Future<void> shufflePages(String notebookId);
}

abstract class VisionBoardRepository {
  Stream<List<VisionBoardItem>> watchItems();

  Future<VisionBoardItem> addTextItem();

  Future<VisionBoardItem> addImageItem(String imagePath);

  Future<void> upsertItem(VisionBoardItem item);

  Future<void> deleteItem(String itemId);
}

abstract class PlannerRepository {
  Stream<List<Goal>> watchGoals();

  Future<Goal> createGoal({
    required String title,
    required String description,
    required DateTime? targetDate,
    required GoalStatus status,
  });

  Future<void> updateGoal(Goal goal);

  Future<void> deleteGoal(String goalId);

  Stream<List<TaskItem>> watchTasks(String goalId);

  Future<TaskItem> createTask({
    required String goalId,
    required String title,
    required DateTime? dueDate,
    required TaskStatus status,
  });

  Future<void> updateTask(TaskItem task);

  Future<void> deleteTask(String taskId);
}

abstract class ScrapperSessionService {
  String get text;

  void setText(String value);

  void clear();
}

abstract class AiChatRepository {
  Stream<List<AiChatSession>> watchSessions();

  Stream<List<AiChatMessage>> watchMessages(String sessionId);

  Future<AiChatSession> createSession({String? title});

  Future<void> addMessage(AiChatMessage message);

  Future<void> deleteSession(String sessionId);

  Future<AiSettings> getAiSettings();

  Future<void> updateAiSettings(AiSettings settings);
}
