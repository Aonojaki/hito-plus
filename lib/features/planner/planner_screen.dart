import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/models/entities.dart';
import '../../core/providers.dart';
import '../../core/widgets/outlined_panel.dart';
import '../../core/widgets/responsive_panels_scaffold.dart';

final plannerGoalsStreamProvider = StreamProvider<List<Goal>>(
  (ref) => ref.watch(plannerRepositoryProvider).watchGoals(),
);

final plannerTasksStreamProvider =
    StreamProvider.family<List<TaskItem>, String>(
      (ref, goalId) => ref.watch(plannerRepositoryProvider).watchTasks(goalId),
    );

enum _PlannerFilter { all, todo, inProgress, done }

class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});

  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  String? _selectedGoalId;
  _PlannerFilter _filter = _PlannerFilter.all;

  final TextEditingController _goalTitleController = TextEditingController();
  final TextEditingController _goalDescriptionController =
      TextEditingController();
  String? _editingGoalId;

  final TextEditingController _taskController = TextEditingController();
  DateTime? _taskDueDate;
  TaskStatus _taskStatus = TaskStatus.todo;

  @override
  void dispose() {
    _goalTitleController.dispose();
    _goalDescriptionController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  void _ensureGoalSelection(List<Goal> goals) {
    if (goals.isEmpty) {
      if (_selectedGoalId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            _selectedGoalId = null;
            _editingGoalId = null;
            _goalTitleController.clear();
            _goalDescriptionController.clear();
          });
        });
      }
      return;
    }

    if (!goals.any((goal) => goal.id == _selectedGoalId)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _selectedGoalId = goals.first.id;
        });
      });
    }
  }

  void _syncGoalEditors(Goal? goal) {
    if (goal == null) {
      return;
    }

    if (_editingGoalId != goal.id || _goalTitleController.text != goal.title) {
      _editingGoalId = goal.id;
      _goalTitleController.text = goal.title;
      _goalDescriptionController.text = goal.description;
    }
  }

  Future<void> _createGoal() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    GoalStatus status = GoalStatus.todo;
    DateTime? targetDate;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Create Goal'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Goal title',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<GoalStatus>(
                      initialValue: status,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: [
                        for (final item in GoalStatus.values)
                          DropdownMenuItem(
                            value: item,
                            child: Text(item.label),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setStateDialog(() {
                            status = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            targetDate == null
                                ? 'No target date'
                                : DateFormat('dd MMM yyyy').format(targetDate!),
                            style: const TextStyle(fontFamily: 'Consolas'),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900, 1, 1),
                              lastDate: DateTime(2100, 1, 1),
                              initialDate: targetDate ?? DateTime.now(),
                            );
                            if (picked != null) {
                              setStateDialog(() {
                                targetDate = picked;
                              });
                            }
                          },
                          child: const Text('Pick Date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) {
                      return;
                    }
                    final goal = await ref
                        .read(plannerRepositoryProvider)
                        .createGoal(
                          title: titleController.text,
                          description: descriptionController.text,
                          targetDate: targetDate,
                          status: status,
                        );
                    if (mounted) {
                      setState(() {
                        _selectedGoalId = goal.id;
                      });
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
  }

  Future<void> _saveGoal(Goal selectedGoal) async {
    await ref
        .read(plannerRepositoryProvider)
        .updateGoal(
          selectedGoal.copyWith(
            title: _goalTitleController.text,
            description: _goalDescriptionController.text,
          ),
        );
  }

  Future<void> _deleteGoal(Goal selectedGoal) async {
    await ref.read(plannerRepositoryProvider).deleteGoal(selectedGoal.id);
  }

  Future<void> _addTask() async {
    final goalId = _selectedGoalId;
    final title = _taskController.text.trim();
    if (goalId == null || title.isEmpty) {
      return;
    }

    await ref
        .read(plannerRepositoryProvider)
        .createTask(
          goalId: goalId,
          title: title,
          dueDate: _taskDueDate,
          status: _taskStatus,
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _taskController.clear();
      _taskDueDate = null;
      _taskStatus = TaskStatus.todo;
    });
  }

  List<Goal> _applyFilter(List<Goal> goals) {
    return switch (_filter) {
      _PlannerFilter.all => goals,
      _PlannerFilter.todo =>
        goals.where((goal) => goal.status == GoalStatus.todo).toList(),
      _PlannerFilter.inProgress =>
        goals.where((goal) => goal.status == GoalStatus.inProgress).toList(),
      _PlannerFilter.done =>
        goals.where((goal) => goal.status == GoalStatus.done).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(plannerGoalsStreamProvider);

    return goalsAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (error, stackTrace) =>
          const Center(child: Text('Failed to load planner goals.')),
      data: (goals) {
        _ensureGoalSelection(goals);
        final filteredGoals = _applyFilter(goals);
        final selectedGoal = goals
            .where((goal) => goal.id == _selectedGoalId)
            .firstOrNull;
        _syncGoalEditors(selectedGoal);

        final secondaryPanel = _PlannerSecondaryPanel(
          goals: filteredGoals,
          selectedGoalId: _selectedGoalId,
          filter: _filter,
          onCreateGoal: _createGoal,
          onFilterChanged: (filter) {
            setState(() {
              _filter = filter;
            });
          },
          onSelectGoal: (goalId) {
            setState(() {
              _selectedGoalId = goalId;
            });
          },
        );

        final primaryPanel = selectedGoal == null
            ? const Center(
                child: Text(
                  'Create a goal to start planning.',
                  style: TextStyle(fontFamily: 'Consolas'),
                ),
              )
            : ref
                  .watch(plannerTasksStreamProvider(selectedGoal.id))
                  .when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (error, stackTrace) =>
                        const Center(child: Text('Failed to load tasks.')),
                    data: (tasks) => _PlannerPrimaryPanel(
                      selectedGoal: selectedGoal,
                      tasks: tasks,
                      goalTitleController: _goalTitleController,
                      goalDescriptionController: _goalDescriptionController,
                      taskController: _taskController,
                      taskDueDate: _taskDueDate,
                      taskStatus: _taskStatus,
                      onTaskDueDateChanged: (date) {
                        setState(() {
                          _taskDueDate = date;
                        });
                      },
                      onTaskStatusChanged: (status) {
                        setState(() {
                          _taskStatus = status;
                        });
                      },
                      onSaveGoal: () => _saveGoal(selectedGoal),
                      onDeleteGoal: () => _deleteGoal(selectedGoal),
                      onAddTask: _addTask,
                      onUpdateGoalStatus: (status) {
                        ref
                            .read(plannerRepositoryProvider)
                            .updateGoal(selectedGoal.copyWith(status: status));
                      },
                      onSetGoalDate: (date) {
                        ref
                            .read(plannerRepositoryProvider)
                            .updateGoal(
                              selectedGoal.copyWith(targetDate: date),
                            );
                      },
                      onClearGoalDate: () {
                        ref
                            .read(plannerRepositoryProvider)
                            .updateGoal(
                              selectedGoal.copyWith(targetDate: null),
                            );
                      },
                      onUpdateTaskStatus: (task, status) {
                        ref
                            .read(plannerRepositoryProvider)
                            .updateTask(task.copyWith(status: status));
                      },
                      onDeleteTask: (taskId) {
                        ref.read(plannerRepositoryProvider).deleteTask(taskId);
                      },
                    ),
                  );

        return ResponsivePanelsScaffold(
          primary: primaryPanel,
          secondary: secondaryPanel,
          secondaryWidth: 320,
        );
      },
    );
  }
}

