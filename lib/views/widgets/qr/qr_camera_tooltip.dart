import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:sprung/sprung.dart';

class QRCameraTooltip extends StatefulWidget {
  final Future<void> Function()? flipCameraCallback;
  final Future<void> Function()? toggleFlashCallback;

  const QRCameraTooltip({
    required this.flipCameraCallback,
    required this.toggleFlashCallback,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _QRCameraTooltipState();
}

class _QRCameraTooltipState extends State<QRCameraTooltip> {
  double flipCameraIconRotation = 0.0;
  bool flipCameraInProgressBool = false;
  bool toggleFlashInProgressBool = false;
  bool toggleFlashEnabledBool = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.body2.withOpacity(0.11),
        border: Border.all(color: AppColors.body2.withOpacity(0.06)),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: _flipCamera,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
              child: AnimatedRotation(
                turns: flipCameraIconRotation,
                duration: const Duration(milliseconds: 300),
                curve: Sprung.custom(mass: 1, stiffness: 50, damping: 15),
                child: AssetIcon(AppIcons.camera_reverse, color: AppColors.body2, size: 20.5),
              ),
            ),
          ),
          VerticalDivider(color: AppColors.body2.withOpacity(0.06)),
          GestureDetector(
            onTap: _toggleFlash,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
              child: AssetIcon(AppIcons.camera_flash, color: toggleFlashEnabledBool ? null : AppColors.body2, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _flipCamera() async {
    if (flipCameraInProgressBool) {
      return;
    }
    flipCameraInProgressBool = true;
    await widget.flipCameraCallback?.call();
    setState(() {
      flipCameraIconRotation += 180 / 360;
    });
    flipCameraInProgressBool = false;
  }

  Future<void> _toggleFlash() async {
    if (toggleFlashInProgressBool) {
      return;
    }
    setState(() {
      toggleFlashEnabledBool = toggleFlashEnabledBool == false;
    });
    toggleFlashInProgressBool = true;
    await widget.toggleFlashCallback?.call();
    toggleFlashInProgressBool = false;
  }
}
