import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraFacingIconButton extends StatelessWidget {
  final MobileScannerController cameraController;

  const CameraFacingIconButton({
    required this.cameraController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        color: Colors.white,
        icon: ValueListenableBuilder<CameraFacing>(
          valueListenable: cameraController.cameraFacingState,
          builder: (BuildContext context, CameraFacing cameraFacing, _) {
            return cameraFacing == CameraFacing.front ? const Icon(Icons.camera_front) : const Icon(Icons.camera_rear);
          },
        ),
        onPressed: cameraController.switchCamera);
  }
}
