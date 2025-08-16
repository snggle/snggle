import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/trezor/audio_transfer_cubit/audio_transfer_cubit.dart';
import 'package:snggle/bloc/widgets/trezor/audio_transfer_cubit/audio_transfer_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page/sign_tx_page/sign_tx_mode.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page/sign_tx_page/sign_tx_page.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/trezor/receive_section.dart';

class AudioTransferPage extends StatefulWidget {
  const AudioTransferPage({super.key});

  @override
  _AudioTransferPageState createState() => _AudioTransferPageState();
}

class _AudioTransferPageState extends State<AudioTransferPage> {
  late final AudioTransferCubit audioTransferCubit = AudioTransferCubit(
    unsupportedOperationCallback: () => _showErrorDialog(ScanQrExceptionType.unsupported),
  );

  bool errorDialogVisibleBool = false;

  @override
  void dispose() {
    audioTransferCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocConsumer<AudioTransferCubit, AudioTransferState>(
        bloc: audioTransferCubit,
        listener: (BuildContext context, AudioTransferState audioTransferState) {
          _startLoadingResultPage(audioTransferState);
        },
        builder: (BuildContext context, AudioTransferState audioTransferState) {
          if (audioTransferState.audioResultPage != null) {
            return audioTransferState.audioResultPage!;
          }
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: <Widget>[
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: CustomAppBar(
                      title: 'Record',
                      closeButtonVisible: false,
                      popButtonVisible: true,
                    ),
                  ),
                ),
                ReceiveSection(onSubmitted: audioTransferCubit.processAudio),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _startLoadingResultPage(AudioTransferState audioTransferState) async {
    if (audioTransferState.shouldLoadResultPage()) {
      await CustomLoadingDialog.show<Widget>(
        context: context,
        barrierColor: AppColors.body2.withOpacity(0.3),
        title: 'Loading...',
        futureFunction: () {
          return _loadResultPage(audioTransferState.cborTaggedObject!);
        },
        onSuccess: (Widget resultPage) async {
          audioTransferCubit.notifyViewLoaded(resultPage);
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
        return SignTxPage.load(
          cborEthSignRequest,
          SignTxMode.audio,
        );
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
            ScanQrExceptionType.unsupported => 'Unsupported audio',
            ScanQrExceptionType.receivedAddressEmpty => 'Missing Address',
            ScanQrExceptionType.walletNotFound => 'Wallet Not Found',
            ScanQrExceptionType.walletWithEncryptedParents => 'Secured Wallet',
          },
          content: Text(
            switch (scanQrExceptionType) {
              ScanQrExceptionType.unsupported => 'Recorded audio is not supported by the application. Please ensure you are using a valid audio signal.',
              ScanQrExceptionType.receivedAddressEmpty =>
                'Recorded transaction does not contain the wallet address required for signing. Please try again with the correct audio signal.',
              ScanQrExceptionType.walletNotFound =>
                'Recorded transaction contains an address that does not exist in the application. Please check if you are using the correct wallet.',
              ScanQrExceptionType.walletWithEncryptedParents =>
                "The wallet is in the password protected path. Please unlock the protected elements on the wallet's path to continue.",
            },
            textAlign: TextAlign.center,
          ),
          onPopInvoked: (_) => audioTransferCubit.reset(),
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
