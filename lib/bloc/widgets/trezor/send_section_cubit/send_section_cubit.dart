import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';
import 'package:snggle/bloc/widgets/trezor/send_section_cubit/a_send_tab_state.dart';
import 'package:snggle/bloc/widgets/trezor/send_section_cubit/states/send_section_emitting_state.dart';

import 'package:snggle/bloc/widgets/trezor/send_section_cubit/states/send_section_empty_state.dart';


class SendSectionCubit extends Cubit<ASendSectionState> {
  late final AudioGenerator _audioGenerator;
  late AudioSettingsModel audioSettingsModel = AudioSettingsModel(frequencyGenerator: StandardFrequencyGenerator(subbandCount: 32));

  SendSectionCubit() : super(SendSectionEmptyState()) {
    _audioGenerator = AudioGenerator(onGenerationCompleted: () {
      emit(SendSectionEmptyState());
    });
  }

  Future<void> playSound(String text) async {
    Uint8List textBytes = utf8.encode(text);
    await _audioGenerator.startGenerating(AudioGeneratorParams(
      audioSettingsModel: audioSettingsModel,
      bytes: textBytes,
      audioSinkArgs: StreamAudioSinkArgs(),
    ));
    emit(SendSectionEmittingState());
  }

  void stopSound() {
    _audioGenerator.cancelGenerating();
  }
}
