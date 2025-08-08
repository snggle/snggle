import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/audio/audio_player_section/a_audio_player_section_state.dart';
import 'package:snggle/bloc/widgets/audio/audio_player_section/audio_player_section_cubit.dart';
import 'package:snggle/bloc/widgets/audio/audio_player_section/states/audio_player_section_emitted_state.dart';
import 'package:snggle/bloc/widgets/audio/audio_player_section/states/audio_player_section_emitting_state.dart';

class AudioPlayerSection extends StatefulWidget {
  final Uint8List msgUint8List;
  final VoidCallback onFirstEmission;

  const AudioPlayerSection({
    required this.msgUint8List,
    required this.onFirstEmission,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AudioPlayerSectionState();
}

class _AudioPlayerSectionState extends State<AudioPlayerSection> {
  final AudioPlayerSectionCubit audioPlayerSectionCubit = AudioPlayerSectionCubit();

  @override
  void dispose() {
    audioPlayerSectionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioPlayerSectionCubit, AAudioPlayerSectionState>(
      listener: (BuildContext context, AAudioPlayerSectionState state) {
        if (state is AudioPlayerSectionEmittedState) {
          widget.onFirstEmission.call();
        }
      },
      bloc: audioPlayerSectionCubit,
      builder: (BuildContext context, AAudioPlayerSectionState state) {
        bool emittingInProgressBool = state is AudioPlayerSectionEmittingState;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: emittingInProgressBool
                        ? OutlinedButton(
                      onPressed: audioPlayerSectionCubit.stopSound,
                      child: const Text('Stop emission', style: TextStyle(color: Colors.red)),
                    )
                        : OutlinedButton(
                      onPressed: () => audioPlayerSectionCubit.playSound(widget.msgUint8List),
                      child: const Text('Emit audio', style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
