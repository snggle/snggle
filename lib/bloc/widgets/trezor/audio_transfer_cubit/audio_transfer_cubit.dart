import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/trezor/audio_transfer_cubit/audio_transfer_state.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

class AudioTransferCubit extends Cubit<AudioTransferState> {
  final ValueNotifier<double> progressNotifier;
  final VoidCallback _unsupportedOperationCallback;

  URDecoder _urDecoder = URDecoder();

  AudioTransferCubit({
    required void Function() unsupportedOperationCallback,
  })  : _unsupportedOperationCallback = unsupportedOperationCallback,
        progressNotifier = ValueNotifier<double>(0),
        super(const AudioTransferState());

  void processAudio(String data) {
    if (state.canReceiveAudio() == false) {
      return;
    }

    try {
      _urDecoder.receivePart(data);
      progressNotifier.value = _urDecoder.progress;

      if (_urDecoder.isComplete) {
        _finishScanning();
      }
    } catch (e) {
      AppLogger().log(message: 'Recorded a signal that could not be processed', logLevel: LogLevel.warning);
    }
  }

  void notifyViewLoaded(Widget view) {
    emit(state.copyWith(loadingBool: false, audioResultPage: view));
  }

  void reset() {
    _urDecoder = URDecoder();
    progressNotifier.value = 0;

    emit(const AudioTransferState());
  }

  void _finishScanning() {
    try {
      ACborTaggedObject? cborTaggedObject = _urDecoder.buildCborTaggedObject();
      emit(AudioTransferState(cborTaggedObject: cborTaggedObject, loadingBool: true));
    } catch (_) {
      _unsupportedOperationCallback();
    }
  }
}
