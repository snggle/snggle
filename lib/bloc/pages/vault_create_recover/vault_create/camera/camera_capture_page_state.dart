import 'dart:typed_data';
import 'package:camera/camera.dart';

abstract class CameraCapturePageState {}

class CameraInitial extends CameraCapturePageState {}

class CameraLoading extends CameraCapturePageState {}

class CameraReady extends CameraCapturePageState {
  CameraController controller;

  CameraReady(this.controller);
}

class CameraEntropyGenerated extends CameraCapturePageState {
  Uint8List entropy;

  CameraEntropyGenerated(this.entropy);
}

class CameraError extends CameraCapturePageState {
  String message;

  CameraError(this.message);
}
