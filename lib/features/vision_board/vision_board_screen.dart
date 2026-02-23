import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/models/entities.dart';
import '../../core/providers.dart';
import '../../core/widgets/outlined_panel.dart';

final visionItemsStreamProvider = StreamProvider<List<VisionBoardItem>>(
  (ref) => ref.watch(visionBoardRepositoryProvider).watchItems(),
);

class VisionBoardScreen extends ConsumerStatefulWidget {
  const VisionBoardScreen({super.key});

  @override
  ConsumerState<VisionBoardScreen> createState() => _VisionBoardScreenState();
}

class _VisionBoardScreenState extends ConsumerState<VisionBoardScreen> {
  static const double _canvasWidth = 1800;
  static const double _canvasHeight = 1000;

  Future<void> _persist(VisionBoardItem item) async {
    await ref.read(visionBoardRepositoryProvider).upsertItem(item);
  }

  Future<void> _addTextCard() async {
    await ref.read(visionBoardRepositoryProvider).addTextItem();
  }

  Future<void> _addImageCard() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null ||
        result.files.isEmpty ||
        result.files.single.path == null) {
      return;
    }

    final originalPath = result.files.single.path!;
    final copiedPath = await ref
        .read(imageStorageServiceProvider)
        .copyImageToAppData(originalPath);
    await ref.read(visionBoardRepositoryProvider).addImageItem(copiedPath);
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(visionItemsStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: _addTextCard,
              child: const Text('Add Text Card'),
            ),
            ElevatedButton(
              onPressed: _addImageCard,
              child: const Text('Add Image Card'),
            ),
            const Text(
              'Drag title bar to move. Drag bottom-right square to resize.',
              style: TextStyle(fontFamily: 'Consolas'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: itemsAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (error, stackTrace) =>
                const Center(child: Text('Failed to load vision board items.')),
            data: (items) {
              return OutlinedPanel(
                padding: const EdgeInsets.all(8),
                backgroundColor: AppTheme.panel,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: _canvasWidth,
                        height: _canvasHeight,
                        child: Stack(
                          children: [
                            for (final item in items)
                              _VisionItemCard(
                                key: ValueKey(item.id),
                                item: item,
                                canvasWidth: _canvasWidth,
                                canvasHeight: _canvasHeight,
                                onCommit: _persist,
                                onDelete: () async {
                                  await ref
                                      .read(visionBoardRepositoryProvider)
                                      .deleteItem(item.id);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _VisionItemCard extends StatefulWidget {
  const _VisionItemCard({
    super.key,
    required this.item,
    required this.canvasWidth,
    required this.canvasHeight,
    required this.onCommit,
    required this.onDelete,
  });

  final VisionBoardItem item;
  final double canvasWidth;
  final double canvasHeight;
  final ValueChanged<VisionBoardItem> onCommit;
  final VoidCallback onDelete;

  @override
  State<_VisionItemCard> createState() => _VisionItemCardState();
}

class _VisionItemCardState extends State<_VisionItemCard> {
  static const Duration _commitDebounceDuration = Duration(milliseconds: 320);

  late VisionBoardItem _liveItem;
  Timer? _commitDebounce;

  @override
  void initState() {
    super.initState();
    _liveItem = widget.item;
  }

  @override
  void didUpdateWidget(covariant _VisionItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      _liveItem = widget.item;
    }
  }

  @override
  void dispose() {
    if (_commitDebounce?.isActive ?? false) {
      widget.onCommit(_liveItem);
    }
    _commitDebounce?.cancel();
    super.dispose();
  }

  VisionBoardItem _clampItem(VisionBoardItem item) {
    final clampedWidth = item.width.clamp(120, widget.canvasWidth).toDouble();
    final clampedHeight = item.height.clamp(90, widget.canvasHeight).toDouble();
    final clampedX = item.x
        .clamp(0, widget.canvasWidth - clampedWidth)
        .toDouble();
    final clampedY = item.y
        .clamp(0, widget.canvasHeight - clampedHeight)
        .toDouble();

    return item.copyWith(
      width: clampedWidth,
      height: clampedHeight,
      x: clampedX,
      y: clampedY,
    );
  }

  void _scheduleCommit() {
    _commitDebounce?.cancel();
    _commitDebounce = Timer(_commitDebounceDuration, () {
      widget.onCommit(_liveItem);
    });
  }

  void _commitNow() {
    _commitDebounce?.cancel();
    widget.onCommit(_liveItem);
  }

  void _move(DragUpdateDetails details) {
    final next = _clampItem(
      _liveItem.copyWith(
        x: _liveItem.x + details.delta.dx,
        y: _liveItem.y + details.delta.dy,
      ),
    );
    setState(() {
      _liveItem = next;
    });
  }

  void _resize(DragUpdateDetails details) {
    final next = _clampItem(
      _liveItem.copyWith(
        width: _liveItem.width + details.delta.dx,
        height: _liveItem.height + details.delta.dy,
      ),
    );
    setState(() {
      _liveItem = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _liveItem.x,
      top: _liveItem.y,
      child: SizedBox(
        width: _liveItem.width,
        height: _liveItem.height,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.paper,
            border: Border.all(color: AppTheme.ink, width: 1.8),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onPanUpdate: _move,
                    onPanEnd: (_) => _commitNow(),
                    child: Container(
                      color: AppTheme.ink,
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Text(
                            _liveItem.type == VisionItemType.text
                                ? 'TEXT'
                                : 'IMAGE',
                            style: const TextStyle(
                              color: AppTheme.paper,
                              fontFamily: 'Consolas',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: widget.onDelete,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              child: Text(
                                'X',
                                style: TextStyle(
                                  color: AppTheme.paper,
                                  fontFamily: 'Consolas',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _liveItem.type == VisionItemType.text
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              key: ValueKey('txt-${_liveItem.id}'),
                              initialValue: _liveItem.text ?? '',
                              onChanged: (value) {
                                setState(() {
                                  _liveItem = _liveItem.copyWith(text: value);
                                });
                                _scheduleCommit();
                              },
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                              ),
                            ),
                          )
                        : _ImageTile(path: _liveItem.imagePath),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onPanUpdate: _resize,
                  onPanEnd: (_) => _commitNow(),
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: AppTheme.ink,
                      border: Border(
                        top: BorderSide(color: AppTheme.paper, width: 1),
                        left: BorderSide(color: AppTheme.paper, width: 1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    if (path == null || path!.isEmpty) {
      return const Center(
        child: Text('No image', style: TextStyle(fontFamily: 'Consolas')),
      );
    }

    final file = File(path!);
    if (!file.existsSync()) {
      return const Center(
        child: Text(
          'Image missing',
          style: TextStyle(fontFamily: 'Consolas', fontWeight: FontWeight.bold),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Image.file(file, fit: BoxFit.cover),
    );
  }
}
