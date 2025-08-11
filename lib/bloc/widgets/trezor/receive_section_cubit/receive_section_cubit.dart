import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mrumru/mrumru.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/a_receive_section_state.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/states/receive_section_empty_state.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/states/receive_section_recording_state.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/states/receive_section_result_state.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';

class ReceiveSectionCubit extends Cubit<AReceiveSectionState> {
  final ValueNotifier<String> consoleNotifier = ValueNotifier<String>('');
  late final AudioDecoder _audioDecoder;
  AudioSettingsModel audioSettingsModel = AudioSettingsModel(frequencyGenerator: StandardFrequencyGenerator(subbandCount: 32));

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
      emit(ReceiveSectionRecordingState(
        decodedMessageParts: const <String>[],
        brokenMessageIndexes: const <int>[],
      ));
      consoleNotifier.value = '';
    } catch (e) {
      AppLogger().log(message: 'Cannot start recording: $e');
      emit(ReceiveSectionEmptyState());
    }
  }

  Future<void> stopRecording() async {
    await _audioDecoder.cancelRecording();
    emit(ReceiveSectionEmptyState());
  }

  void _handleMetadataFrameReceived(MetadataFrameModel metadataFrameModel) {
    consoleNotifier.value += 'MetadataFrameModel: total frames: ${metadataFrameModel.dataFramesCount}\n';
  }

  void _handleDataFrameReceived(DataFrameModel dataFrameModel) {
    consoleNotifier.value += '\nDataFrameModel (${dataFrameModel.frameIndex}): ${dataFrameModel.data}\n';
  }

  void _handleDecodingCompleted(FrameCollectionModel frameCollectionModel) {
    List<String> decodedParts = frameCollectionModel.getMessageParts();
    emit(ReceiveSectionResultState(
      decodedMessageParts: decodedParts,
      brokenMessageIndexes: frameCollectionModel.getBrokenDataFrameIndexes(),
    ));
  }

  void _handleDecodingFailed() {
    emit(ReceiveSectionResultState(
      decodedMessageParts: const <String>[
        'TRANSFER FAILED!',
        '\nPlease reduce the environment noise or use different transfer parameters.',
      ],
      brokenMessageIndexes: const <int>[],
    ));
  }
}
