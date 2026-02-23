import 'dart:math';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../date/life_grid_calculator.dart';
import '../models/entities.dart';
import 'interfaces.dart';
import '../db/app_database.dart';

class SettingsDriftRepository implements SettingsRepository {
  SettingsDriftRepository(this._db);

  final AppDatabase _db;

  static const int _settingsId = 1;
  static final DateTime _defaultBirthDate = DateTime(2000, 1, 1);

  @override
  Future<AppSettings> getSettings() async {
    final existing = await (_db.select(
      _db.settingsTable,
    )..where((tbl) => tbl.singletonId.equals(_settingsId))).getSingleOrNull();

    if (existing != null) {
      return AppSettings(
        birthDate: DateTime.fromMillisecondsSinceEpoch(
          existing.birthDateEpochMs,
        ),
        lifespanYears: existing.lifespanYears,
        yearDotRows: existing.yearDotRows,
        notebookAiAccessEnabled: existing.notebookAiAccessEnabled,
      );
    }

    await _db
        .into(_db.settingsTable)
        .insert(
          SettingsTableCompanion.insert(
            singletonId: const Value(_settingsId),
            birthDateEpochMs: _defaultBirthDate.millisecondsSinceEpoch,
            lifespanYears: 80,
            yearDotRows: const Value(4),
            notebookAiAccessEnabled: const Value(false),
          ),
        );

    return AppSettings(
      birthDate: DateTime(2000, 1, 1),
      lifespanYears: 80,
      yearDotRows: 4,
      notebookAiAccessEnabled: false,
    );
  }

  @override
  Future<void> updateSettings(AppSettings settings) async {
    final normalizedBirthDate = normalizeDate(settings.birthDate);
    final today = normalizeDate(DateTime.now());
    if (normalizedBirthDate.isAfter(today)) {
      throw ArgumentError('Birth date cannot be in the future.');
    }
    if (settings.yearDotRows < 2 || settings.yearDotRows > 6) {
      throw ArgumentError('Year dot rows must be between 2 and 6.');
    }

    await _db
        .into(_db.settingsTable)
        .insertOnConflictUpdate(
          SettingsTableCompanion.insert(
            singletonId: const Value(_settingsId),
            birthDateEpochMs: normalizedBirthDate.millisecondsSinceEpoch,
            lifespanYears: settings.lifespanYears,
            yearDotRows: Value(settings.yearDotRows),
            notebookAiAccessEnabled: Value(settings.notebookAiAccessEnabled),
          ),
        );
  }
}

