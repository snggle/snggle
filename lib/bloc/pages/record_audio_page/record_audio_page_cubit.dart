import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/record_audio_page/record_audio_page_state.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

class RecordAudioPageCubit extends Cubit<RecordAudioPageState> {
  final VoidCallback _unsupportedOperationCallback;

  RecordAudioPageCubit({
    required void Function() unsupportedOperationCallback,
  })  : _unsupportedOperationCallback = unsupportedOperationCallback,
        super(const RecordAudioPageState());

  void processAudio(Uint8List msgUint8List) {
    if (state.canReceiveAudio() == false) {
      return;
    }

    try {
      ACborTaggedObject? cborTaggedObject = ACborTaggedObject.fromSerializedCbor(msgUint8List);

      emit(RecordAudioPageState(cborTaggedObject: cborTaggedObject, loadingBool: true));
    } catch (e) {
      AppLogger().log(message: 'Recorded a signal that could not be processed', logLevel: LogLevel.warning);
      _unsupportedOperationCallback();
    }
  }

  void notifyViewLoaded(Widget view) {
    emit(state.copyWith(loadingBool: false, audioResultPage: view));
  }

  void reset() {
    emit(const RecordAudioPageState());
  }
}
