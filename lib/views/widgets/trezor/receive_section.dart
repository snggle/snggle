import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/a_receive_section_state.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/receive_section_cubit.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/states/receive_section_missing_data_state.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/states/receive_section_result_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';

class ReceiveSection extends StatefulWidget {
  final ValueChanged<String> onSubmitted;
  final bool closeButtonVisible;
  final bool popButtonVisible;
  final VoidCallback? customPopCallback;
  final List<Widget>? actions;

  const ReceiveSection({
    required this.onSubmitted,
    this.closeButtonVisible = false,
    this.popButtonVisible = true,
    this.customPopCallback,
    this.actions,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ReceiveSectionState();
}

class _ReceiveSectionState extends State<ReceiveSection> {
  final ScrollController _scrollController = ScrollController();
  final ReceiveSectionCubit _receiveSectionCubit = ReceiveSectionCubit();
  final Color _contentColor = Colors.white70;
  bool _scrolledBottomBool = true;

  @override
  void initState() {
    super.initState();
    _receiveSectionCubit.consoleNotifier.addListener(_scrollToBottom);
    _scrollController.addListener(_handleUserScroll);
    _receiveSectionCubit.startRecording();
  }

  @override
  void dispose() {
    _receiveSectionCubit.stopRecording();
    _receiveSectionCubit.consoleNotifier.removeListener(_scrollToBottom);
    _scrollController
      ..removeListener(_handleUserScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiveSectionCubit, AReceiveSectionState>(
        bloc: _receiveSectionCubit,
        builder: (BuildContext context, AReceiveSectionState state) {
          return Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: CustomAppBar(
                    title: 'Record',
                    actions: widget.actions,
                    closeButtonVisible: widget.closeButtonVisible,
                    popButtonVisible: widget.popButtonVisible,
                    customPopCallback: widget.customPopCallback,
                    foregroundColor: AppColors.body2,
                  ),
                ),
              ),
              Positioned(
                top: 150,
                left: 0,
                right: 0,
                child: Center(child: CircularProgressIndicator(color: _contentColor)),
              ),
              Positioned(
                top: kToolbarHeight + 160,
                left: 8,
                right: 8,
                child: Container(
                  height: 380,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: _contentColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: ValueListenableBuilder<String>(
                      valueListenable: _receiveSectionCubit.consoleNotifier,
                      builder: (BuildContext context, String logs, _) {
                        return SingleChildScrollView(
                          controller: _scrollController,
                          child: Text(
                            logs,
                            style: TextStyle(fontSize: 11, color: _contentColor),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (state is ReceiveSectionMissingDataState)
                Positioned(
                    bottom: 150,
                    left: 0,
                    right: 0,
                    child: ElevatedButton(
                      onPressed: _receiveSectionCubit.startRecording,
                      child: const Text('Try again'),
                    )),
              if (state is ReceiveSectionResultState)
                Positioned(
                  bottom: 150,
                  left: 0,
                  right: 0,
                  child: ElevatedButton(onPressed: () => widget.onSubmitted(state.recordedMsg), child: const Text('Proceed')),
                ),
            ],
          );
        });
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
