import 'dart:async';

import 'package:calculated_life/core/models/entities.dart';
import 'package:calculated_life/core/repositories/interfaces.dart';
import 'package:calculated_life/core/services/image_storage_service.dart';
import 'package:calculated_life/core/services/openai_client.dart';
import 'package:calculated_life/core/services/secret_store.dart';

class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository(AppSettings initial) : _settings = initial;

  AppSettings _settings;

  AppSettings get current => _settings;

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Future<void> updateSettings(AppSettings settings) async {
    _settings = settings;
  }
}

class FakeNotebookRepository implements NotebookRepository {
  final List<Notebook> _notebooks = [];
  final Map<String, List<NotebookPage>> _pagesByNotebook = {};

  final StreamController<List<Notebook>> _notebooksController =
      StreamController<List<Notebook>>.broadcast();
  final Map<String, StreamController<List<NotebookPage>>> _pagesControllers =
      {};

  int _idCounter = 0;
  bool shuffleCalled = false;
  bool reorderCalled = false;

  List<Notebook> get notebooksSnapshot => List.unmodifiable(_sortedNotebooks());

  List<NotebookPage> pagesSnapshot(String notebookId) {
    return List.unmodifiable(_sortedPages(notebookId));
  }

  String _nextId(String prefix) {
    _idCounter += 1;
    return '$prefix-$_idCounter';
  }

  List<Notebook> _sortedNotebooks() {
    final copy = [..._notebooks];
    copy.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return copy;
  }

  List<NotebookPage> _sortedPages(String notebookId) {
    final copy = [...(_pagesByNotebook[notebookId] ?? const <NotebookPage>[])];
    copy.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return copy;
  }

  StreamController<List<NotebookPage>> _pagesController(String notebookId) {
    return _pagesControllers.putIfAbsent(
      notebookId,
      () => StreamController<List<NotebookPage>>.broadcast(),
    );
  }

  void _emitNotebooks() {
    _notebooksController.add(_sortedNotebooks());
  }

  void _emitPages(String notebookId) {
    _pagesController(notebookId).add(_sortedPages(notebookId));
  }

  @override
  Stream<List<Notebook>> watchNotebooks() async* {
    yield _sortedNotebooks();
    yield* _notebooksController.stream;
  }

  @override
  Future<Notebook> createNotebook({
    required String title,
    String? subtitle,
  }) async {
    final notebook = Notebook(
      id: _nextId('notebook'),
      title: title.trim(),
      subtitle: subtitle?.trim().isEmpty ?? true ? null : subtitle?.trim(),
      createdAt: DateTime.now().add(Duration(milliseconds: _idCounter)),
    );

    _notebooks.add(notebook);
    _pagesByNotebook[notebook.id] = [
      NotebookPage(
        id: _nextId('page'),
        notebookId: notebook.id,
        orderIndex: 0,
        content: '',
        fontPreset: EditorFontPreset.classic,
        fontSize: 16,
      ),
    ];

    _emitNotebooks();
    _emitPages(notebook.id);
    return notebook;
  }

  @override
  Future<void> updateNotebook(Notebook notebook) async {
    final index = _notebooks.indexWhere((n) => n.id == notebook.id);
    if (index >= 0) {
      _notebooks[index] = notebook;
      _emitNotebooks();
    }
  }

  @override
  Future<void> deleteNotebook(String notebookId) async {
    _notebooks.removeWhere((n) => n.id == notebookId);
    _pagesByNotebook.remove(notebookId);
    _emitNotebooks();
    _pagesControllers.remove(notebookId)?.close();
  }

  @override
  Stream<List<NotebookPage>> watchPages(String notebookId) async* {
    yield _sortedPages(notebookId);
    yield* _pagesController(notebookId).stream;
  }

  @override
  Future<NotebookPage> addPage(String notebookId) async {
    final existing = _sortedPages(notebookId);
    final page = NotebookPage(
      id: _nextId('page'),
      notebookId: notebookId,
      orderIndex: existing.length,
      content: '',
      fontPreset: EditorFontPreset.classic,
      fontSize: 16,
    );
    _pagesByNotebook.putIfAbsent(notebookId, () => []);
    _pagesByNotebook[notebookId]!.add(page);
    _emitPages(notebookId);
    return page;
  }

  @override
  Future<void> updatePageContent(String pageId, String content) async {
    for (final entry in _pagesByNotebook.entries) {
      final index = entry.value.indexWhere((p) => p.id == pageId);
      if (index >= 0) {
        entry.value[index] = entry.value[index].copyWith(content: content);
        _emitPages(entry.key);
        return;
      }
    }
  }

