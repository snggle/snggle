import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class QRCameraIndicator extends StatelessWidget {
  final ValueNotifier<double> progressNotifier;

  const QRCameraIndicator({
    required this.progressNotifier,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: progressNotifier,
      builder: (BuildContext context, double progress, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(31),
                child: Container(
                  height: 5,
                  width: double.infinity,
                  color: AppColors.body2.withOpacity(0.2),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      if (progress == 0) {
                        return const SizedBox();
                      }
                      double width = constraints.maxWidth;
                      double progressWidth = width * progress;

                      return Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: progressWidth,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: <Color>[
                                Color(0xFF939393),
                                Color(0xFF42D2FF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${progress == 0 ? 0 : (progress * 100).toStringAsPrecision(4)}%',
                style: TextStyle(color: AppColors.body2, fontSize: 12),
              )
            ],
          ),
        );
      },
    );
  }
}
