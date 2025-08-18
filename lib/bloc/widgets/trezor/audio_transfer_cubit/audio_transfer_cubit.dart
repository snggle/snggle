import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/trezor/audio_transfer_cubit/audio_transfer_state.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

class AudioTransferCubit extends Cubit<AudioTransferState> {
  final VoidCallback _unsupportedOperationCallback;

  AudioTransferCubit({
    required void Function() unsupportedOperationCallback,
  })  : _unsupportedOperationCallback = unsupportedOperationCallback,
        super(const AudioTransferState());

  void processAudio(String data) {
    if (state.canReceiveAudio() == false) {
      return;
    }

    print('DATA: $data');

    try {
      Uint8List payloadBytes = HexCodec.decode(data);
      ACborTaggedObject? cborTaggedObject = ACborTaggedObject.fromSerializedCbor(payloadBytes);

      emit(AudioTransferState(cborTaggedObject: cborTaggedObject, loadingBool: true));
    } catch (e) {
      AppLogger().log(message: 'Recorded a signal that could not be processed', logLevel: LogLevel.warning);
      _unsupportedOperationCallback();
    }
  }

  void notifyViewLoaded(Widget view) {
    emit(state.copyWith(loadingBool: false, audioResultPage: view));
  }

  void reset() {
    emit(const AudioTransferState());
  }
}
