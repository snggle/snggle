import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/record_audio_page/record_audio_page_cubit.dart';
import 'package:snggle/bloc/pages/record_audio_page/record_audio_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/exceptions/read_tx_data_exception.dart';
import 'package:snggle/shared/exceptions/read_tx_data_exception_msgs.dart';
import 'package:snggle/shared/exceptions/read_tx_data_exception_type.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/sign_tx_page/ethereum_sign_tx_page.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/sign_tx_page/sign_tx_mode.dart';
import 'package:snggle/views/widgets/audio/audio_recorder_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';

class RecordAudioPage extends StatefulWidget {
  final bool walletAutoDetectionEnabledBool;
  final VoidCallback onReceived;

  const RecordAudioPage({
    required this.walletAutoDetectionEnabledBool,
    required this.onReceived,
    super.key,
  });

  @override
  _RecordAudioPageState createState() => _RecordAudioPageState();
}

class _RecordAudioPageState extends State<RecordAudioPage> {
  late final RecordAudioPageCubit recordAudioPageCubit = RecordAudioPageCubit(
    unsupportedOperationCallback: () => _showErrorDialog(ReadTxDataExceptionType.unsupported),
  );

  bool errorDialogVisibleBool = false;

  @override
  void dispose() {
    recordAudioPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocConsumer<RecordAudioPageCubit, RecordAudioPageState>(
        bloc: recordAudioPageCubit,
        listener: (BuildContext context, RecordAudioPageState state) {
          _startLoadingResultPage(state);
        },
        builder: (BuildContext context, RecordAudioPageState state) {
          if (state.audioResultPage != null) {
            return state.audioResultPage!;
          }
          return AudioRecorderScaffold(onRecorded: (Uint8List recordedBytes) {
            recordAudioPageCubit.processAudio(recordedBytes);
            widget.onReceived.call();
          });
        },
      ),
    );
  }

  Future<void> _startLoadingResultPage(RecordAudioPageState state) async {
    if (state.shouldLoadResultPage()) {
      await CustomLoadingDialog.show<Widget>(
        context: context,
        barrierColor: AppColors.body2.withOpacity(0.3),
        title: 'Loading...',
        futureFunction: () {
          return _loadResultPage(state.cborTaggedObject!);
        },
        onSuccess: (Widget resultPage) async {
          recordAudioPageCubit.notifyViewLoaded(resultPage);
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
          signTxMode: SignTxMode.audio,
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
          onPopInvoked: (_) => recordAudioPageCubit.reset(),
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
