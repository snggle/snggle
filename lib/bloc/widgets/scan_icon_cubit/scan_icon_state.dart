import 'package:permission_handler/permission_handler.dart';

class ScanIconState {
  final PermissionStatus initialCameraPermissionStatus;
  final PermissionStatus? assignedCameraPermissionStatus;

  ScanIconState({required this.initialCameraPermissionStatus, this.assignedCameraPermissionStatus});
}
