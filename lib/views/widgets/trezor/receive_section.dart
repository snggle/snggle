import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/a_receive_section_state.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/receive_section_cubit.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/states/receive_section_recording_state.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/states/receive_section_result_state.dart';

class ReceiveSection extends StatefulWidget {

  const ReceiveSection({
    super.key});

  @override
  State<StatefulWidget> createState() => _ReceiveSectionState();
}

class _ReceiveSectionState extends State<ReceiveSection> {
  final ScrollController _scrollController = ScrollController();
  final ReceiveSectionCubit _receiveSectionCubit = ReceiveSectionCubit();
  bool _scrolledBottomBool = true;

  @override
  void initState() {
    super.initState();
    _receiveSectionCubit.consoleNotifier.addListener(_scrollToBottom);
    _scrollController.addListener(_handleUserScroll);
  }

  @override
  void dispose() {
    _receiveSectionCubit.consoleNotifier.removeListener(_scrollToBottom);
    _scrollController
      ..removeListener(_handleUserScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<ReceiveSectionCubit, AReceiveSectionState>(
        bloc: _receiveSectionCubit,
        builder: (BuildContext context, AReceiveSectionState state) {
          bool recordingInProgressBool = state is ReceiveSectionRecordingState;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: recordingInProgressBool ? null : _receiveSectionCubit.startRecording,
                        child: const Text('Start recording'),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: recordingInProgressBool ? _receiveSectionCubit.stopRecording : null,
                        child: const Text('Stop recording'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 380,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ValueListenableBuilder<String>(
                        valueListenable: _receiveSectionCubit.consoleNotifier,
                        builder: (BuildContext context, String logs, _) {
                          return SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            child: Text(
                              logs,
                              style: const TextStyle(fontSize: 11),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (state is ReceiveSectionResultState) ...<Widget>[
                  const SizedBox(height: 20),
                  if (state.brokenMessageIndexes.isEmpty && recordingInProgressBool == false)
                    ElevatedButton.icon(
                      onPressed: () => goToNextPage(state.decodedMessageParts.join()),
                      label: const Text('Submit'),
                      icon: const Icon(Icons.navigate_next_outlined),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _scrolledBottomBool) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleUserScroll() {
    if (_scrollController.hasClients) {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;

      _scrolledBottomBool = (maxScroll - currentScroll) < 20;
    }
  }
}