class NotebookDriftRepository implements NotebookRepository {
  NotebookDriftRepository(this._db, this._uuid);

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<Notebook>> watchNotebooks() {
    final query = _db.select(_db.notebooksTable)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAtEpochMs)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => Notebook(
              id: row.id,
              title: row.title,
              subtitle: row.subtitle,
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                row.createdAtEpochMs,
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<Notebook> createNotebook({
    required String title,
    String? subtitle,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    final notebook = Notebook(
      id: id,
      title: title.trim(),
      subtitle: subtitle?.trim().isEmpty ?? true ? null : subtitle?.trim(),
      createdAt: now,
    );

    await _db.transaction(() async {
      await _db
          .into(_db.notebooksTable)
          .insert(
            NotebooksTableCompanion.insert(
              id: notebook.id,
              title: notebook.title,
              subtitle: Value(notebook.subtitle),
              createdAtEpochMs: now.millisecondsSinceEpoch,
            ),
          );
      await _db
          .into(_db.notebookPagesTable)
          .insert(
            NotebookPagesTableCompanion.insert(
              id: _uuid.v4(),
              notebookId: notebook.id,
              orderIndex: 0,
              content: const Value(''),
              fontPreset: const Value('classic'),
              fontSize: const Value(16.0),
            ),
          );
    });

    return notebook;
  }

  @override
  Future<void> updateNotebook(Notebook notebook) async {
    await (_db.update(
      _db.notebooksTable,
    )..where((tbl) => tbl.id.equals(notebook.id))).write(
      NotebooksTableCompanion(
        title: Value(notebook.title.trim()),
        subtitle: Value(notebook.subtitle?.trim()),
      ),
    );
  }

  @override
  Future<void> deleteNotebook(String notebookId) async {
    await (_db.delete(
      _db.notebooksTable,
    )..where((tbl) => tbl.id.equals(notebookId))).go();
  }

  @override
  Stream<List<NotebookPage>> watchPages(String notebookId) {
    final query = _db.select(_db.notebookPagesTable)
      ..where((tbl) => tbl.notebookId.equals(notebookId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.orderIndex)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => NotebookPage(
              id: row.id,
              notebookId: row.notebookId,
              orderIndex: row.orderIndex,
              content: row.content,
              fontPreset: editorFontPresetFromStorage(row.fontPreset),
              fontSize: row.fontSize,
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<NotebookPage> addPage(String notebookId) async {
    final maxIndexExpression = _db.notebookPagesTable.orderIndex.max();
    final result =
        await (_db.selectOnly(_db.notebookPagesTable)
              ..where(_db.notebookPagesTable.notebookId.equals(notebookId))
              ..addColumns([maxIndexExpression]))
            .getSingleOrNull();
    final maxIndex = result?.read(maxIndexExpression) ?? -1;

    final page = NotebookPage(
      id: _uuid.v4(),
      notebookId: notebookId,
      orderIndex: maxIndex + 1,
      content: '',
      fontPreset: EditorFontPreset.classic,
      fontSize: 16,
    );

    await _db
        .into(_db.notebookPagesTable)
        .insert(
          NotebookPagesTableCompanion.insert(
            id: page.id,
            notebookId: page.notebookId,
            orderIndex: page.orderIndex,
            content: Value(page.content),
            fontPreset: Value(page.fontPreset.name),
            fontSize: Value(page.fontSize),
          ),
        );

    return page;
  }

  @override
  Future<void> updatePageContent(String pageId, String content) async {
    await (_db.update(_db.notebookPagesTable)
          ..where((tbl) => tbl.id.equals(pageId)))
        .write(NotebookPagesTableCompanion(content: Value(content)));
  }

  @override
  Future<void> updatePageStyle(
    String pageId,
    EditorFontPreset preset,
    double fontSize,
  ) async {
    final clampedSize = fontSize.clamp(12, 30).toDouble();
    await (_db.update(
      _db.notebookPagesTable,
    )..where((tbl) => tbl.id.equals(pageId))).write(
      NotebookPagesTableCompanion(
        fontPreset: Value(preset.name),
        fontSize: Value(clampedSize),
      ),
    );
  }

  @override
  Future<void> deletePage(String pageId) async {
    await (_db.delete(
      _db.notebookPagesTable,
    )..where((tbl) => tbl.id.equals(pageId))).go();
  }

  @override
  Future<void> reorderPages(
    String notebookId,
    List<String> orderedPageIds,
  ) async {
    await _db.transaction(() async {
      for (var index = 0; index < orderedPageIds.length; index++) {
        final pageId = orderedPageIds[index];
        await (_db.update(_db.notebookPagesTable)
              ..where((tbl) => tbl.id.equals(pageId)))
            .write(NotebookPagesTableCompanion(orderIndex: Value(index)));
      }
    });
  }

  @override
  Future<void> shufflePages(String notebookId) async {
    final pages =
        await (_db.select(_db.notebookPagesTable)
              ..where((tbl) => tbl.notebookId.equals(notebookId))
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.orderIndex)]))
            .get();

    if (pages.length <= 1) {
      return;
    }

    final shuffledIds = pages.map((page) => page.id).toList(growable: true)
      ..shuffle(Random());
    await reorderPages(notebookId, shuffledIds);
  }
}

class VisionBoardDriftRepository implements VisionBoardRepository {
  VisionBoardDriftRepository(this._db, this._uuid);

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<VisionBoardItem>> watchItems() {
    final query = _db.select(_db.visionItemsTable)
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.id)]);

