import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/generic/circular_timer/circular_timer_painter.dart';

class CircularTimer extends StatelessWidget {
  final int currentValue;
  final int initialValue;
  final double size;
  final double strokeWidth;
  final double strokeAlign;

  const CircularTimer({
    required this.currentValue,
    required this.initialValue,
    this.size = 28,
    this.strokeWidth = 1.33,
    this.strokeAlign = 0.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: CircularTimerPainter(
                valueGradient: AppColors.validationGradient,
                value: currentValue / initialValue,
                strokeWidth: strokeWidth,
                strokeAlign: strokeAlign,
                backgroundColor: AppColors.lightGrey2,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                currentValue < 10 ? '0$currentValue' : '$currentValue',
                style: TextStyle(
                  color: AppColors.body3,
                  fontSize: 14,
                  letterSpacing: -1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
