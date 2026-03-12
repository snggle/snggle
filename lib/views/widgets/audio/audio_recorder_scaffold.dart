import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/audio/audio_recorder_section.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';

class AudioRecorderScaffold extends StatefulWidget {
  final ValueChanged<Uint8List> onRecorded;
  final bool closeButtonVisible;
  final bool popButtonVisible;
  final VoidCallback? customPopCallback;
  final List<Widget>? actions;

  const AudioRecorderScaffold({
    required this.onRecorded,
    this.closeButtonVisible = false,
    this.popButtonVisible = true,
    this.customPopCallback,
    this.actions,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AudioRecorderScaffoldState();
}

class _AudioRecorderScaffoldState extends State<AudioRecorderScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: CustomAppBar(
                title: 'AUDIO & SIGN',
                actions: widget.actions,
                closeButtonVisible: widget.closeButtonVisible,
                popButtonVisible: widget.popButtonVisible,
                customPopCallback: widget.customPopCallback,
                foregroundColor: AppColors.body2,
              ),
            ),
          ),
          Positioned.fill(
            child: AudioRecorderSection(onRecorded: widget.onRecorded),
          ),
        ],
      ),
    );
  }
}
