import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snggle/bloc/widgets/scan_icon_cubit/scan_icon_state.dart';

class ScanIconCubit extends Cubit<ScanIconState> {
  bool initializedBool = false;

  ScanIconCubit() : super(ScanIconState(initialCameraPermissionStatus: PermissionStatus.denied));

  Future<void> init() async {
    if (initializedBool == false) {
      PermissionStatus cameraPermissionStatus = await Permission.camera.status;
      emit(ScanIconState(initialCameraPermissionStatus: cameraPermissionStatus));
      initializedBool = true;
    }
  }

  void assignPermission(PermissionStatus permissionStatus) {
    emit(ScanIconState(
      initialCameraPermissionStatus: state.initialCameraPermissionStatus,
      assignedCameraPermissionStatus: permissionStatus,
    ));
  }
}
