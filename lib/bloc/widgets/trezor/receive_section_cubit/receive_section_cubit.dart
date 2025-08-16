import 'dart:async';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mrumru/mrumru.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/a_receive_section_state.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/states/receive_section_empty_state.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/states/receive_section_missing_data_state.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/states/receive_section_recording_state.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/states/receive_section_result_state.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';

class ReceiveSectionCubit extends Cubit<AReceiveSectionState> {
  final ValueNotifier<String> consoleNotifier = ValueNotifier<String>('');
  late final AudioDecoder _audioDecoder;
  AudioSettingsModel audioSettingsModel = AudioSettingsModel(frequencyGenerator: StandardFrequencyGenerator(subbandCount: 32));
  int? dataFramesCount;
  ACborTaggedObject? cborTaggedObject;

  ReceiveSectionCubit() : super(ReceiveSectionEmptyState()) {
    _audioDecoder = AudioDecoder(
      onMetadataFrameReceived: _handleMetadataFrameReceived,
      onDataFrameReceived: _handleDataFrameReceived,
      onDecodingCompleted: _handleDecodingCompleted,
      onDecodingFailed: _handleDecodingFailed,
    );
  }

  Future<void> startRecording() async {
    try {
      await _audioDecoder.startRecording(audioSettingsModel);
      emit(ReceiveSectionRecordingState());
      dataFramesCount = null;
      consoleNotifier
        ..value = ''
        ..value += 'Recording started...';
    } catch (e) {
      AppLogger().log(message: '\nCannot start recording: $e');
      emit(ReceiveSectionEmptyState());
    }
  }

  Future<void> stopRecording() async {
    await _audioDecoder.cancelRecording();
    emit(ReceiveSectionEmptyState());
  }

  void _handleMetadataFrameReceived(MetadataFrameModel metadataFrameModel) {
    dataFramesCount = metadataFrameModel.dataFramesCount;
    consoleNotifier.value += '\nDecoding started...';
  }

  void _handleDataFrameReceived(DataFrameModel dataFrameModel) {
    consoleNotifier.value += '\nReceived frame (${dataFrameModel.frameIndex}/$dataFramesCount)';
  }

  void _handleDecodingCompleted(FrameCollectionModel frameCollectionModel) {
    consoleNotifier.value += '\nRecording stopped.';
    List<String> receivedDataFrames = frameCollectionModel.getMessageParts();
    if (dataFramesCount == null) {
      return;
    }

    if (receivedDataFrames.length == dataFramesCount) {
      String recordedMsg = frameCollectionModel.getMessageParts().join('');
      emit(ReceiveSectionResultState(recordedMsg: recordedMsg));
    } else {
      emit(ReceiveSectionMissingDataState(
        brokenFramesCount: frameCollectionModel.getBrokenDataFrameIndexes().length,
        allFramesCount: dataFramesCount!,
      ));
    }
  }

  Future<void> _handleDecodingFailed() async {
    consoleNotifier.value += '\nTRANSFER FAILED!';
    await stopRecording();
    consoleNotifier.value += '\nRestarting';
    await startRecording();
    consoleNotifier.value += '\nRecording started...';
  }
}
