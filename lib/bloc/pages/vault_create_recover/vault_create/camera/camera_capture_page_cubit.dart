import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/camera/camera_capture_page_state.dart';

class CameraCapturePageCubit extends Cubit<CameraCapturePageState> {
  late final CameraController _cameraController;

  CameraCapturePageCubit() : super(CameraInitial());

  void dispose() {
    _cameraController.dispose();
    close();
  }

  Future<void> initializeCamera() async {
    emit(CameraLoading());
    try {
      List<CameraDescription> cameras = await availableCameras();
      _cameraController = CameraController(cameras.first, ResolutionPreset.max);
      await _cameraController.initialize();
      emit(CameraReady(_cameraController));
    } catch (e) {
      emit(CameraError(e.toString()));
    }
  }

  Future<void> generateEntropy() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }

    try {
      XFile image = await _cameraController.takePicture();
      Uint8List imageBytes = await image.readAsBytes();

      EntropyGenerator entropyGenerator = EntropyGenerator(imageBytes);
      Uint8List generatedEntropy = entropyGenerator.entropy;
      
      emit(CameraEntropyGenerated(generatedEntropy));
    } catch (e) {
      emit(CameraError('Capture failed: $e'));
    }
  }
}
