import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:snggle/bloc/pages/scan_qr_page/scan_qr_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_qr_page/scan_qr_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/exceptions/read_tx_data_exception.dart';
import 'package:snggle/shared/exceptions/read_tx_data_exception_msgs.dart';
import 'package:snggle/shared/exceptions/read_tx_data_exception_type.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/sign_tx_page/ethereum_sign_tx_page.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/sign_tx_page/sign_tx_mode.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/sign_tx_page/solana_sign_tx_page.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/qr/qr_camera_scaffold.dart';

class ScanQRPage extends StatefulWidget {
  final bool walletAutoDetectionEnabledBool;

  const ScanQRPage({
    required this.walletAutoDetectionEnabledBool,
    super.key,
  });

  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  late final ScanQRPageCubit scanQRPageCubit = ScanQRPageCubit(
    unsupportedOperationCallback: () => _showErrorDialog(ReadTxDataExceptionType.unsupported),
  );

  bool errorDialogVisibleBool = false;

  @override
  void dispose() {
    scanQRPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocConsumer<ScanQRPageCubit, ScanQRPageState>(
        bloc: scanQRPageCubit,
        listener: (BuildContext context, ScanQRPageState scanQRPageState) {
          _startLoadingResultPage(scanQRPageState);
        },
        builder: (BuildContext context, ScanQRPageState scanTxPageState) {
          if (scanTxPageState.qrResultPage != null) {
            return scanTxPageState.qrResultPage!;
          }
          return QRCameraScaffold(
            title: 'SCAN & SIGN',
            progressNotifier: scanQRPageCubit.progressNotifier,
            onQRScanned: _handleQRScanned,
          );
        },
      ),
    );
  }

  Future<void> _startLoadingResultPage(ScanQRPageState scanTxPageState) async {
    if (scanTxPageState.shouldLoadResultPage()) {
      await CustomLoadingDialog.show<Widget>(
        context: context,
        barrierColor: AppColors.body2.withOpacity(0.3),
        title: 'Loading...',
        futureFunction: () {
          return _loadResultPage(scanTxPageState.cborTaggedObject!);
        },
        onSuccess: (Widget resultPage) async {
          scanQRPageCubit.notifyViewLoaded(resultPage);
        },
        onError: (Object e) async {
          if (e is ReadTxDataException) {
            await _showErrorDialog(e.readTxDataExceptionType);
          }
        },
      );
    }
  }

  Future<Widget> _loadResultPage(ACborTaggedObject cborTaggedObject) async {
    switch (cborTaggedObject) {
      case CborEthSignRequest cborEthSignRequest:
        return EthereumSignTxPage.load(
          walletAutoDetectionEnabledBool: widget.walletAutoDetectionEnabledBool,
          cborEthSignRequest: cborEthSignRequest,
          signTxMode: SignTxMode.qr,
        );
      case CborSolSignRequest cborSolSignRequest:
        return SolanaSignTxPage.load(
          walletAutoDetectionEnabledBool: widget.walletAutoDetectionEnabledBool,
          cborSolSignRequest: cborSolSignRequest,
        );
      default:
        throw const ReadTxDataException(ReadTxDataExceptionType.unsupported);
    }
  }

  Future<void> _showErrorDialog(ReadTxDataExceptionType readTxDataExceptionType) async {
    if (errorDialogVisibleBool) {
      return;
    }
    errorDialogVisibleBool = true;
    await showDialog(
      context: context,
      barrierColor: AppColors.body2.withOpacity(0.3),
      builder: (BuildContext context) {
        return CustomDialog(
          backgroundColor: AppColors.body2.withOpacity(0.5),
          title: ReadTxDataExceptionMsgs.getTitle(readTxDataExceptionType),
          content: Text(
            ReadTxDataExceptionMsgs.getDescriptionForQR(readTxDataExceptionType),
            textAlign: TextAlign.center,
          ),
          onPopInvoked: (_) => scanQRPageCubit.reset(),
          options: <CustomDialogOption>[
            CustomDialogOption(
              label: 'Confirm',
              onPressed: () {},
            ),
          ],
        );
      },
    );
    errorDialogVisibleBool = false;
  }

  void _handleQRScanned(Barcode barcode) {
    if (barcode.code != null) {
      scanQRPageCubit.processQR(barcode.code!);
    }
  }
}
