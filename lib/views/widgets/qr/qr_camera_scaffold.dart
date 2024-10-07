import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:snggle/bloc/widgets/qr/qr_camera_scaffold_cubit/qr_camera_scaffold_cubit.dart';
import 'package:snggle/bloc/widgets/qr/qr_camera_scaffold_cubit/states/a_qr_camera_scaffold_state.dart';
import 'package:snggle/bloc/widgets/qr/qr_camera_scaffold_cubit/states/qr_camera_scaffold_loaded_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/qr/qr_area_clipper.dart';
import 'package:snggle/views/widgets/qr/qr_area_painter.dart';
import 'package:snggle/views/widgets/qr/qr_camera_indicator.dart';
import 'package:snggle/views/widgets/qr/qr_camera_tooltip.dart';

class QRCameraScaffold extends StatefulWidget {
  final String title;
  final ValueNotifier<double> progressNotifier;
  final ValueChanged<Barcode> onQRScanned;
  final bool closeButtonVisible;
  final bool popButtonVisible;
  final VoidCallback? customPopCallback;
  final List<Widget>? actions;

  const QRCameraScaffold({
    required this.title,
    required this.progressNotifier,
    required this.onQRScanned,
    this.closeButtonVisible = false,
    this.popButtonVisible = true,
    this.customPopCallback,
    this.actions,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _QRCameraScaffoldState();
}

class _QRCameraScaffoldState extends State<QRCameraScaffold> {
  final GlobalKey qrCameraKey = GlobalKey(debugLabel: 'QR');
  final QRCameraScaffoldCubit qrCameraScaffoldCubit = QRCameraScaffoldCubit();
  QRViewController? qrViewController;

  @override
  void dispose() {
    qrViewController?.dispose();
    qrCameraScaffoldCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRCameraScaffoldCubit, AQRCameraScaffoldState>(
      bloc: qrCameraScaffoldCubit,
      builder: (BuildContext context, AQRCameraScaffoldState qrCameraScaffoldState) {
        bool loadedBool = qrCameraScaffoldState is QRCameraScaffoldLoadedState;
        bool permissionGrantedBool = false;

        if (qrCameraScaffoldState is QRCameraScaffoldLoadedState) {
          permissionGrantedBool = qrCameraScaffoldState.permissionsGrantedBool;
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: <Widget>[
              if (loadedBool && permissionGrantedBool)
                Positioned.fill(
                  child: QRView(
                    key: qrCameraKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              Positioned.fill(
                child: Column(
                  children: <Widget>[
                    Container(height: 80, color: Colors.black),
                    const Spacer(),
                    Container(height: 80, color: Colors.black),
                  ],
                ),
              ),
              Positioned.fill(
                child: ClipPath(
                  clipper: QRAreaClipper(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: AppColors.body1.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: QRCameraTooltip(
                          toggleFlashCallback: _toggleFlash,
                          flipCameraCallback: _flipCamera,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxWidth,
                          child: const CustomPaint(
                            painter: QRAreaPainter(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(height: 100, child: QRCameraIndicator(progressNotifier: widget.progressNotifier)),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: CustomAppBar(
                    title: widget.title,
                    actions: widget.actions,
                    closeButtonVisible: widget.closeButtonVisible,
                    popButtonVisible: widget.popButtonVisible,
                    customPopCallback: widget.customPopCallback,
                    foregroundColor: AppColors.body2,
                  ),
                ),
              ),
              if (loadedBool && permissionGrantedBool == false)
                CustomDialog(
                  backgroundColor: AppColors.body2.withOpacity(1),
                  title: 'Allow camera',
                  content: const Text(
                    'In order to scan QR, you need to allow the camera permission',
                    textAlign: TextAlign.center,
                  ),
                  options: <CustomDialogOption>[
                    CustomDialogOption(
                      autoCloseBool: false,
                      label: 'Back',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const CustomDialogOption(
                      label: 'Settings',
                      onPressed: openAppSettings,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController qrViewController) {
    this.qrViewController = qrViewController;
    qrViewController.scannedDataStream.listen(widget.onQRScanned);
  }

  Future<void> _flipCamera() async {
    await qrViewController?.flipCamera();
  }

  Future<void> _toggleFlash() async {
    await qrViewController?.toggleFlash();
  }
}
