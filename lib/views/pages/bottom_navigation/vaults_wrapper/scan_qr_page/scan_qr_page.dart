import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:snggle/bloc/pages/scan_tx_page/scan_qr_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_tx_page/scan_qr_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page/sign_tx_page/sign_tx_page.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/qr/qr_camera_scaffold.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  late final ScanQRPageCubit scanQRPageCubit = ScanQRPageCubit(
    unsupportedOperationCallback: () => _showErrorDialog(ScanQrExceptionType.unsupported),
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
        listener: (BuildContext context, ScanQRPageState scanTxPageState) {
          _startLoadingResultPage(scanTxPageState);
        },
        builder: (BuildContext context, ScanQRPageState scanTxPageState) {
          if (scanTxPageState.qrResultPage != null) {
            return scanTxPageState.qrResultPage!;
          }
          return QRCameraScaffold(
            title: 'SCAN',
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
          if (e is ScanQrException) {
            await _showErrorDialog(e.scanQrExceptionType);
          }
        },
      );
    }
  }

  Future<Widget> _loadResultPage(ACborTaggedObject cborTaggedObject) async {
    switch (cborTaggedObject) {
      case CborEthSignRequest cborEthSignRequest:
        return SignTxPage.load(cborEthSignRequest);
      default:
        throw const ScanQrException(ScanQrExceptionType.unsupported);
    }
  }

  Future<void> _showErrorDialog(ScanQrExceptionType scanQrExceptionType) async {
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
          title: switch (scanQrExceptionType) {
            ScanQrExceptionType.unsupported => 'Unsupported QR Code',
            ScanQrExceptionType.receivedAddressEmpty => 'Missing Address',
            ScanQrExceptionType.walletNotFound => 'Wallet Not Found',
            ScanQrExceptionType.walletWithEncryptedParents => 'Secured Wallet',
          },
          content: Text(
            switch (scanQrExceptionType) {
              ScanQrExceptionType.unsupported => 'Scanned QR code is not supported by the application. Please ensure you are using a valid QR code.',
              ScanQrExceptionType.receivedAddressEmpty =>
                'Scanned transaction does not contain the wallet address required for signing. Please try again with the correct QR code.',
              ScanQrExceptionType.walletNotFound =>
                'Scanned transaction contains an address that does not exist in the application. Please check if you are using the correct wallet.',
              ScanQrExceptionType.walletWithEncryptedParents =>
                'Wallet is in a Vault or Group that is password protected. Please open the wallet directly to sign the transaction.',
            },
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
