import 'package:snggle/bloc/widgets/qr/qr_camera_scaffold_cubit/states/a_qr_camera_scaffold_state.dart';

class QRCameraScaffoldLoadedState extends AQRCameraScaffoldState {
  final bool permissionsGrantedBool;

  QRCameraScaffoldLoadedState({required this.permissionsGrantedBool});

  @override
  List<Object?> get props => <Object>[permissionsGrantedBool];
}