  @override
  Future<void> updatePageStyle(
    String pageId,
    EditorFontPreset preset,
    double fontSize,
  ) async {
    for (final entry in _pagesByNotebook.entries) {
      final index = entry.value.indexWhere((p) => p.id == pageId);
      if (index >= 0) {
        entry.value[index] = entry.value[index].copyWith(
          fontPreset: preset,
          fontSize: fontSize.clamp(12, 30).toDouble(),
        );
        _emitPages(entry.key);
        return;
      }
    }
  }

  @override
  Future<void> deletePage(String pageId) async {
    for (final entry in _pagesByNotebook.entries) {
      final beforeLength = entry.value.length;
      entry.value.removeWhere((p) => p.id == pageId);
      if (entry.value.length != beforeLength) {
        final normalized = [
          for (var i = 0; i < entry.value.length; i++)
            entry.value[i].copyWith(orderIndex: i),
        ];
        _pagesByNotebook[entry.key] = normalized;
        _emitPages(entry.key);
        return;
      }
    }
  }

  @override
  Future<void> reorderPages(
    String notebookId,
    List<String> orderedPageIds,
  ) async {
    reorderCalled = true;

    final current = _sortedPages(notebookId);
    final byId = {for (final page in current) page.id: page};
    final used = <String>{};
    final reordered = <NotebookPage>[];

    for (final id in orderedPageIds) {
      final page = byId[id];
      if (page != null) {
        reordered.add(page.copyWith(orderIndex: reordered.length));
        used.add(id);
      }
    }

    for (final page in current) {
      if (!used.contains(page.id)) {
        reordered.add(page.copyWith(orderIndex: reordered.length));
      }
    }

    _pagesByNotebook[notebookId] = reordered;
    _emitPages(notebookId);
  }

  @override
  Future<void> shufflePages(String notebookId) async {
    shuffleCalled = true;
    final current = _sortedPages(notebookId);
    if (current.length <= 1) {
      return;
    }
    await reorderPages(
      notebookId,
      current.reversed.map((page) => page.id).toList(growable: false),
    );
  }

  Future<void> dispose() async {
    await _notebooksController.close();
    for (final controller in _pagesControllers.values) {
      await controller.close();
    }
  }
}

class FakeVisionBoardRepository implements VisionBoardRepository {
  final List<VisionBoardItem> _items = [];
  final StreamController<List<VisionBoardItem>> _controller =
      StreamController<List<VisionBoardItem>>.broadcast();

  int _idCounter = 0;
  int upsertCount = 0;

  List<VisionBoardItem> get itemsSnapshot => List.unmodifiable(_items);

  String _nextId() {
    _idCounter += 1;
    return 'vision-$_idCounter';
  }

  void _emit() {
    _controller.add(List.unmodifiable(_items));
  }

  @override
  Stream<List<VisionBoardItem>> watchItems() async* {
    yield List.unmodifiable(_items);
    yield* _controller.stream;
  }

  @override
  Future<VisionBoardItem> addTextItem() async {
    final item = VisionBoardItem(
      id: _nextId(),
      type: VisionItemType.text,
      x: 80,
      y: 80,
      width: 220,
      height: 160,
      text: 'Write your dream...',
      imagePath: null,
    );
    _items.add(item);
    _emit();
    return item;
  }

  @override
  Future<VisionBoardItem> addImageItem(String imagePath) async {
    final item = VisionBoardItem(
      id: _nextId(),
      type: VisionItemType.image,
      x: 120,
      y: 120,
      width: 260,
      height: 200,
      text: null,
      imagePath: imagePath,
    );
    _items.add(item);
    _emit();
    return item;
  }

  @override
  Future<void> upsertItem(VisionBoardItem item) async {
    upsertCount += 1;
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index >= 0) {
      _items[index] = item;
    } else {
      _items.add(item);
    }
    _emit();
  }

  @override
  Future<void> deleteItem(String itemId) async {
    _items.removeWhere((item) => item.id == itemId);
    _emit();
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}

class FakePlannerRepository implements PlannerRepository {
  final List<Goal> _goals = [];
  final Map<String, List<TaskItem>> _tasksByGoal = {};

  final StreamController<List<Goal>> _goalsController =
      StreamController<List<Goal>>.broadcast();
  final Map<String, StreamController<List<TaskItem>>> _taskControllers = {};

  int _idCounter = 0;

  String _nextId(String prefix) {
    _idCounter += 1;
    return '$prefix-$_idCounter';
  }

