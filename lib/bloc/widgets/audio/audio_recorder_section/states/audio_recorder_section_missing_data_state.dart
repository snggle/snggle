import 'package:snggle/bloc/widgets/audio/audio_recorder_section/a_audio_recorder_section_state.dart';

class AudioRecorderSectionMissingDataState extends AAudioRecorderSectionState {
  final int correctDataFramesCount;
  final int allDataFramesCount;

  AudioRecorderSectionMissingDataState({
    required this.correctDataFramesCount,
    required this.allDataFramesCount,
  });

  @override
  List<Object?> get props => <Object>[correctDataFramesCount, allDataFramesCount];
}
