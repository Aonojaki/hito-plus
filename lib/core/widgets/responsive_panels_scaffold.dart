import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'outlined_panel.dart';

class ResponsivePanelsScaffold extends StatefulWidget {
  const ResponsivePanelsScaffold({
    super.key,
    required this.primary,
    required this.secondary,
    this.breakpoint = 1200,
    this.secondaryWidth = 360,
    this.panelsButtonLabel = 'Panels',
  });

  final Widget primary;
  final Widget secondary;
  final double breakpoint;
  final double secondaryWidth;
  final String panelsButtonLabel;

  @override
  State<ResponsivePanelsScaffold> createState() =>
      _ResponsivePanelsScaffoldState();
}

class _ResponsivePanelsScaffoldState extends State<ResponsivePanelsScaffold> {
  bool _secondaryVisible = false;

  void _toggleSecondary() {
    setState(() {
      _secondaryVisible = !_secondaryVisible;
    });
  }

  void _hideSecondary() {
    if (_secondaryVisible) {
      setState(() {
        _secondaryVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= widget.breakpoint;

        if (isWide) {
          if (_secondaryVisible) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _hideSecondary();
              }
            });
          }
          return Row(
            children: [
              Expanded(child: widget.primary),
              const SizedBox(width: 10),
              SizedBox(width: widget.secondaryWidth, child: widget.secondary),
            ],
          );
        }

        final panelWidth = min(
          widget.secondaryWidth,
          constraints.maxWidth * 0.86,
        ).clamp(280, 520).toDouble();

        return Stack(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: _toggleSecondary,
                    child: Text(widget.panelsButtonLabel),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(child: widget.primary),
              ],
            ),
            if (_secondaryVisible)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _hideSecondary,
                  child: ColoredBox(
                    color: AppTheme.ink.withValues(alpha: 0.08),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          width: panelWidth,
                          child: OutlinedPanel(
                            padding: const EdgeInsets.all(8),
                            backgroundColor: AppTheme.panel,
                            borderWidth: 2,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppTheme.radiusLg),
                              bottomLeft: Radius.circular(AppTheme.radiusLg),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Panels',
                                      style: TextStyle(
                                        fontFamily: 'Consolas',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    OutlinedButton(
                                      onPressed: _hideSecondary,
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Expanded(child: widget.secondary),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