  List<Goal> _sortedGoals() {
    final copy = [..._goals];
    copy.sort((a, b) {
      final aDate = a.targetDate;
      final bDate = b.targetDate;
      if (aDate == null && bDate == null) {
        return a.title.compareTo(b.title);
      }
      if (aDate == null) {
        return 1;
      }
      if (bDate == null) {
        return -1;
      }
      final dateCompare = aDate.compareTo(bDate);
      if (dateCompare != 0) {
        return dateCompare;
      }
      return a.title.compareTo(b.title);
    });
    return copy;
  }

  List<TaskItem> _sortedTasks(String goalId) {
    final copy = [...(_tasksByGoal[goalId] ?? const <TaskItem>[])];
    copy.sort((a, b) {
      final aDate = a.dueDate;
      final bDate = b.dueDate;
      if (aDate == null && bDate == null) {
        return a.title.compareTo(b.title);
      }
      if (aDate == null) {
        return 1;
      }
      if (bDate == null) {
        return -1;
      }
      final dateCompare = aDate.compareTo(bDate);
      if (dateCompare != 0) {
        return dateCompare;
      }
      return a.title.compareTo(b.title);
    });
    return copy;
  }

  StreamController<List<TaskItem>> _taskController(String goalId) {
    return _taskControllers.putIfAbsent(
      goalId,
      () => StreamController<List<TaskItem>>.broadcast(),
    );
  }

  void _emitGoals() {
    _goalsController.add(_sortedGoals());
  }

  void _emitTasks(String goalId) {
    _taskController(goalId).add(_sortedTasks(goalId));
  }

  @override
  Stream<List<Goal>> watchGoals() async* {
    yield _sortedGoals();
    yield* _goalsController.stream;
  }

  @override
  Future<Goal> createGoal({
    required String title,
    required String description,
    required DateTime? targetDate,
    required GoalStatus status,
  }) async {
    final goal = Goal(
      id: _nextId('goal'),
      title: title.trim(),
      description: description.trim(),
      targetDate: targetDate,
      status: status,
    );

    _goals.add(goal);
    _tasksByGoal.putIfAbsent(goal.id, () => []);
    _emitGoals();
    _emitTasks(goal.id);
    return goal;
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    final index = _goals.indexWhere((item) => item.id == goal.id);
    if (index >= 0) {
      _goals[index] = goal;
      _emitGoals();
    }
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    _goals.removeWhere((goal) => goal.id == goalId);
    _tasksByGoal.remove(goalId);
    _emitGoals();
    await _taskControllers.remove(goalId)?.close();
  }

  @override
  Stream<List<TaskItem>> watchTasks(String goalId) async* {
    yield _sortedTasks(goalId);
    yield* _taskController(goalId).stream;
  }

  @override
  Future<TaskItem> createTask({
    required String goalId,
    required String title,
    required DateTime? dueDate,
    required TaskStatus status,
  }) async {
    final task = TaskItem(
      id: _nextId('task'),
      goalId: goalId,
      title: title.trim(),
      dueDate: dueDate,
      status: status,
    );

    _tasksByGoal.putIfAbsent(goalId, () => []);
    _tasksByGoal[goalId]!.add(task);
    _emitTasks(goalId);
    return task;
  }

  @override
  Future<void> updateTask(TaskItem task) async {
    final tasks = _tasksByGoal[task.goalId];
    if (tasks == null) {
      return;
    }

    final index = tasks.indexWhere((item) => item.id == task.id);
    if (index >= 0) {
      tasks[index] = task;
      _emitTasks(task.goalId);
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    for (final entry in _tasksByGoal.entries) {
      final before = entry.value.length;
      entry.value.removeWhere((task) => task.id == taskId);
      if (entry.value.length != before) {
        _emitTasks(entry.key);
        return;
      }
    }
  }

  Future<void> dispose() async {
    await _goalsController.close();
    for (final controller in _taskControllers.values) {
      await controller.close();
    }
  }
}

class FakeImageStorageService extends ImageStorageService {
  FakeImageStorageService();

  @override
  Future<String> copyImageToAppData(String originalPath) async {
    return originalPath;
  }
}

class FakeAiChatRepository implements AiChatRepository {
  final List<AiChatSession> _sessions = [];
  final Map<String, List<AiChatMessage>> _messagesBySession = {};

  final StreamController<List<AiChatSession>> _sessionsController =
      StreamController<List<AiChatSession>>.broadcast();
  final Map<String, StreamController<List<AiChatMessage>>> _messageControllers =
      {};

