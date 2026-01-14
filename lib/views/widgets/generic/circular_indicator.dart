import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class CircularIndicator extends StatelessWidget {
  final int remainingSeconds;
  final int period;

  const CircularIndicator({
    required this.remainingSeconds,
    required this.period,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = period <= 0 ? 0 : remainingSeconds / period;

    return SizedBox(
      width: 28,
      height: 28,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: progress, end: progress),
        duration: const Duration(milliseconds: 250),
        builder: (BuildContext context, double animatedProgress, _) {
          return CustomPaint(
            painter: _CircularIndicatorPainter(progress: animatedProgress),
            child: Center(
              child: Text(
                '$remainingSeconds',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.body3,
                      //fontSize: 9,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CircularIndicatorPainter extends CustomPainter {
  final double progress;

  const _CircularIndicatorPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = size.center(Offset.zero);
    double strokeWidth = 2.2;
    double radius = (size.width - strokeWidth) / 2;

    Paint backgroundPaint = Paint()
      ..color = AppColors.lightGrey2
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Rect rect = Rect.fromCircle(center: center, radius: radius);

    Paint progressPaint = Paint()
      ..shader = AppColors.warningOrangeGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    double sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularIndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
