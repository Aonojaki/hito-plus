import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/providers.dart';
import '../core/widgets/outlined_panel.dart';
import '../core/widgets/sketch_divider.dart';
import 'navigation.dart';
import 'theme.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.currentPath, required this.child});

  final String currentPath;
  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with WidgetsBindingObserver {
  String? _previousSectionPath;

  void _clearScrapperDeferred() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(scrapperSessionProvider.notifier).clear();
    });
  }

  AppSection? _sectionForPath(String path) {
    for (final section in appSections) {
      if (path.startsWith(section.path)) {
        return section;
      }
    }
    return null;
  }

  void _goToPreviousSection() {
    final previousPath = _previousSectionPath;
    if (previousPath == null) {
      return;
    }
    final currentSection = _sectionForPath(widget.currentPath);
    if (currentSection == null || currentSection.path == previousPath) {
      return;
    }
    context.go(previousPath);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldSection = _sectionForPath(oldWidget.currentPath);
    final newSection = _sectionForPath(widget.currentPath);
    if (oldSection != null &&
        newSection != null &&
        oldSection.path != newSection.path) {
      _previousSectionPath = oldSection.path;
    }

    final wasScrapper = oldWidget.currentPath.startsWith('/scrapper');
    final isNowScrapper = widget.currentPath.startsWith('/scrapper');

    if (wasScrapper && !isNowScrapper) {
      _clearScrapperDeferred();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _clearScrapperDeferred();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nowLabel = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());
    final currentSection = _sectionForPath(widget.currentPath);
    final previousSection = _sectionForPath(_previousSectionPath ?? '');
    final canGoBack =
        previousSection != null && previousSection.path != currentSection?.path;

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true):
            _BackSectionIntent(),
      },
      child: Actions(
        actions: {
          _BackSectionIntent: CallbackAction<_BackSectionIntent>(
            onInvoke: (_) {
              if (canGoBack) {
                _goToPreviousSection();
              }
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            body: Row(
              children: [
                Container(
                  width: 132,
                  decoration: const BoxDecoration(
                    color: AppTheme.panel,
                    border: Border(
                      right: BorderSide(color: AppTheme.ink, width: 2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 114,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppTheme.paper,
                          border: Border(
                            bottom: BorderSide(color: AppTheme.ink, width: 2),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'HITO\nPLUS',
                            style: TextStyle(
                              fontFamily: 'Consolas',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final section in appSections)
                        _NavButton(
                          section: section,
                          isActive: widget.currentPath.startsWith(section.path),
                          onTap: () => context.go(section.path),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 44,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppTheme.paper,
                          border: Border(
                            bottom: BorderSide(color: AppTheme.ink, width: 2),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          children: [
                            if (canGoBack)
                              OutlinedButton(
                                onPressed: _goToPreviousSection,
                                child: Text(
                                  'Back: ${previousSection.shortLabel}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            if (canGoBack) const SizedBox(width: 10),
                            const Text(
                              'Hito+',
                              style: TextStyle(
                                fontFamily: 'Consolas',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              nowLabel,
                              style: const TextStyle(
                                fontFamily: 'Consolas',
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SketchDivider(height: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                          child: OutlinedPanel(
                            padding: const EdgeInsets.all(12),
                            borderWidth: 2.4,
                            child: TweenAnimationBuilder<double>(
                              key: ValueKey(widget.currentPath),
                              tween: Tween(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset((1 - value) * 16, 0),
                                    child: child,
                                  ),
                                );
                              },
                              child: widget.child,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.section,
    required this.isActive,
    required this.onTap,
  });

  final AppSection section;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: InkWell(
        borderRadius: AppTheme.borderRadiusMd,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.paper : AppTheme.panel,
            border: Border.all(color: AppTheme.ink, width: 2),
            borderRadius: AppTheme.borderRadiusMd,
          ),
          child: Text(
            section.shortLabel,
            style: TextStyle(
              fontFamily: 'Consolas',
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackSectionIntent extends Intent {
  const _BackSectionIntent();
}