    return query.watch().map(
      (rows) => rows.map(_mapVisionItem).toList(growable: false),
    );
  }

  @override
  Future<VisionBoardItem> addTextItem() async {
    final item = VisionBoardItem(
      id: _uuid.v4(),
      type: VisionItemType.text,
      x: 80,
      y: 80,
      width: 220,
      height: 160,
      text: 'Write your dream...',
      imagePath: null,
    );
    await upsertItem(item);
    return item;
  }

  @override
  Future<VisionBoardItem> addImageItem(String imagePath) async {
    final item = VisionBoardItem(
      id: _uuid.v4(),
      type: VisionItemType.image,
      x: 120,
      y: 120,
      width: 260,
      height: 200,
      text: null,
      imagePath: imagePath,
    );
    await upsertItem(item);
    return item;
  }

  @override
  Future<void> upsertItem(VisionBoardItem item) async {
    await _db
        .into(_db.visionItemsTable)
        .insertOnConflictUpdate(
          VisionItemsTableCompanion.insert(
            id: item.id,
            type: item.type.name,
            x: item.x,
            y: item.y,
            width: item.width,
            height: item.height,
            noteText: Value(item.text),
            imagePath: Value(item.imagePath),
          ),
        );
  }

  @override
  Future<void> deleteItem(String itemId) async {
    await (_db.delete(
      _db.visionItemsTable,
    )..where((tbl) => tbl.id.equals(itemId))).go();
  }

  VisionBoardItem _mapVisionItem(VisionItemsTableData row) {
    return VisionBoardItem(
      id: row.id,
      type: row.type == VisionItemType.image.name
          ? VisionItemType.image
          : VisionItemType.text,
      x: row.x,
      y: row.y,
      width: row.width,
      height: row.height,
      text: row.noteText,
      imagePath: row.imagePath,
    );
  }
}

class PlannerDriftRepository implements PlannerRepository {
  PlannerDriftRepository(this._db, this._uuid);

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<Goal>> watchGoals() {
    final query = _db.select(_db.goalsTable)
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.targetDateEpochMs),
        (tbl) => OrderingTerm.asc(tbl.title),
      ]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => Goal(
              id: row.id,
              title: row.title,
              description: row.description,
              targetDate: row.targetDateEpochMs == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(row.targetDateEpochMs!),
              status: goalStatusFromStorage(row.status),
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<Goal> createGoal({
    required String title,
    required String description,
    required DateTime? targetDate,
    required GoalStatus status,
  }) async {
    final goal = Goal(
      id: _uuid.v4(),
      title: title.trim(),
      description: description.trim(),
      targetDate: targetDate == null ? null : normalizeDate(targetDate),
      status: status,
    );

    await _db
        .into(_db.goalsTable)
        .insert(
          GoalsTableCompanion.insert(
            id: goal.id,
            title: goal.title,
            description: Value(goal.description),
            targetDateEpochMs: Value(goal.targetDate?.millisecondsSinceEpoch),
            status: goal.status.storageValue,
          ),
        );

    return goal;
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    await (_db.update(
      _db.goalsTable,
    )..where((tbl) => tbl.id.equals(goal.id))).write(
      GoalsTableCompanion(
        title: Value(goal.title.trim()),
        description: Value(goal.description.trim()),
        targetDateEpochMs: Value(goal.targetDate?.millisecondsSinceEpoch),
        status: Value(goal.status.storageValue),
      ),
    );
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await (_db.delete(
      _db.goalsTable,
    )..where((tbl) => tbl.id.equals(goalId))).go();
  }

  @override
  Stream<List<TaskItem>> watchTasks(String goalId) {
    final query = _db.select(_db.tasksTable)
      ..where((tbl) => tbl.goalId.equals(goalId))
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.dueDateEpochMs),
        (tbl) => OrderingTerm.asc(tbl.title),
      ]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => TaskItem(
              id: row.id,
              goalId: row.goalId,
              title: row.title,
              dueDate: row.dueDateEpochMs == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(row.dueDateEpochMs!),
              status: taskStatusFromStorage(row.status),
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<TaskItem> createTask({
    required String goalId,
    required String title,
    required DateTime? dueDate,
    required TaskStatus status,
  }) async {
    final task = TaskItem(
      id: _uuid.v4(),
      goalId: goalId,
      title: title.trim(),
      dueDate: dueDate == null ? null : normalizeDate(dueDate),
      status: status,
    );

    await _db
        .into(_db.tasksTable)
        .insert(
          TasksTableCompanion.insert(
            id: task.id,
            goalId: task.goalId,
            title: task.title,
            dueDateEpochMs: Value(task.dueDate?.millisecondsSinceEpoch),
            status: task.status.storageValue,
          ),
        );

    return task;
  }

  @override
  Future<void> updateTask(TaskItem task) async {
    await (_db.update(
      _db.tasksTable,
    )..where((tbl) => tbl.id.equals(task.id))).write(
      TasksTableCompanion(
        title: Value(task.title.trim()),
        dueDateEpochMs: Value(task.dueDate?.millisecondsSinceEpoch),
        status: Value(task.status.storageValue),
      ),
    );
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await (_db.delete(
      _db.tasksTable,
    )..where((tbl) => tbl.id.equals(taskId))).go();
  }
}