class _PlannerSecondaryPanel extends StatelessWidget {
  const _PlannerSecondaryPanel({
    required this.goals,
    required this.selectedGoalId,
    required this.filter,
    required this.onCreateGoal,
    required this.onFilterChanged,
    required this.onSelectGoal,
  });

  final List<Goal> goals;
  final String? selectedGoalId;
  final _PlannerFilter filter;
  final Future<void> Function() onCreateGoal;
  final ValueChanged<_PlannerFilter> onFilterChanged;
  final ValueChanged<String> onSelectGoal;

  @override
  Widget build(BuildContext context) {
    return OutlinedPanel(
      padding: const EdgeInsets.all(10),
      backgroundColor: AppTheme.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onCreateGoal,
                  child: const Text('New Goal'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<_PlannerFilter>(
                  initialValue: filter,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Filter'),
                  items: const [
                    DropdownMenuItem(
                      value: _PlannerFilter.all,
                      child: Text('All'),
                    ),
                    DropdownMenuItem(
                      value: _PlannerFilter.todo,
                      child: Text('To Do'),
                    ),
                    DropdownMenuItem(
                      value: _PlannerFilter.inProgress,
                      child: Text('In Progress'),
                    ),
                    DropdownMenuItem(
                      value: _PlannerFilter.done,
                      child: Text('Done'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onFilterChanged(value);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: goals.isEmpty
                ? const Center(child: Text('No goals match this filter.'))
                : ListView.separated(
                    itemCount: goals.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      final selected = goal.id == selectedGoalId;
                      return InkWell(
                        onTap: () => onSelectGoal(goal.id),
                        borderRadius: AppTheme.borderRadiusSm,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selected ? AppTheme.paper : AppTheme.panel,
                            border: Border.all(color: AppTheme.ink, width: 1.5),
                            borderRadius: AppTheme.borderRadiusSm,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goal.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                goal.status.label,
                                style: const TextStyle(fontFamily: 'Consolas'),
                              ),
                              Text(
                                goal.targetDate == null
                                    ? 'No date'
                                    : DateFormat(
                                        'dd MMM yyyy',
                                      ).format(goal.targetDate!),
                                style: const TextStyle(
                                  fontFamily: 'Consolas',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PlannerPrimaryPanel extends StatelessWidget {
  const _PlannerPrimaryPanel({
    required this.selectedGoal,
    required this.tasks,
    required this.goalTitleController,
    required this.goalDescriptionController,
    required this.taskController,
    required this.taskDueDate,
    required this.taskStatus,
    required this.onTaskDueDateChanged,
    required this.onTaskStatusChanged,
    required this.onSaveGoal,
    required this.onDeleteGoal,
    required this.onAddTask,
    required this.onUpdateGoalStatus,
    required this.onSetGoalDate,
    required this.onClearGoalDate,
    required this.onUpdateTaskStatus,
    required this.onDeleteTask,
  });

  final Goal selectedGoal;
  final List<TaskItem> tasks;
  final TextEditingController goalTitleController;
  final TextEditingController goalDescriptionController;
  final TextEditingController taskController;
  final DateTime? taskDueDate;
  final TaskStatus taskStatus;
  final ValueChanged<DateTime?> onTaskDueDateChanged;
  final ValueChanged<TaskStatus> onTaskStatusChanged;
  final Future<void> Function() onSaveGoal;
  final Future<void> Function() onDeleteGoal;
  final Future<void> Function() onAddTask;
  final ValueChanged<GoalStatus> onUpdateGoalStatus;
  final ValueChanged<DateTime> onSetGoalDate;
  final VoidCallback onClearGoalDate;
  final void Function(TaskItem task, TaskStatus status) onUpdateTaskStatus;
  final ValueChanged<String> onDeleteTask;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedPanel(
          padding: const EdgeInsets.all(10),
          backgroundColor: AppTheme.panel,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: goalTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Goal title',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<GoalStatus>(
                      key: ValueKey(
                        'goal-status-${selectedGoal.id}-${selectedGoal.status.name}',
                      ),
                      initialValue: selectedGoal.status,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: [
                        for (final status in GoalStatus.values)
                          DropdownMenuItem(
                            value: status,
                            child: Text(status.label),
                          ),
                      ],
                      onChanged: (status) {
                        if (status != null) {
                          onUpdateGoalStatus(status);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: goalDescriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Goal description',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    selectedGoal.targetDate == null
                        ? 'No target date'
                        : 'Target: ${DateFormat('dd MMM yyyy').format(selectedGoal.targetDate!)}',
                    style: const TextStyle(fontFamily: 'Consolas'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900, 1, 1),
                        lastDate: DateTime(2100, 1, 1),
                        initialDate: selectedGoal.targetDate ?? DateTime.now(),
                      );
                      if (picked != null) {
                        onSetGoalDate(picked);
                      }
                    },
                    child: const Text('Set Date'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onClearGoalDate,
                    child: const Text('Clear Date'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: onSaveGoal,
                    child: const Text('Save Goal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onDeleteGoal,
                    child: const Text('Delete Goal'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: OutlinedPanel(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskController,
                        decoration: const InputDecoration(
                          labelText: 'New task title',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 140,
                      child: DropdownButtonFormField<TaskStatus>(
                        initialValue: taskStatus,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Status'),
                        items: [
                          for (final status in TaskStatus.values)
                            DropdownMenuItem(
                              value: status,
                              child: Text(status.label),
                            ),
                        ],
                        onChanged: (status) {
                          if (status != null) {
                            onTaskStatusChanged(status);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900, 1, 1),
                          lastDate: DateTime(2100, 1, 1),
                          initialDate: taskDueDate ?? DateTime.now(),
                        );
                        if (picked != null) {
                          onTaskDueDateChanged(picked);
                        }
                      },
                      child: Text(
                        taskDueDate == null
                            ? 'Task Date'
                            : DateFormat('dd MMM').format(taskDueDate!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onAddTask,
                      child: const Text('Add Task'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: tasks.isEmpty
                      ? const Center(child: Text('No tasks yet.'))
                      : ListView.separated(
                          itemCount: tasks.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.panel,
                                border: Border.all(
                                  color: AppTheme.ink,
                                  width: 1.4,
                                ),
                                borderRadius: AppTheme.borderRadiusSm,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    task.dueDate == null
                                        ? 'No due date'
                                        : DateFormat(
                                            'dd MMM yyyy',
                                          ).format(task.dueDate!),
                                    style: const TextStyle(
                                      fontFamily: 'Consolas',
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 140,
                                    child: DropdownButtonFormField<TaskStatus>(
                                      key: ValueKey(
                                        'task-status-${task.id}-${task.status.name}',
                                      ),
                                      initialValue: task.status,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Status',
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 6,
                                        ),
                                      ),
                                      items: [
                                        for (final status in TaskStatus.values)
                                          DropdownMenuItem(
                                            value: status,
                                            child: Text(status.label),
                                          ),
                                      ],
                                      onChanged: (status) {
                                        if (status != null) {
                                          onUpdateTaskStatus(task, status);
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    onPressed: () => onDeleteTask(task.id),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

extension _IterableX<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }
    return first;
  }
}
