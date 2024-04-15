import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CircularTimerPainter extends CustomPainter {
  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;

  // Canvas.drawArc(r, 0, 2*PI) doesn't draw anything, so just get close.
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  final Gradient valueGradient;
  final double? value;
  final double strokeWidth;
  final double strokeAlign;
  final double arcStart;
  final double arcSweep;
  final Color? backgroundColor;
  final StrokeCap? strokeCap;

  CircularTimerPainter({
    required this.valueGradient,
    required this.value,
    required this.strokeWidth,
    required this.strokeAlign,
    this.backgroundColor,
    this.strokeCap,
    double tailValue = 0.0,
    double headValue = 1.0,
    double offsetValue = 0.0,
    double rotationValue = 0.0,
  })  : arcStart = value != null ? _startAngle : _startAngle + tailValue * 3 / 2 * math.pi + rotationValue * math.pi * 2.0 + offsetValue * 0.5 * math.pi,
        arcSweep = value != null ? clampDouble(value, 0.0, 1.0) * _sweep : math.max(headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi, _epsilon);

  @override
  void paint(Canvas canvas, Size size) {
    // Use the negative operator as intended to keep the exposed constant value
    // as users are already familiar with.
    double strokeOffset = strokeWidth / 2 * -strokeAlign;
    Offset arcBaseOffset = Offset(strokeOffset, strokeOffset);
    Size arcActualSize = Size(
      size.width - strokeOffset * 2,
      size.height - strokeOffset * 2,
    );

    Rect arcRect = arcBaseOffset & arcActualSize;
    Paint paint = _getPaint(arcRect);

    if (backgroundColor != null) {
      Paint backgroundPaint = Paint()
        ..color = backgroundColor!
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawArc(
        arcRect,
        0,
        _sweep,
        false,
        backgroundPaint,
      );
    }

    if (value == null && strokeCap == null) {
      // Indeterminate
      paint.strokeCap = StrokeCap.square;
    } else {
      // Butt when determinate (value != null) && strokeCap == null;
      paint.strokeCap = strokeCap ?? StrokeCap.butt;
    }

    canvas.drawArc(arcRect, arcStart, arcSweep, false, paint);
  }

  Paint _getPaint(Rect rect) {
    return Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = valueGradient.createShader(rect);
  }

  @override
  bool shouldRepaint(CircularTimerPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.valueGradient != valueGradient ||
        oldDelegate.value != value ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.strokeAlign != strokeAlign ||
        oldDelegate.strokeCap != strokeCap;
  }
}
