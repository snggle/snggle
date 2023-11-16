import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:snggle/bloc/qr_code_scan_page/qr_code_scan_page_cubit.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_received_state.dart';
import 'package:snggle/shared/utils/file_utils.dart';
import 'package:snggle/views/widgets/app_fps.dart';
import 'package:snggle/views/widgets/qr_code_scan/camera_facing_icon_button.dart';
import 'package:snggle/views/widgets/qr_code_scan/camera_flash_light_button.dart';
import 'package:snggle/views/widgets/qr_code_scan/camera_scanned_frame_icon.dart';

class MultiQrCodeScanner extends StatelessWidget {
  final int height;
  final bool advancedCameraStats;
  final MobileScannerController cameraController;
  final AQrCodeScanPageState qrcodeScanPageState;
  final ValueChanged<Barcode> receiveQRCodeCallback;

  const MultiQrCodeScanner({
    required this.cameraController,
    required this.receiveQRCodeCallback,
    required this.qrcodeScanPageState,
    this.height = 400,
    this.advancedCameraStats = true,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrCodeScanPageCubit, AQrCodeScanPageState>(
      builder: (BuildContext context, AQrCodeScanPageState aQrCodeScanPageState) {
        return SizedBox(
          height: 400,
          child: Stack(
            children: <Widget>[
              MobileScanner(
                allowDuplicates: true,
                controller: cameraController,
                onDetect: (Barcode barcode, MobileScannerArguments? args) => receiveQRCodeCallback(barcode),
              ),
              Visibility(
                visible: advancedCameraStats,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(5.0),
                          child: const AppFps(),
                        ),
                        Row(
                          children: <Widget>[
                            CameraScannedFrameIcon(qrcodeScanPageState: qrcodeScanPageState),
                            CameraFacingIconButton(cameraController: cameraController),
                            CameraFlashlightButton(cameraController: cameraController),
                          ],
                        )
                      ],
                    ),
                    if (aQrCodeScanPageState is QrCodeScanPageReceivedState)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Text('${aQrCodeScanPageState.scannedPagesCount}/${aQrCodeScanPageState.multiQrCodeItemModelList[0].maxPages}'),
                          ),
                          Container(
                            color: Colors.white,
                            child: Text(aQrCodeScanPageState.estimatedDataTransferRate.isInfinite ? '' : '${FileUtils.estimateDataSize(aQrCodeScanPageState.estimatedDataTransferRate.toInt())}/s'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
