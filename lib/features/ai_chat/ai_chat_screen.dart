import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/date/life_grid_calculator.dart';
import '../../core/models/entities.dart';
import '../../core/providers.dart';
import '../../core/services/openai_client.dart';
import '../../core/widgets/outlined_panel.dart';
import '../../core/widgets/responsive_panels_scaffold.dart';

final aiChatSessionsProvider = StreamProvider<List<AiChatSession>>(
  (ref) => ref.watch(aiChatRepositoryProvider).watchSessions(),
);

final aiChatMessagesProvider =
    StreamProvider.family<List<AiChatMessage>, String>(
      (ref, sessionId) =>
          ref.watch(aiChatRepositoryProvider).watchMessages(sessionId),
    );

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  String? _selectedSessionId;
  bool _sending = false;
  String? _error;
  AssistantActionProposal? _pendingAction;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _ensureSessionSelection(List<AiChatSession> sessions) {
    if (sessions.isEmpty) {
      if (_selectedSessionId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            _selectedSessionId = null;
          });
        });
      }
      return;
    }

    if (!sessions.any((session) => session.id == _selectedSessionId)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _selectedSessionId = sessions.first.id;
        });
      });
    }
  }

  Future<String> _ensureSessionId() async {
    final existingId = _selectedSessionId;
    if (existingId != null) {
      return existingId;
    }

    final session = await ref.read(aiChatRepositoryProvider).createSession();
    if (mounted) {
      setState(() {
        _selectedSessionId = session.id;
      });
    }
    return session.id;
  }

  Future<void> _createSession() async {
    final session = await ref.read(aiChatRepositoryProvider).createSession();
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedSessionId = session.id;
      _pendingAction = null;
    });
  }

  Future<void> _deleteSession(String sessionId) async {
    await ref.read(aiChatRepositoryProvider).deleteSession(sessionId);
    if (!mounted) {
      return;
    }
    if (_selectedSessionId == sessionId) {
      setState(() {
        _selectedSessionId = null;
        _pendingAction = null;
      });
    }
  }

  Future<void> _sendMessage() async {
    final prompt = _messageController.text.trim();
    if (prompt.isEmpty || _sending) {
      return;
    }

    final sessionId = await _ensureSessionId();
    final uuid = ref.read(uuidProvider);

    final userMessage = AiChatMessage(
      id: uuid.v4(),
      sessionId: sessionId,
      role: AiRole.user,
      content: prompt,
      createdAt: DateTime.now(),
    );
    await ref.read(aiChatRepositoryProvider).addMessage(userMessage);

    _messageController.clear();
    setState(() {
      _sending = true;
      _error = null;
    });

    try {
      final apiKey = await ref.read(secretStoreProvider).readOpenAiApiKey();
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('No API key connected. Open Settings > AI Settings.');
      }

      final aiRepository = ref.read(aiChatRepositoryProvider);
      final aiSettings = await aiRepository.getAiSettings();
      final history = await aiRepository.watchMessages(sessionId).first;
      final context = await _buildContext(aiSettings);

      final request = AiRequest(
        model: aiSettings.selectedModel,
        systemPrompt: _systemPrompt(context),
        messages: history
            .where((message) => message.role != AiRole.system)
            .map(
              (message) => AiRequestMessage(
                role: message.role,
                content: message.content,
              ),
            )
            .toList(growable: false),
      );

      final response = await ref
          .read(aiClientProvider)
          .send(apiKey: apiKey, request: request);

      await aiRepository.addMessage(
        AiChatMessage(
          id: uuid.v4(),
          sessionId: sessionId,
          role: AiRole.assistant,
          content: response.text,
          createdAt: DateTime.now(),
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _pendingAction = aiSettings.enableAssistantActions
            ? response.action
            : null;
      });
    } catch (error) {
      final uuid = ref.read(uuidProvider);
      await ref
          .read(aiChatRepositoryProvider)
          .addMessage(
            AiChatMessage(
              id: uuid.v4(),
              sessionId: sessionId,
              role: AiRole.assistant,
              content: 'Assistant error: $error',
              createdAt: DateTime.now(),
            ),
          );

      if (mounted) {
        setState(() {
          _error = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  String _systemPrompt(String context) {
    return '''
You are Hito+, an in-app personal assistant for planning and reflection.
Use this app context when helpful:
$context

Rules:
- Keep answers concise and practical.
- If suggesting write actions, only suggest create_goal or create_task.
- For write action suggestions, include exactly one JSON object with this schema:
  {"reply":"...","action":{"type":"create_goal|create_task",...}}
- If no action is needed, respond in plain text.
- Never claim to run OS/system commands.
''';
  }

  Future<String> _buildContext(AiSettings aiSettings) async {
    final settings = await ref.read(settingsRepositoryProvider).getSettings();
    final lifeStats = calculateLifeGridStats(
      birthDate: settings.birthDate,
      lifespanYears: settings.lifespanYears,
    );

    final goals = await ref.read(plannerRepositoryProvider).watchGoals().first;
    final totalTasks = await _countTasks(goals);
    final doneGoals = goals
        .where((goal) => goal.status == GoalStatus.done)
        .length;

    final visionItems = await ref
        .read(visionBoardRepositoryProvider)
        .watchItems()
        .first;
    final visionTextItems = visionItems
        .where((item) => item.type == VisionItemType.text)
        .length;
    final visionImageItems = visionItems
        .where((item) => item.type == VisionItemType.image)
        .length;

    String notebookSummary = 'Notebook context: disabled.';
    if (settings.notebookAiAccessEnabled && aiSettings.notebookContextEnabled) {
      final notebooks = await ref
          .read(notebookRepositoryProvider)
          .watchNotebooks()
          .first;
      final topNotebook = notebooks.isEmpty ? null : notebooks.first;
      if (topNotebook == null) {
        notebookSummary = 'Notebook context: enabled, no notebooks.';
      } else {
        final pages = await ref
            .read(notebookRepositoryProvider)
            .watchPages(topNotebook.id)
            .first;
        final preview = pages.isEmpty
            ? ''
            : pages.first.content.replaceAll('\n', ' ').trim();
        final safePreview = preview.length > 220
            ? '${preview.substring(0, 220)}...'
            : preview;
        notebookSummary =
            'Notebook context: enabled. Top notebook "${topNotebook.title}" has ${pages.length} pages. '
            'First page preview: ${safePreview.isEmpty ? '(empty)' : safePreview}';
      }
    }

    return '''
Calendar: age ${lifeStats.ageYears}, lived days ${lifeStats.livedDays}, remaining days ${lifeStats.remainingDays}, total ${lifeStats.totalDays}.
Planner: ${goals.length} goals ($doneGoals done), $totalTasks tasks total.
Vision Board: ${visionItems.length} items ($visionTextItems text, $visionImageItems image).
$notebookSummary
''';
  }

  Future<int> _countTasks(List<Goal> goals) async {
    var total = 0;
    for (final goal in goals) {
      final tasks = await ref
          .read(plannerRepositoryProvider)
          .watchTasks(goal.id)
          .first;
      total += tasks.length;
    }
    return total;
  }

  Future<void> _confirmPendingAction() async {
    final action = _pendingAction;
    if (action == null) {
      return;
    }

    try {
      switch (action.type) {
        case AssistantActionType.createGoal:
          await _applyCreateGoal(action.payload);
          break;
        case AssistantActionType.createTask:
          await _applyCreateTask(action.payload);
          break;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _pendingAction = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Action applied.')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = 'Could not apply action: $error';
      });
    }
  }

  Future<void> _applyCreateGoal(Map<String, dynamic> payload) async {
    final title = (payload['title'] ?? '').toString().trim();
    if (title.isEmpty) {
      throw Exception('Action missing goal title.');
    }

    final description = (payload['description'] ?? '').toString();
    final status = _goalStatusFromAny(payload['status']);
    final targetDate = _parseDate(payload['targetDate']);

    await ref
        .read(plannerRepositoryProvider)
        .createGoal(
          title: title,
          description: description,
          targetDate: targetDate,
          status: status,
        );
  }

  Future<void> _applyCreateTask(Map<String, dynamic> payload) async {
    final title = (payload['title'] ?? '').toString().trim();
    if (title.isEmpty) {
      throw Exception('Action missing task title.');
    }

    String? goalId;
    final rawGoalId = payload['goalId'];
    if (rawGoalId is String && rawGoalId.trim().isNotEmpty) {
      goalId = rawGoalId.trim();
    }

    if (goalId == null) {
      final goalTitle = (payload['goalTitle'] ?? '').toString().trim();
      if (goalTitle.isNotEmpty) {
        final goals = await ref
            .read(plannerRepositoryProvider)
            .watchGoals()
            .first;
        final matched = goals.firstWhereOrNull(
          (goal) => goal.title.toLowerCase() == goalTitle.toLowerCase(),
        );
        goalId = matched?.id;
      }
    }

    if (goalId == null) {
      throw Exception('Action missing valid goal reference.');
    }

    await ref
        .read(plannerRepositoryProvider)
        .createTask(
          goalId: goalId,
          title: title,
          dueDate: _parseDate(payload['dueDate']),
          status: _taskStatusFromAny(payload['status']),
        );
  }

  GoalStatus _goalStatusFromAny(Object? value) {
    final raw = (value ?? 'todo').toString();
    return goalStatusFromStorage(raw);
  }

  TaskStatus _taskStatusFromAny(Object? value) {
    final raw = (value ?? 'todo').toString();
    return taskStatusFromStorage(raw);
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) {
      return null;
    }
    final raw = value.toString().trim();
    if (raw.isEmpty) {
      return null;
    }
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return null;
    }
    return normalizeDate(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(aiChatSessionsProvider);

    return sessionsAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (error, stackTrace) =>
          const Center(child: Text('Failed to load AI chat sessions.')),
      data: (sessions) {
        _ensureSessionSelection(sessions);

        final secondary = _AiChatSessionsPanel(
          sessions: sessions,
          selectedSessionId: _selectedSessionId,
          onCreateSession: _createSession,
          onDeleteSession: _deleteSession,
          onSelectSession: (sessionId) {
            setState(() {
              _selectedSessionId = sessionId;
              _pendingAction = null;
            });
          },
        );

        final selectedSessionId = _selectedSessionId;
        final primary = selectedSessionId == null
            ? const Center(
                child: Text(
                  'Create a chat session to begin.',
                  style: TextStyle(fontFamily: 'Consolas'),
                ),
              )
            : ref
                  .watch(aiChatMessagesProvider(selectedSessionId))
                  .when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (error, stackTrace) => const Center(
                      child: Text('Failed to load chat messages.'),
                    ),
                    data: (messages) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                fontFamily: 'Consolas',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (_pendingAction != null)
                          _PendingActionBanner(
                            action: _pendingAction!,
                            onConfirm: _confirmPendingAction,
                            onDismiss: () {
                              setState(() {
                                _pendingAction = null;
                              });
                            },
                          ),
                        if (_pendingAction != null) const SizedBox(height: 8),
                        Expanded(
                          child: OutlinedPanel(
                            padding: const EdgeInsets.all(10),
                            backgroundColor: AppTheme.panel,
                            child: messages.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No messages yet.',
                                      style: TextStyle(fontFamily: 'Consolas'),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: messages.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 8),
                                    itemBuilder: (context, index) {
                                      final message = messages[index];
                                      return _MessageBubble(message: message);
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedPanel(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Ask AI to plan, summarize, or reflect...',
                                  ),
                                  onSubmitted: (_) => _sendMessage(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _sending ? null : _sendMessage,
                                child: Text(_sending ? 'Sending...' : 'Send'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

        return ResponsivePanelsScaffold(
          primary: primary,
          secondary: secondary,
          secondaryWidth: 300,
        );
      },
    );
  }
}

class _AiChatSessionsPanel extends StatelessWidget {
  const _AiChatSessionsPanel({
    required this.sessions,
    required this.selectedSessionId,
    required this.onCreateSession,
    required this.onDeleteSession,
    required this.onSelectSession,
  });

  final List<AiChatSession> sessions;
  final String? selectedSessionId;
  final Future<void> Function() onCreateSession;
  final Future<void> Function(String sessionId) onDeleteSession;
  final ValueChanged<String> onSelectSession;

  @override
  Widget build(BuildContext context) {
    return OutlinedPanel(
      padding: const EdgeInsets.all(10),
      backgroundColor: AppTheme.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: onCreateSession,
            child: const Text('New Chat'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: sessions.isEmpty
                ? const Center(child: Text('No sessions yet.'))
                : ListView.separated(
                    itemCount: sessions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final selected = session.id == selectedSessionId;
                      return InkWell(
                        borderRadius: AppTheme.borderRadiusSm,
                        onTap: () => onSelectSession(session.id),
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      session.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () =>
                                        onDeleteSession(session.id),
                                    child: const Text('X'),
                                  ),
                                ],
                              ),
                              Text(
                                DateFormat(
                                  'dd MMM HH:mm',
                                ).format(session.createdAt),
                                style: const TextStyle(
                                  fontFamily: 'Consolas',
                                  fontSize: 11,
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

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final AiChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == AiRole.user;
    final roleLabel = switch (message.role) {
      AiRole.user => 'You',
      AiRole.assistant => 'Assistant',
      AiRole.system => 'System',
    };

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: OutlinedPanel(
          padding: const EdgeInsets.all(8),
          backgroundColor: isUser ? AppTheme.paper : AppTheme.panel,
          borderWidth: 1.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                roleLabel,
                style: const TextStyle(
                  fontFamily: 'Consolas',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(message.content),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingActionBanner extends StatelessWidget {
  const _PendingActionBanner({
    required this.action,
    required this.onConfirm,
    required this.onDismiss,
  });

  final AssistantActionProposal action;
  final Future<void> Function() onConfirm;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final title = action.type == AssistantActionType.createGoal
        ? 'Suggested action: Create goal'
        : 'Suggested action: Create task';

    return OutlinedPanel(
      padding: const EdgeInsets.all(10),
      backgroundColor: AppTheme.panel,
      borderWidth: 1.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Consolas',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(action.payload.toString()),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton(
                onPressed: onConfirm,
                child: const Text('Confirm Action'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onDismiss,
                child: const Text('Dismiss'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension _IterableX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T value) predicate) {
    for (final value in this) {
      if (predicate(value)) {
        return value;
      }
    }
    return null;
  }
}
