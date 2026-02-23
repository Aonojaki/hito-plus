import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/models/entities.dart';
import '../../core/providers.dart';
import '../../core/widgets/outlined_panel.dart';
import '../../core/widgets/responsive_panels_scaffold.dart';

final notebooksStreamProvider = StreamProvider<List<Notebook>>(
  (ref) => ref.watch(notebookRepositoryProvider).watchNotebooks(),
);

final notebookPagesStreamProvider =
    StreamProvider.family<List<NotebookPage>, String>(
      (ref, notebookId) =>
          ref.watch(notebookRepositoryProvider).watchPages(notebookId),
    );

class NotebookScreen extends ConsumerStatefulWidget {
  const NotebookScreen({super.key});

  @override
  ConsumerState<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends ConsumerState<NotebookScreen> {
  String? _selectedNotebookId;
  String? _selectedPageId;

  final TextEditingController _contentController = TextEditingController();
  String? _editingPageId;
  Timer? _autosaveDebounce;
  String? _pendingPageId;
  String? _pendingContent;

  EditorFontPreset _editorPreset = EditorFontPreset.classic;
  double _editorFontSize = 16;

  @override
  void dispose() {
    _flushPendingAutosave();
    _autosaveDebounce?.cancel();
    _contentController.dispose();
    super.dispose();
  }

  void _ensureNotebookSelection(List<Notebook> notebooks) {
    if (notebooks.isEmpty) {
      if (_selectedNotebookId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            _selectedNotebookId = null;
            _selectedPageId = null;
            _editingPageId = null;
            _contentController.clear();
          });
        });
      }
      return;
    }

    final exists = notebooks.any((n) => n.id == _selectedNotebookId);
    if (!exists) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _selectedNotebookId = notebooks.first.id;
          _selectedPageId = null;
        });
      });
    }
  }

  void _ensurePageSelection(List<NotebookPage> pages) {
    if (pages.isEmpty) {
      if (_selectedPageId != null ||
          _editingPageId != null ||
          _contentController.text.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            _selectedPageId = null;
            _editingPageId = null;
            _contentController.clear();
          });
        });
      }
      return;
    }

    final selectedExists = pages.any((p) => p.id == _selectedPageId);
    if (!selectedExists) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _selectedPageId = pages.first.id;
        });
      });
    }
  }

  void _syncEditor(NotebookPage? page) {
    if (page == null) {
      return;
    }
    if (_editingPageId != page.id || _contentController.text != page.content) {
      if (_editingPageId != null && _editingPageId != page.id) {
        _flushPendingAutosave();
      }
      _editingPageId = page.id;
      _contentController.value = TextEditingValue(
        text: page.content,
        selection: TextSelection.collapsed(offset: page.content.length),
      );
    }

    if (_editorPreset != page.fontPreset ||
        (_editorFontSize - page.fontSize).abs() > 0.01) {
      _editorPreset = page.fontPreset;
      _editorFontSize = page.fontSize;
    }
  }

  void _scheduleAutosave(String pageId, String content) {
    _pendingPageId = pageId;
    _pendingContent = content;
    _autosaveDebounce?.cancel();
    _autosaveDebounce = Timer(const Duration(milliseconds: 260), () {
      _flushPendingAutosave();
    });
  }

  void _flushPendingAutosave() {
    final pageId = _pendingPageId;
    final content = _pendingContent;
    if (pageId == null || content == null) {
      return;
    }

    _pendingPageId = null;
    _pendingContent = null;
    unawaited(
      ref.read(notebookRepositoryProvider).updatePageContent(pageId, content),
    );
  }

  Future<void> _savePageStyle(String pageId) async {
    await ref
        .read(notebookRepositoryProvider)
        .updatePageStyle(pageId, _editorPreset, _editorFontSize);
  }

  Future<void> _createNotebook() async {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    final created = await showDialog<Notebook>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Notebook'),
          content: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: subtitleController,
                  decoration: const InputDecoration(
                    labelText: 'Subtitle (optional)',
                  ),
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
                final title = titleController.text.trim();
                if (title.isEmpty) {
                  return;
                }
                final notebook = await ref
                    .read(notebookRepositoryProvider)
                    .createNotebook(
                      title: title,
                      subtitle: subtitleController.text.trim(),
                    );
                if (context.mounted) {
                  Navigator.pop(context, notebook);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      titleController.dispose();
      subtitleController.dispose();
    });

    if (created != null) {
      setState(() {
        _selectedNotebookId = created.id;
      });
    }
  }

  Future<void> _addPage() async {
    final notebookId = _selectedNotebookId;
    if (notebookId == null) {
      return;
    }
    final page = await ref.read(notebookRepositoryProvider).addPage(notebookId);
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedPageId = page.id;
    });
  }

  Future<void> _shufflePages() async {
    final notebookId = _selectedNotebookId;
    if (notebookId == null) {
      return;
    }
    await ref.read(notebookRepositoryProvider).shufflePages(notebookId);
  }

  Future<void> _deleteSelectedPage(List<NotebookPage> pages) async {
    final selectedPageId = _selectedPageId;
    if (selectedPageId == null) {
      return;
    }
    await ref.read(notebookRepositoryProvider).deletePage(selectedPageId);
    if (!mounted) {
      return;
    }
    final remaining = pages
        .where((p) => p.id != selectedPageId)
        .toList(growable: false);
    setState(() {
      _selectedPageId = remaining.isEmpty
          ? null
          : remaining[max(0, remaining.length - 1)].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notebooksAsync = ref.watch(notebooksStreamProvider);

    return notebooksAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (error, stackTrace) =>
          const Center(child: Text('Failed to load notebooks.')),
      data: (notebooks) {
        _ensureNotebookSelection(notebooks);
        final selectedNotebook = notebooks
            .where((n) => n.id == _selectedNotebookId)
            .firstOrNull;

        final pagesAsync = selectedNotebook == null
            ? const AsyncValue<List<NotebookPage>>.data([])
            : ref.watch(notebookPagesStreamProvider(selectedNotebook.id));

        return pagesAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (error, stackTrace) =>
              const Center(child: Text('Failed to load notebook pages.')),
          data: (pages) {
            _ensurePageSelection(pages);
            final selectedPage = pages
                .where((p) => p.id == _selectedPageId)
                .firstOrNull;
            if (selectedPage != null) {
              _syncEditor(selectedPage);
            }

            final secondaryPanel = _NotebookSecondaryPanel(
              notebooks: notebooks,
              pages: pages,
              selectedNotebookId: _selectedNotebookId,
              selectedPageId: _selectedPageId,
              onCreateNotebook: _createNotebook,
              onSelectNotebook: (notebookId) {
                setState(() {
                  _selectedNotebookId = notebookId;
                  _selectedPageId = null;
                });
              },
              onAddPage: _addPage,
              onShufflePages: _shufflePages,
              onDeletePage: () => _deleteSelectedPage(pages),
              onSelectPage: (pageId) {
                setState(() {
                  _selectedPageId = pageId;
                });
              },
              onReorderPages: (orderedPageIds) => ref
                  .read(notebookRepositoryProvider)
                  .reorderPages(selectedNotebook!.id, orderedPageIds),
            );

            final primaryPanel = selectedPage == null
                ? const Center(
                    child: Text(
                      'Select or create a page to start writing.',
                      style: TextStyle(fontFamily: 'Consolas'),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CalligraphyToolbar(
                        preset: _editorPreset,
                        fontSize: _editorFontSize,
                        onPresetChanged: (preset) {
                          setState(() {
                            _editorPreset = preset;
                          });
                          _savePageStyle(selectedPage.id);
                        },
                        onFontSizeChanged: (size) {
                          setState(() {
                            _editorFontSize = size;
                          });
                        },
                        onFontSizeCommit: () => _savePageStyle(selectedPage.id),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: OutlinedPanel(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: _contentController,
                            onChanged: (value) {
                              final pageId = _selectedPageId;
                              if (pageId != null) {
                                _scheduleAutosave(pageId, value);
                              }
                            },
                            maxLines: null,
                            expands: true,
                            style: TextStyle(
                              fontFamily: _editorPreset.fontFamily,
                              fontSize: _editorFontSize,
                              height: 1.35,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Write your diary or notes here...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );

            return ResponsivePanelsScaffold(
              primary: primaryPanel,
              secondary: secondaryPanel,
              secondaryWidth: 370,
            );
          },
        );
      },
    );
  }
}

class _NotebookSecondaryPanel extends StatelessWidget {
  const _NotebookSecondaryPanel({
    required this.notebooks,
    required this.pages,
    required this.selectedNotebookId,
    required this.selectedPageId,
    required this.onCreateNotebook,
    required this.onSelectNotebook,
    required this.onAddPage,
    required this.onShufflePages,
    required this.onDeletePage,
    required this.onSelectPage,
    required this.onReorderPages,
  });

  final List<Notebook> notebooks;
  final List<NotebookPage> pages;
  final String? selectedNotebookId;
  final String? selectedPageId;
  final Future<void> Function() onCreateNotebook;
  final ValueChanged<String> onSelectNotebook;
  final Future<void> Function() onAddPage;
  final Future<void> Function() onShufflePages;
  final Future<void> Function() onDeletePage;
  final ValueChanged<String> onSelectPage;
  final Future<void> Function(List<String> orderedPageIds) onReorderPages;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: onCreateNotebook,
          child: const Text('New Notebook'),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: OutlinedPanel(
            padding: const EdgeInsets.all(8),
            backgroundColor: AppTheme.panel,
            child: notebooks.isEmpty
                ? const Center(
                    child: Text(
                      'No notebooks yet.',
                      style: TextStyle(fontFamily: 'Consolas'),
                    ),
                  )
                : ListView.separated(
                    itemCount: notebooks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final notebook = notebooks[index];
                      final selected = notebook.id == selectedNotebookId;
                      return InkWell(
                        onTap: () => onSelectNotebook(notebook.id),
                        borderRadius: AppTheme.borderRadiusSm,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selected ? AppTheme.paper : AppTheme.panel,
                            border: Border.all(color: AppTheme.ink, width: 1.6),
                            borderRadius: AppTheme.borderRadiusSm,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notebook.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (notebook.subtitle != null &&
                                  notebook.subtitle!.isNotEmpty)
                                Text(
                                  notebook.subtitle!,
                                  style: const TextStyle(
                                    fontFamily: 'Consolas',
                                    fontSize: 12,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat(
                                  'dd MMM yyyy',
                                ).format(notebook.createdAt),
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
        ),
        const SizedBox(height: 8),
        OutlinedPanel(
          padding: const EdgeInsets.all(8),
          backgroundColor: AppTheme.panel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedNotebookId == null ? null : onAddPage,
                      child: const Text('Add Page'),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: pages.length <= 1 ? null : onShufflePages,
                      child: const Text('Shuffle'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: selectedPageId == null ? null : onDeletePage,
                child: const Text('Delete Page'),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 240,
                child: pages.isEmpty
                    ? const Center(child: Text('No pages yet.'))
                    : ReorderableListView.builder(
                        itemCount: pages.length,
                        onReorder: (oldIndex, newIndex) async {
                          final updated = [...pages];
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final moved = updated.removeAt(oldIndex);
                          updated.insert(newIndex, moved);
                          await onReorderPages(
                            updated.map((p) => p.id).toList(growable: false),
                          );
                        },
                        itemBuilder: (context, index) {
                          final page = pages[index];
                          final selected = page.id == selectedPageId;
                          return ListTile(
                            key: ValueKey(page.id),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            title: Text('Page ${index + 1}'),
                            subtitle: Text(
                              page.content.replaceAll('\n', ' '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            tileColor: selected
                                ? AppTheme.paper
                                : AppTheme.panel,
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppTheme.borderRadiusSm,
                              side: BorderSide(color: AppTheme.ink, width: 1.4),
                            ),
                            onTap: () => onSelectPage(page.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalligraphyToolbar extends StatelessWidget {
  const _CalligraphyToolbar({
    required this.preset,
    required this.fontSize,
    required this.onPresetChanged,
    required this.onFontSizeChanged,
    required this.onFontSizeCommit,
  });

  final EditorFontPreset preset;
  final double fontSize;
  final ValueChanged<EditorFontPreset> onPresetChanged;
  final ValueChanged<double> onFontSizeChanged;
  final VoidCallback onFontSizeCommit;

  @override
  Widget build(BuildContext context) {
    return OutlinedPanel(
      padding: const EdgeInsets.all(8),
      backgroundColor: AppTheme.panel,
      borderWidth: 1.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calligraphy',
            style: TextStyle(
              fontFamily: 'Consolas',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<EditorFontPreset>(
                  key: ValueKey('preset-${preset.name}'),
                  initialValue: preset,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Font preset'),
                  items: [
                    for (final item in EditorFontPreset.values)
                      DropdownMenuItem(value: item, child: Text(item.label)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onPresetChanged(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  final next = (fontSize - 1).clamp(12, 30).toDouble();
                  onFontSizeChanged(next);
                  onFontSizeCommit();
                },
                child: const Text('-'),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 60,
                child: Text(
                  '${fontSize.round()} px',
                  style: const TextStyle(fontFamily: 'Consolas'),
                ),
              ),
              const SizedBox(width: 6),
              OutlinedButton(
                onPressed: () {
                  final next = (fontSize + 1).clamp(12, 30).toDouble();
                  onFontSizeChanged(next);
                  onFontSizeCommit();
                },
                child: const Text('+'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.ink,
                    inactiveTrackColor: AppTheme.muted,
                    thumbColor: AppTheme.ink,
                    overlayColor: AppTheme.ink.withValues(alpha: 0.1),
                    trackShape: const RectangularSliderTrackShape(),
                  ),
                  child: Slider(
                    min: 12,
                    max: 30,
                    value: fontSize.clamp(12, 30).toDouble(),
                    divisions: 18,
                    label: '${fontSize.round()}',
                    onChanged: onFontSizeChanged,
                    onChangeEnd: (_) => onFontSizeCommit(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