class AiChatDriftRepository implements AiChatRepository {
  AiChatDriftRepository(this._db, this._uuid);

  final AppDatabase _db;
  final Uuid _uuid;

  static const int _settingsId = 1;

  @override
  Stream<List<AiChatSession>> watchSessions() {
    final query = _db.select(_db.aiChatSessionsTable)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAtEpochMs)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => AiChatSession(
              id: row.id,
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                row.createdAtEpochMs,
              ),
              title: row.title,
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Stream<List<AiChatMessage>> watchMessages(String sessionId) {
    final query = _db.select(_db.aiChatMessagesTable)
      ..where((tbl) => tbl.sessionId.equals(sessionId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAtEpochMs)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => AiChatMessage(
              id: row.id,
              sessionId: row.sessionId,
              role: aiRoleFromStorage(row.role),
              content: row.content,
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                row.createdAtEpochMs,
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<AiChatSession> createSession({String? title}) async {
    final now = DateTime.now();
    final session = AiChatSession(
      id: _uuid.v4(),
      createdAt: now,
      title: (title == null || title.trim().isEmpty)
          ? _defaultSessionTitle(now)
          : title.trim(),
    );

    await _db
        .into(_db.aiChatSessionsTable)
        .insert(
          AiChatSessionsTableCompanion.insert(
            id: session.id,
            createdAtEpochMs: session.createdAt.millisecondsSinceEpoch,
            title: session.title,
          ),
        );
    return session;
  }

  @override
  Future<void> addMessage(AiChatMessage message) async {
    await _db
        .into(_db.aiChatMessagesTable)
        .insert(
          AiChatMessagesTableCompanion.insert(
            id: message.id,
            sessionId: message.sessionId,
            role: message.role.storageValue,
            content: message.content,
            createdAtEpochMs: message.createdAt.millisecondsSinceEpoch,
          ),
        );
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await (_db.delete(
      _db.aiChatSessionsTable,
    )..where((tbl) => tbl.id.equals(sessionId))).go();
  }

  @override
  Future<AiSettings> getAiSettings() async {
    final existing = await (_db.select(
      _db.aiSettingsTable,
    )..where((tbl) => tbl.singletonId.equals(_settingsId))).getSingleOrNull();

    if (existing != null) {
      return AiSettings(
        selectedModel: existing.selectedModel,
        notebookContextEnabled: existing.notebookContextEnabled,
        enableAssistantActions: existing.enableAssistantActions,
      );
    }

    await _db
        .into(_db.aiSettingsTable)
        .insert(
          AiSettingsTableCompanion.insert(
            singletonId: const Value(_settingsId),
            selectedModel: const Value('gpt-4.1-mini'),
            notebookContextEnabled: Value(false),
            enableAssistantActions: Value(true),
          ),
        );

    return const AiSettings(
      selectedModel: 'gpt-4.1-mini',
      notebookContextEnabled: false,
      enableAssistantActions: true,
    );
  }

  @override
  Future<void> updateAiSettings(AiSettings settings) async {
    await _db
        .into(_db.aiSettingsTable)
        .insertOnConflictUpdate(
          AiSettingsTableCompanion.insert(
            singletonId: const Value(_settingsId),
            selectedModel: Value(settings.selectedModel),
            notebookContextEnabled: Value(settings.notebookContextEnabled),
            enableAssistantActions: Value(settings.enableAssistantActions),
          ),
        );
  }

  String _defaultSessionTitle(DateTime createdAt) {
    final month = createdAt.month.toString().padLeft(2, '0');
    final day = createdAt.day.toString().padLeft(2, '0');
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return 'Chat $month/$day $hour:$minute';
  }
}

class InMemoryScrapperSessionService implements ScrapperSessionService {
  String _text = '';

  @override
  String get text => _text;

  @override
  void clear() {
    _text = '';
  }

  @override
  void setText(String value) {
    _text = value;
  }
}
