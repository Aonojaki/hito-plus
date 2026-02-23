import 'package:flutter/material.dart';

import '../../app/theme.dart';

class OutlinedPanel extends StatelessWidget {
  const OutlinedPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.backgroundColor = AppTheme.paper,
    this.borderWidth = 2,
    this.borderRadius = AppTheme.borderRadiusMd,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final double borderWidth;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: AppTheme.ink, width: borderWidth),
        borderRadius: borderRadius,
      ),
      padding: padding,
      child: child,
    );
  }
}
