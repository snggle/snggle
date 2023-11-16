import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:snggle/bloc/qr_code_scan_page/qr_code_scan_page_cubit.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_received_state.dart';

class CameraProgressIndicator extends StatelessWidget {
  final AQrCodeScanPageState qrcodeScanPageState;

  const CameraProgressIndicator({
    required this.qrcodeScanPageState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrCodeScanPageCubit, AQrCodeScanPageState>(
      builder: (BuildContext context, Object? state) {
        state = qrcodeScanPageState;

        return Column(
          children: <Widget>[
            if (state is! QrCodeScanPageReceivedState)
              LinearPercentIndicator(
                lineHeight: 50,
                percent: 0.0,
                center: const Text('Scan QR-Code to start'),
              )
            else
              LinearPercentIndicator(
                lineHeight: 50,
                percent: (state.percentageScanned) > 1.0 ? 1 : state.percentageScanned,
                center: Text(
                  state.percentageScanned < 1.0 ? 'Reading MultiPart Data ${(state.percentageScanned * 100).toStringAsFixed(2)}%' : 'Completed Scan 100% ',
                ),
                progressColor: state.percentageScanned < 1.0 ? Colors.red : Colors.green,
              ),
          ],
        );
      },
    );
  }
}
