import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/models/entities.dart';
import '../../core/providers.dart';
import '../../core/widgets/outlined_panel.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const List<String> _models = [
    'gpt-4.1-mini',
    'gpt-4.1',
    'gpt-4o-mini',
  ];

  final TextEditingController _apiKeyController = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _apiKeyConnected = false;

  AppSettings _settings = AppSettings(
    birthDate: DateTime(2000, 1, 1),
    lifespanYears: 80,
    yearDotRows: 4,
    notebookAiAccessEnabled: false,
  );

  AiSettings _aiSettings = const AiSettings(
    selectedModel: 'gpt-4.1-mini',
    notebookContextEnabled: false,
    enableAssistantActions: true,
  );

  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final settingsRepository = ref.read(settingsRepositoryProvider);
      final aiRepository = ref.read(aiChatRepositoryProvider);
      final secretStore = ref.read(secretStoreProvider);

      final loadedSettings = await settingsRepository.getSettings();
      final loadedAiSettings = await aiRepository.getAiSettings();
      final key = await secretStore.readOpenAiApiKey();

      if (!mounted) {
        return;
      }

      setState(() {
        _settings = loadedSettings;
        _aiSettings = loadedAiSettings;
        _apiKeyConnected = key != null && key.isNotEmpty;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _error = 'Failed to load settings.';
      });
    }
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ref.read(settingsRepositoryProvider).updateSettings(_settings);
      await ref.read(aiChatRepositoryProvider).updateAiSettings(_aiSettings);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Settings saved.')));
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = 'Could not save settings.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _connectApiKey() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) {
      setState(() {
        _error = 'Enter an API key first.';
      });
      return;
    }

    try {
      await ref.read(secretStoreProvider).saveOpenAiApiKey(key);
      if (!mounted) {
        return;
      }
      setState(() {
        _apiKeyConnected = true;
        _apiKeyController.clear();
        _error = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('API key connected.')));
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = 'Failed to connect API key.';
      });
    }
  }

  Future<void> _disconnectApiKey() async {
    try {
      await ref.read(secretStoreProvider).deleteOpenAiApiKey();
      if (!mounted) {
        return;
      }
      setState(() {
        _apiKeyConnected = false;
        _error = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('API key disconnected.')));
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = 'Failed to disconnect API key.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                _error!,
                style: const TextStyle(
                  fontFamily: 'Consolas',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          OutlinedPanel(
            padding: const EdgeInsets.all(10),
            backgroundColor: AppTheme.panel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Calendar Layout',
                  style: TextStyle(
                    fontFamily: 'Consolas',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 240,
                  child: DropdownButtonFormField<int>(
                    initialValue: _settings.yearDotRows,
                    decoration: const InputDecoration(
                      labelText: 'Year Dot Rows',
                    ),
                    isExpanded: true,
                    items: [
                      for (var value = 2; value <= 6; value++)
                        DropdownMenuItem(
                          value: value,
                          child: Text('$value rows'),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _settings = _settings.copyWith(yearDotRows: value);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Calendar updates live after save.',
                  style: TextStyle(fontFamily: 'Consolas'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          OutlinedPanel(
            padding: const EdgeInsets.all(10),
            backgroundColor: AppTheme.panel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notebook + Calligraphy',
                  style: TextStyle(
                    fontFamily: 'Consolas',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Allow notebook context in AI'),
                  subtitle: const Text(
                    'Off by default. Controls whether notebook content can be shared with AI.',
                  ),
                  value: _settings.notebookAiAccessEnabled,
                  onChanged: (value) {
                    setState(() {
                      _settings = _settings.copyWith(
                        notebookAiAccessEnabled: value,
                      );
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                const Text(
                  'Per-page font preset and size are edited directly in Notebook.',
                  style: TextStyle(fontFamily: 'Consolas'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          OutlinedPanel(
            padding: const EdgeInsets.all(10),
            backgroundColor: AppTheme.panel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Settings',
                  style: TextStyle(
                    fontFamily: 'Consolas',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 260,
                  child: DropdownButtonFormField<String>(
                    initialValue: _aiSettings.selectedModel,
                    decoration: const InputDecoration(labelText: 'Model'),
                    items: [
                      for (final model in _models)
                        DropdownMenuItem(value: model, child: Text(model)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _aiSettings = _aiSettings.copyWith(
                            selectedModel: value,
                          );
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('Enable notebook context'),
                  subtitle: const Text(
                    'Second-level toggle used by AI chat prompt assembly.',
                  ),
                  value: _aiSettings.notebookContextEnabled,
                  onChanged: (value) {
                    setState(() {
                      _aiSettings = _aiSettings.copyWith(
                        notebookContextEnabled: value,
                      );
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  title: const Text('Enable assistant actions'),
                  subtitle: const Text(
                    'Allows AI to suggest create-goal/create-task actions that require confirmation.',
                  ),
                  value: _aiSettings.enableAssistantActions,
                  onChanged: (value) {
                    setState(() {
                      _aiSettings = _aiSettings.copyWith(
                        enableAssistantActions: value,
                      );
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _apiKeyController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: _apiKeyConnected
                        ? 'Replace API key (optional)'
                        : 'OpenAI API key',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _connectApiKey,
                      child: Text(
                        _apiKeyConnected ? 'Replace Key' : 'Connect Key',
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: _apiKeyConnected ? _disconnectApiKey : null,
                      child: const Text('Disconnect'),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _apiKeyConnected
                          ? 'Status: connected'
                          : 'Status: not connected',
                      style: const TextStyle(fontFamily: 'Consolas'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving...' : 'Save Settings'),
          ),
        ],
      ),
    );
  }
}
