import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';
import 'package:snggle/bloc/widgets/audio/audio_player_section/a_audio_player_section_state.dart';
import 'package:snggle/bloc/widgets/audio/audio_player_section/states/audio_player_section_emitted_state.dart';
import 'package:snggle/bloc/widgets/audio/audio_player_section/states/audio_player_section_emitting_state.dart';
import 'package:snggle/bloc/widgets/audio/audio_player_section/states/audio_player_section_empty_state.dart';

class AudioPlayerSectionCubit extends Cubit<AAudioPlayerSectionState> {
  late final AudioGenerator _audioGenerator;
  late final AudioSettingsModel _audioSettingsModel = AudioSettingsModel(frequencyGenerator: StandardFrequencyGenerator(subbandCount: 32));
  bool _cancelledByUserBool = false;

  AudioPlayerSectionCubit() : super(AudioPlayerSectionEmptyState()) {
    _audioGenerator = AudioGenerator(onGenerationCompleted: _handleGenerationCompleted);
  }

  @override
  Future<void> close() async {
    await _audioGenerator.cancelGenerating();
    await super.close();
  }

  Future<void> playSound(Uint8List msgUint8list) async {
    _cancelledByUserBool = false;
    await _audioGenerator.startGenerating(AudioGeneratorParams(
      audioSettingsModel: _audioSettingsModel,
      bytes: msgUint8list,
      audioSinkArgs: StreamAudioSinkArgs(),
    ));
    emit(AudioPlayerSectionEmittingState());
  }

  void stopSound() {
    _audioGenerator.cancelGenerating();
    _cancelledByUserBool = true;
  }

  void _handleGenerationCompleted() {
    if (isClosed) {
      return;
    }

    if (_cancelledByUserBool) {
      emit(AudioPlayerSectionEmptyState());
    } else {
      emit(AudioPlayerSectionEmittedState());
    }
  }
}
