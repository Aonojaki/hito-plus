import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/providers.dart';
import '../../core/widgets/outlined_panel.dart';

class ScrapperScreen extends ConsumerStatefulWidget {
  const ScrapperScreen({super.key});

  @override
  ConsumerState<ScrapperScreen> createState() => _ScrapperScreenState();
}

class _ScrapperScreenState extends ConsumerState<ScrapperScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(scrapperSessionProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionText = ref.watch(scrapperSessionProvider);

    if (_controller.text != sessionText) {
      _controller.value = TextEditingValue(
        text: sessionText,
        selection: TextSelection.collapsed(offset: sessionText.length),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OutlinedPanel(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          backgroundColor: AppTheme.panel,
          borderWidth: 1.8,
          child: Text(
            'This text is temporary and will be deleted when you leave this section or close the app.',
            style: TextStyle(
              fontFamily: 'Consolas',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: OutlinedPanel(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _controller,
              onChanged: (value) =>
                  ref.read(scrapperSessionProvider.notifier).setText(value),
              maxLines: null,
              expands: true,
              style: const TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                hintText: 'Vent freely here. This will not be stored.',
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
  }
}
