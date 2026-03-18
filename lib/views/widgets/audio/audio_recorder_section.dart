import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snggle/bloc/widgets/audio/audio_recorder_section/a_audio_recorder_section_state.dart';
import 'package:snggle/bloc/widgets/audio/audio_recorder_section/audio_recorder_section_cubit.dart';
import 'package:snggle/bloc/widgets/audio/audio_recorder_section/states/audio_recorder_section_empty_state.dart';
import 'package:snggle/bloc/widgets/audio/audio_recorder_section/states/audio_recorder_section_missing_data_state.dart';
import 'package:snggle/bloc/widgets/audio/audio_recorder_section/states/audio_recorder_section_recording_state.dart';
import 'package:snggle/bloc/widgets/audio/audio_recorder_section/states/audio_recorder_section_result_state.dart';
import 'package:snggle/bloc/widgets/audio/audio_recorder_section/states/audio_recorder_section_retrying_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_animated_icons.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/generic/custom_linear_progress_indicator.dart';
import 'package:snggle/views/widgets/icons/asset_animated_icon.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_wrapper.dart';

class AudioRecorderSection extends StatefulWidget {
  final ValueChanged<Uint8List> onRecorded;
  final bool closeButtonVisible;
  final bool popButtonVisible;
  final VoidCallback? customPopCallback;
  final List<Widget>? actions;

  const AudioRecorderSection({
    required this.onRecorded,
    this.closeButtonVisible = false,
    this.popButtonVisible = true,
    this.customPopCallback,
    this.actions,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AudioRecorderSectionState();
}

class _AudioRecorderSectionState extends State<AudioRecorderSection> {
  final AudioRecorderSectionCubit _audioRecorderSectionCubit = AudioRecorderSectionCubit();
  bool _micPermissionGrantedBool = true;
  bool _micActiveBool = true;

  @override
  void initState() {
    super.initState();
    _tryStartRecording();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioRecorderSectionCubit, AAudioRecorderSectionState>(
      bloc: _audioRecorderSectionCubit,
      listener: (BuildContext context, AAudioRecorderSectionState state) {
        if (state is AudioRecorderSectionResultState) {
          widget.onRecorded(state.recordedDataBytes);
          // starts recording again if recorded data does not match the request
          _audioRecorderSectionCubit.startRecording();
        }
      },
      builder: (BuildContext context, AAudioRecorderSectionState state) {
        return BottomTooltipWrapper(
          blurBackgroundBool: false,
          tooltip: BottomTooltip(
            actions: <BottomTooltipItem>[
              BottomTooltipItem(
                assetIconData: _micActiveBool ? AppIcons.microphone : AppIcons.microphone_muted,
                label: 'Audio',
                onTap: _micActiveBool ? _disableMic : _enableMic,
                foregroundColor: AppColors.body2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_micActiveBool == false) ...<Widget>[
                const Icon(
                  Icons.mic_off_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "Snggle isn't recording. If you want to switch on audio, just tap on the audio button",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              if (state is AudioRecorderSectionEmptyState && _micActiveBool)
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
              if (state is AudioRecorderSectionRetryingState && _micActiveBool) ...<Widget>[
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Recording failed, trying again',
                  style: TextStyle(color: Colors.white),
                ),
              ],
              if (state is AudioRecorderSectionRecordingState && _micActiveBool) ...<Widget>[
                const AssetAnimatedIcon(AppAnimatedIcons.snggle_face_white, size: 120),
                const SizedBox(height: 10),
                const Text(
                  'Snggle is recording audio data...',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                SizedBox(child: CustomLinearProgressIndicator(progressNotifier: _audioRecorderSectionCubit.progressNotifier)),
              ],
              if (state is AudioRecorderSectionMissingDataState && _micActiveBool) ...<Widget>[
                Text(
                  'Some data was lost during transfer.\n(${state.correctDataFramesCount}/${state.allDataFramesCount}) frames are correct.\nTry reducing environmental noise.',
                  style: const TextStyle(color: Colors.yellow),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: _tryStartRecording,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Try again',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _enableMic() async {
    if (_micPermissionGrantedBool) {
      setState(() {
        _micActiveBool = true;
      });
      await _audioRecorderSectionCubit.startRecording();
    } else {
      await _showMicPermissionDialog(context);
    }
  }

  void _disableMic() {
    setState(() {
      _micActiveBool = false;
    });
    _audioRecorderSectionCubit.stopRecording(retryingBool: false);
  }

  Future<void> _tryStartRecording() async {
    _micPermissionGrantedBool = await _requestMicPermission();
    _micActiveBool = _micPermissionGrantedBool;
    setState(() {});
    if (_micPermissionGrantedBool) {
      await _audioRecorderSectionCubit.startRecording();
    }
  }

  Future<bool> _requestMicPermission() async {
    Permission micPermission = Permission.microphone;
    if (await micPermission.isGranted == false) {
      PermissionStatus permissionStatus = await micPermission.request();
      return permissionStatus.isGranted;
    }
    return true;
  }

  Future<void> _showMicPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'No access to microphone',
          overflow: TextOverflow.ellipsis,
        ),
        content: const Text(
          'In order to use this feature, you need to allow the application to use the microphone in system settings.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Go to settings'),
          ),
        ],
      ),
    );
  }
}
