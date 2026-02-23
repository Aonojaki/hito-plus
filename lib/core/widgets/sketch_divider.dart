import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/theme.dart';

class SketchDivider extends StatelessWidget {
  const SketchDivider({super.key, this.height = 10});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(painter: _SketchDividerPainter()),
    );
  }
}

class _SketchDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppTheme.ink;

    final path = Path()..moveTo(0, size.height / 2);
    for (var x = 4.0; x <= size.width; x += 8) {
      final jitter = random.nextDouble() * 2 - 1;
      path.lineTo(x, size.height / 2 + jitter);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
