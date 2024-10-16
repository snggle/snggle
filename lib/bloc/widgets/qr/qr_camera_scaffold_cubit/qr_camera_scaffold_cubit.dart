import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snggle/bloc/widgets/qr/qr_camera_scaffold_cubit/states/a_qr_camera_scaffold_state.dart';
import 'package:snggle/bloc/widgets/qr/qr_camera_scaffold_cubit/states/qr_camera_scaffold_loaded_state.dart';
import 'package:snggle/bloc/widgets/qr/qr_camera_scaffold_cubit/states/qr_camera_scaffold_loading_state.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';

class QRCameraScaffoldCubit extends Cubit<AQRCameraScaffoldState> {
  QRCameraScaffoldCubit() : super(QRCameraScaffoldLoadingState()) {
    validatePermissions();
  }

  Future<void> validatePermissions() async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;
    if (cameraPermissionStatus.isGranted) {
      emit(QRCameraScaffoldLoadedState(permissionsGrantedBool: true));
    } else if (cameraPermissionStatus.isDenied) {
      await _requestPermissions();
    } else if (cameraPermissionStatus.isPermanentlyDenied) {
      emit(QRCameraScaffoldLoadedState(permissionsGrantedBool: false));
    } else {
      AppLogger().log(message: 'Invalid permission status: $cameraPermissionStatus');
    }
  }

  Future<void> _requestPermissions() async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.request();
    if (cameraPermissionStatus.isGranted) {
      emit(QRCameraScaffoldLoadedState(permissionsGrantedBool: true));
    } else {
      emit(QRCameraScaffoldLoadedState(permissionsGrantedBool: false));
    }
  }
}
