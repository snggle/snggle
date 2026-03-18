import 'dart:typed_data';

import 'package:snggle/bloc/widgets/audio/audio_recorder_section/a_audio_recorder_section_state.dart';

class AudioRecorderSectionResultState extends AAudioRecorderSectionState {
  final Uint8List recordedDataBytes;

  AudioRecorderSectionResultState({required this.recordedDataBytes});

  @override
  List<Object?> get props => <Object>[recordedDataBytes];
}
