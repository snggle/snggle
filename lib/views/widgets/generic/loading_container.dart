import 'package:flutter/cupertino.dart';
import 'package:snggle/config/app_colors.dart';

class LoadingContainer extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const LoadingContainer({
    this.width = double.infinity,
    this.height = double.infinity,
    this.radius = 26,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.middleGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
