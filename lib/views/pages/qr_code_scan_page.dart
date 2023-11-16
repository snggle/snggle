import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:snggle/bloc/qr_code_scan_page/qr_code_scan_page_cubit.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_complete_state.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_error_state.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_initial_state.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_received_state.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_time_out_state.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/file_utils.dart';
import 'package:snggle/views/widgets/custom/custom_dialog.dart';
import 'package:snggle/views/widgets/qr_code_scan/camera_scan_progress_indicator.dart';
import 'package:snggle/views/widgets/qr_code_scan/multi_qr_code_scanner.dart';

class QrCodeScanPage extends StatefulWidget {
  const QrCodeScanPage({super.key});

  @override
  State<QrCodeScanPage> createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  MobileScannerController cameraController = MobileScannerController();
  AQrCodeScanPageState previousScanPageState = QrCodeScanPageInitialState();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QrCodeScanPageCubit>(
      create: (BuildContext context) => QrCodeScanPageCubit(cameraController: cameraController),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<QrCodeScanPageCubit, AQrCodeScanPageState>(
          listener: _handleBlocListener,
          listenWhen: (AQrCodeScanPageState previousState, AQrCodeScanPageState currentState) {
            previousScanPageState = previousState;
            return true;
          },
          builder: _handleBlocBuilder,
        ),
      ),
    );
  }

  Future<void> _handleBlocListener(BuildContext context, AQrCodeScanPageState? qrcodeScanPageState) async {
    if (qrcodeScanPageState is QrCodeScanPageTimeOutState) {
      await cameraController.stop();
      await _showTimeoutDialog(context, qrcodeScanPageState);
    }
    if (qrcodeScanPageState is QrCodeScanPageErrorState) {
      // TODO(Knight): Handle where to navigate after error occurs due to Barcode's data and service type decoding issue.
    }
    if (qrcodeScanPageState is QrCodeScanPageCompleteState) {
      await AutoRouter.of(context).replace(
        CompleteScanRoute(decodedString: qrcodeScanPageState.decodedString),
      );
    }
  }

  Widget _handleBlocBuilder(BuildContext context, AQrCodeScanPageState qrcodeScanPageState) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (qrcodeScanPageState is QrCodeScanPageInitialState)
            const Center(
              child: Text('Ready to scan'),
            ),
          if (qrcodeScanPageState is QrCodeScanPageReceivedState)
            Column(
              children: <Widget>[
                Text('Content Type: ${qrcodeScanPageState.multiQrCodeItemModelList[0].type}'),
                Text('Content Name: ${qrcodeScanPageState.multiQrCodeItemModelList[0].name}'),
                Text('Estimated Time: ~${qrcodeScanPageState.estimatedTimeToCompletion}s'),
                Text('Estimated data size: ~${FileUtils.estimateDataSize(qrcodeScanPageState.estimatedTotalDataLength)}')
              ],
            ),
          MultiQrCodeScanner(
            advancedCameraStats: true,
            cameraController: cameraController,
            qrcodeScanPageState: qrcodeScanPageState,
            receiveQRCodeCallback: (Barcode barcode) {
              context.read<QrCodeScanPageCubit>().verifyBarcode(barcode);
            },
          ),
          CameraProgressIndicator(
            qrcodeScanPageState: qrcodeScanPageState,
          ),
          Visibility(
            visible: qrcodeScanPageState is QrCodeScanPageReceivedState,
            child: TextButton(
              onPressed: () {
                context.read<QrCodeScanPageCubit>().cancelQrCodeScan();
              },
              child: const Text('CANCEL'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTimeoutDialog(BuildContext context, QrCodeScanPageTimeOutState qrCodeScanPageTimeOutState) async {
    await showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return const CustomDialog(
          title: 'Scan Timeout',
          message: 'You have not scanned any items or the scanned items were incorrect for a while. Please ensure you are scanning the correct items and try again.',
        );
      },
    ).then(
      (_) {
        context.read<QrCodeScanPageCubit>().refreshTimer();
        context.read<QrCodeScanPageCubit>().resumeState(qrcodeScanPageState: previousScanPageState);
      },
    );
    await cameraController.start();
  }
}
