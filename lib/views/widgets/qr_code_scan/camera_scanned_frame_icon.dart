import 'package:flutter/material.dart';
import 'package:snggle/bloc/qr_code_scan_page/qr_code_scan_page_cubit.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_received_state.dart';

class CameraScannedFrameIcon extends StatelessWidget {
  final AQrCodeScanPageState qrcodeScanPageState;

  const CameraScannedFrameIcon({required this.qrcodeScanPageState, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.info,
      color: qrcodeScanPageState is QrCodeScanPageReceivedState ? Colors.yellow : Colors.grey,
    );
  }
}
