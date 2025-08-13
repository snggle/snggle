import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/trezor/audio_transfer_cubit/a_audio_transfer_state.dart';
import 'package:snggle/bloc/widgets/trezor/audio_transfer_cubit/audio_transfer_cubit.dart';
import 'package:snggle/bloc/widgets/trezor/audio_transfer_cubit/states/audio_transfer_receive_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page/sign_tx_page/sign_tx_page.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';
import 'package:snggle/views/widgets/trezor/receive_section.dart';
import 'package:snggle/views/widgets/trezor/send_section.dart';

class AudioTransferPage extends StatefulWidget {
  final bool closeButtonVisible;
  final bool popButtonVisible;
  final VoidCallback? customPopCallback;
  final List<Widget>? actions;

  const AudioTransferPage({
    this.closeButtonVisible = false,
    this.popButtonVisible = true,
    this.customPopCallback,
    this.actions,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AudioTransferPageState();
}

class _AudioTransferPageState extends State<AudioTransferPage> {
  final GlobalKey qrCameraKey = GlobalKey(debugLabel: 'Trezor');
  final AudioTransferCubit _audioTransferCubit = AudioTransferCubit();
  String? responseMsg;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioTransferCubit, AAudioTransferState>(
        bloc: _audioTransferCubit,
        builder: (BuildContext context, AAudioTransferState state) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: CustomAppBar(
                      title: 'Record',
                      actions: widget.actions,
                      closeButtonVisible: widget.closeButtonVisible,
                      popButtonVisible: widget.popButtonVisible,
                      customPopCallback: widget.customPopCallback,
                      foregroundColor: AppColors.body2,
                    ),
                  ),
                ),
                if (state is AudioTransferReceiveState)
                  ReceiveSection(onSubmitted: _handleRequestReceived)
                if (state is AudioTransferSignState)
              ],
            ),
          );
        });
  }

  Future<void> _handleRequestReceived(ACborTaggedObject cborTaggedObject) async {

      await CustomLoadingDialog.show<Widget>(
        context: context,
        barrierColor: AppColors.body2.withOpacity(0.3),
        title: 'Loading...',
        futureFunction: () {
          return _loadResultPage(cborTaggedObject);
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

  Future<Widget> _loadResultPage(ACborTaggedObject cborTaggedObject) async {
    switch (cborTaggedObject) {
      case CborEthSignRequest cborEthSignRequest:
        return  SignTxPage.load(cborEthSignRequest);
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
              "The wallet is in the password protected path. Please unlock the protected elements on the wallet's path to continue.",
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
}