  int _idCounter = 0;
  AiSettings _settings = const AiSettings(
    selectedModel: 'gpt-4.1-mini',
    notebookContextEnabled: false,
    enableAssistantActions: true,
  );

  String _nextId(String prefix) {
    _idCounter += 1;
    return '$prefix-$_idCounter';
  }

  List<AiChatSession> _sortedSessions() {
    final copy = [..._sessions];
    copy.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return copy;
  }

  List<AiChatMessage> _sortedMessages(String sessionId) {
    final copy = [
      ...(_messagesBySession[sessionId] ?? const <AiChatMessage>[]),
    ];
    copy.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return copy;
  }

  List<AiChatSession> get sessionsSnapshot =>
      List.unmodifiable(_sortedSessions());

  List<AiChatMessage> messagesSnapshot(String sessionId) {
    return List.unmodifiable(_sortedMessages(sessionId));
  }

  StreamController<List<AiChatMessage>> _messageController(String sessionId) {
    return _messageControllers.putIfAbsent(
      sessionId,
      () => StreamController<List<AiChatMessage>>.broadcast(),
    );
  }

  void _emitSessions() {
    _sessionsController.add(_sortedSessions());
  }

  void _emitMessages(String sessionId) {
    _messageController(sessionId).add(_sortedMessages(sessionId));
  }

  @override
  Stream<List<AiChatSession>> watchSessions() async* {
    yield _sortedSessions();
    yield* _sessionsController.stream;
  }

  @override
  Stream<List<AiChatMessage>> watchMessages(String sessionId) async* {
    yield _sortedMessages(sessionId);
    yield* _messageController(sessionId).stream;
  }

  @override
  Future<AiChatSession> createSession({String? title}) async {
    final session = AiChatSession(
      id: _nextId('session'),
      createdAt: DateTime.now().add(Duration(milliseconds: _idCounter)),
      title: title == null || title.trim().isEmpty ? 'Chat' : title.trim(),
    );
    _sessions.add(session);
    _messagesBySession.putIfAbsent(session.id, () => []);
    _emitSessions();
    _emitMessages(session.id);
    return session;
  }

  @override
  Future<void> addMessage(AiChatMessage message) async {
    _messagesBySession.putIfAbsent(message.sessionId, () => []);
    _messagesBySession[message.sessionId]!.add(message);
    _emitMessages(message.sessionId);
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    _sessions.removeWhere((session) => session.id == sessionId);
    _messagesBySession.remove(sessionId);
    _emitSessions();
    await _messageControllers.remove(sessionId)?.close();
  }

  @override
  Future<AiSettings> getAiSettings() async => _settings;

  @override
  Future<void> updateAiSettings(AiSettings settings) async {
    _settings = settings;
  }

  Future<void> dispose() async {
    await _sessionsController.close();
    for (final controller in _messageControllers.values) {
      await controller.close();
    }
  }
}

class FakeSecretStore implements SecretStore {
  String? key;

  @override
  Future<void> deleteOpenAiApiKey() async {
    key = null;
  }

  @override
  Future<String?> readOpenAiApiKey() async {
    return key;
  }

  @override
  Future<void> saveOpenAiApiKey(String value) async {
    key = value;
  }
}

class FakeAiClient implements AiClient {
  String responseText = 'Hello from fake AI.';
  AssistantActionProposal? action;

  @override
  Future<AiResponse> send({
    required String apiKey,
    required AiRequest request,
  }) async {
    return AiResponse(text: responseText, action: action);
  }
}

class FakeRepositoriesBundle {
  FakeRepositoriesBundle({AppSettings? initialSettings})
    : settingsRepository = FakeSettingsRepository(
        initialSettings ??
            AppSettings(
              birthDate: DateTime(2000, 1, 1),
              lifespanYears: 2,
              yearDotRows: 4,
              notebookAiAccessEnabled: false,
            ),
      );

  final FakeSettingsRepository settingsRepository;
  final FakeNotebookRepository notebookRepository = FakeNotebookRepository();
  final FakeVisionBoardRepository visionBoardRepository =
      FakeVisionBoardRepository();
  final FakePlannerRepository plannerRepository = FakePlannerRepository();
  final FakeAiChatRepository aiChatRepository = FakeAiChatRepository();
  final FakeSecretStore secretStore = FakeSecretStore();
  final FakeAiClient aiClient = FakeAiClient();
  final FakeImageStorageService imageStorageService = FakeImageStorageService();

  Future<void> dispose() async {
    await notebookRepository.dispose();
    await visionBoardRepository.dispose();
    await plannerRepository.dispose();
    await aiChatRepository.dispose();
  }
}
