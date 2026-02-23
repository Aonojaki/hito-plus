import 'package:flutter/foundation.dart';

@immutable
class AppSettings {
  const AppSettings({
    required this.birthDate,
    required this.lifespanYears,
    required this.yearDotRows,
    required this.notebookAiAccessEnabled,
  });

  final DateTime birthDate;
  final int lifespanYears;
  final int yearDotRows;
  final bool notebookAiAccessEnabled;

  AppSettings copyWith({
    DateTime? birthDate,
    int? lifespanYears,
    int? yearDotRows,
    bool? notebookAiAccessEnabled,
  }) {
    return AppSettings(
      birthDate: birthDate ?? this.birthDate,
      lifespanYears: lifespanYears ?? this.lifespanYears,
      yearDotRows: yearDotRows ?? this.yearDotRows,
      notebookAiAccessEnabled:
          notebookAiAccessEnabled ?? this.notebookAiAccessEnabled,
    );
  }
}

@immutable
class LifeGridStats {
  const LifeGridStats({
    required this.ageYears,
    required this.livedDays,
    required this.remainingDays,
    required this.totalDays,
    required this.endDate,
  });

  final int ageYears;
  final int livedDays;
  final int remainingDays;
  final int totalDays;
  final DateTime endDate;
}

@immutable
class Notebook {
  const Notebook({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String? subtitle;
  final DateTime createdAt;

  Notebook copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? createdAt,
  }) {
    return Notebook(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@immutable
class NotebookPage {
  const NotebookPage({
    required this.id,
    required this.notebookId,
    required this.orderIndex,
    required this.content,
    required this.fontPreset,
    required this.fontSize,
  });

  final String id;
  final String notebookId;
  final int orderIndex;
  final String content;
  final EditorFontPreset fontPreset;
  final double fontSize;

  NotebookPage copyWith({
    String? id,
    String? notebookId,
    int? orderIndex,
    String? content,
    EditorFontPreset? fontPreset,
    double? fontSize,
  }) {
    return NotebookPage(
      id: id ?? this.id,
      notebookId: notebookId ?? this.notebookId,
      orderIndex: orderIndex ?? this.orderIndex,
      content: content ?? this.content,
      fontPreset: fontPreset ?? this.fontPreset,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

enum EditorFontPreset { classic, script, elegant, mono }

extension EditorFontPresetX on EditorFontPreset {
  String get label {
    switch (this) {
      case EditorFontPreset.classic:
        return 'Classic';
      case EditorFontPreset.script:
        return 'Script';
      case EditorFontPreset.elegant:
        return 'Elegant';
      case EditorFontPreset.mono:
        return 'Mono';
    }
  }

  String get fontFamily {
    switch (this) {
      case EditorFontPreset.classic:
        return 'Segoe UI';
      case EditorFontPreset.script:
        return 'Caveat';
      case EditorFontPreset.elegant:
        return 'Cormorant Garamond';
      case EditorFontPreset.mono:
        return 'JetBrains Mono';
    }
  }
}

EditorFontPreset editorFontPresetFromStorage(String value) {
  switch (value) {
    case 'classic':
      return EditorFontPreset.classic;
    case 'script':
      return EditorFontPreset.script;
    case 'elegant':
      return EditorFontPreset.elegant;
    case 'mono':
      return EditorFontPreset.mono;
    default:
      return EditorFontPreset.classic;
  }
}

enum VisionItemType { text, image }

@immutable
class VisionBoardItem {
  const VisionBoardItem({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.text,
    this.imagePath,
  });

  final String id;
  final VisionItemType type;
  final double x;
  final double y;
  final double width;
  final double height;
  final String? text;
  final String? imagePath;

  VisionBoardItem copyWith({
    String? id,
    VisionItemType? type,
    double? x,
    double? y,
    double? width,
    double? height,
    String? text,
    String? imagePath,
  }) {
    return VisionBoardItem(
      id: id ?? this.id,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

enum GoalStatus { todo, inProgress, done }

enum TaskStatus { todo, inProgress, done }

extension GoalStatusX on GoalStatus {
  String get storageValue {
    switch (this) {
      case GoalStatus.todo:
        return 'todo';
      case GoalStatus.inProgress:
        return 'in_progress';
      case GoalStatus.done:
        return 'done';
    }
  }

  String get label {
    switch (this) {
      case GoalStatus.todo:
        return 'To Do';
      case GoalStatus.inProgress:
        return 'In Progress';
      case GoalStatus.done:
        return 'Done';
    }
  }
}

extension TaskStatusX on TaskStatus {
  String get storageValue {
    switch (this) {
      case TaskStatus.todo:
        return 'todo';
      case TaskStatus.inProgress:
        return 'in_progress';
      case TaskStatus.done:
        return 'done';
    }
  }

  String get label {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }
}

GoalStatus goalStatusFromStorage(String value) {
  switch (value) {
    case 'todo':
      return GoalStatus.todo;
    case 'in_progress':
      return GoalStatus.inProgress;
    case 'done':
      return GoalStatus.done;
    default:
      return GoalStatus.todo;
  }
}

TaskStatus taskStatusFromStorage(String value) {
  switch (value) {
    case 'todo':
      return TaskStatus.todo;
    case 'in_progress':
      return TaskStatus.inProgress;
    case 'done':
      return TaskStatus.done;
    default:
      return TaskStatus.todo;
  }
}

@immutable
class Goal {
  const Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.status,
  });

  final String id;
  final String title;
  final String description;
  final DateTime? targetDate;
  final GoalStatus status;

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? targetDate,
    GoalStatus? status,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
    );
  }
}

@immutable
class TaskItem {
  const TaskItem({
    required this.id,
    required this.goalId,
    required this.title,
    required this.dueDate,
    required this.status,
  });

  final String id;
  final String goalId;
  final String title;
  final DateTime? dueDate;
  final TaskStatus status;

  TaskItem copyWith({
    String? id,
    String? goalId,
    String? title,
    DateTime? dueDate,
    TaskStatus? status,
  }) {
    return TaskItem(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }
}

enum AiRole { user, assistant, system }

extension AiRoleX on AiRole {
  String get storageValue => name;
}

AiRole aiRoleFromStorage(String value) {
  switch (value) {
    case 'user':
      return AiRole.user;
    case 'assistant':
      return AiRole.assistant;
    case 'system':
      return AiRole.system;
    default:
      return AiRole.user;
  }
}

@immutable
class AiChatSession {
  const AiChatSession({
    required this.id,
    required this.createdAt,
    required this.title,
  });

  final String id;
  final DateTime createdAt;
  final String title;
}

@immutable
class AiChatMessage {
  const AiChatMessage({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String sessionId;
  final AiRole role;
  final String content;
  final DateTime createdAt;
}

@immutable
class AiSettings {
  const AiSettings({
    required this.selectedModel,
    required this.notebookContextEnabled,
    required this.enableAssistantActions,
  });

  final String selectedModel;
  final bool notebookContextEnabled;
  final bool enableAssistantActions;

  AiSettings copyWith({
    String? selectedModel,
    bool? notebookContextEnabled,
    bool? enableAssistantActions,
  }) {
    return AiSettings(
      selectedModel: selectedModel ?? this.selectedModel,
      notebookContextEnabled:
          notebookContextEnabled ?? this.notebookContextEnabled,
      enableAssistantActions:
          enableAssistantActions ?? this.enableAssistantActions,
    );
  }
}
