import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class SettingsTable extends Table {
  IntColumn get singletonId => integer()();

  IntColumn get birthDateEpochMs => integer()();

  IntColumn get lifespanYears => integer()();

  IntColumn get yearDotRows => integer().withDefault(const Constant(4))();

  BoolColumn get notebookAiAccessEnabled =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {singletonId};
}

class NotebooksTable extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get subtitle => text().nullable()();

  IntColumn get createdAtEpochMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class NotebookPagesTable extends Table {
  TextColumn get id => text()();

  TextColumn get notebookId =>
      text().references(NotebooksTable, #id, onDelete: KeyAction.cascade)();

  IntColumn get orderIndex => integer()();

  TextColumn get content => text().withDefault(const Constant(''))();

  TextColumn get fontPreset => text().withDefault(const Constant('classic'))();

  RealColumn get fontSize => real().withDefault(const Constant(16.0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class VisionItemsTable extends Table {
  TextColumn get id => text()();

  TextColumn get type => text()();

  RealColumn get x => real()();

  RealColumn get y => real()();

  RealColumn get width => real()();

  RealColumn get height => real()();

  TextColumn get noteText => text().nullable()();

  TextColumn get imagePath => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class GoalsTable extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get description => text().withDefault(const Constant(''))();

  IntColumn get targetDateEpochMs => integer().nullable()();

  TextColumn get status => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TasksTable extends Table {
  TextColumn get id => text()();

  TextColumn get goalId =>
      text().references(GoalsTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get title => text()();

  IntColumn get dueDateEpochMs => integer().nullable()();

  TextColumn get status => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AiChatSessionsTable extends Table {
  TextColumn get id => text()();

  IntColumn get createdAtEpochMs => integer()();

  TextColumn get title => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AiChatMessagesTable extends Table {
  TextColumn get id => text()();

  TextColumn get sessionId => text().references(
    AiChatSessionsTable,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get role => text()();

  TextColumn get content => text()();

  IntColumn get createdAtEpochMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AiSettingsTable extends Table {
  IntColumn get singletonId => integer()();

  TextColumn get selectedModel =>
      text().withDefault(const Constant('gpt-4.1-mini'))();

  BoolColumn get notebookContextEnabled =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get enableAssistantActions =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {singletonId};
}

@DriftDatabase(
  tables: [
    SettingsTable,
    NotebooksTable,
    NotebookPagesTable,
    VisionItemsTable,
    GoalsTable,
    TasksTable,
    AiChatSessionsTable,
    AiChatMessagesTable,
    AiSettingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(settingsTable, settingsTable.yearDotRows);
        await m.addColumn(settingsTable, settingsTable.notebookAiAccessEnabled);
        await m.addColumn(notebookPagesTable, notebookPagesTable.fontPreset);
        await m.addColumn(notebookPagesTable, notebookPagesTable.fontSize);

        await customStatement(
          'UPDATE settings_table SET year_dot_rows = 4 '
          'WHERE year_dot_rows IS NULL',
        );
        await customStatement(
          'UPDATE settings_table SET notebook_ai_access_enabled = 0 '
          'WHERE notebook_ai_access_enabled IS NULL',
        );
        await customStatement(
          "UPDATE notebook_pages_table SET font_preset = 'classic' "
          'WHERE font_preset IS NULL',
        );
        await customStatement(
          'UPDATE notebook_pages_table SET font_size = 16.0 '
          'WHERE font_size IS NULL',
        );
      }

      if (from < 3) {
        await m.createTable(aiChatSessionsTable);
        await m.createTable(aiChatMessagesTable);
        await m.createTable(aiSettingsTable);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final appDir = await getApplicationSupportDirectory();
    await appDir.create(recursive: true);
    final dbFile = File(p.join(appDir.path, 'calculated_life.sqlite'));
    return NativeDatabase.createInBackground(dbFile);
  });
}
