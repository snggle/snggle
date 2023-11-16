import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraFlashlightButton extends StatelessWidget {
  final MobileScannerController cameraController;

  const CameraFlashlightButton({required this.cameraController, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        color: Colors.white,
        icon: ValueListenableBuilder<TorchState>(
          valueListenable: cameraController.torchState,
          builder: (BuildContext context, TorchState torchState, _) {
            return torchState == TorchState.off ? const Icon(Icons.flash_off) : const Icon(Icons.flash_on);
          },
        ),
        onPressed: cameraController.toggleTorch);
  }
}
