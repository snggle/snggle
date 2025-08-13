import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/trezor/send_section_cubit/a_send_tab_state.dart';
import 'package:snggle/bloc/widgets/trezor/send_section_cubit/send_section_cubit.dart';
import 'package:snggle/bloc/widgets/trezor/send_section_cubit/states/send_section_emitting_state.dart';

class SendSection extends StatefulWidget {
  final String responseMsg;

  const SendSection({
    required this.responseMsg,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SendSectionState();
}

class _SendSectionState extends State<SendSection> {
  final SendSectionCubit sendSectionCubit = SendSectionCubit();

  bool savingBool = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<SendSectionCubit, ASendSectionState>(
        bloc: sendSectionCubit,
        builder: (BuildContext context, ASendSectionState state) {
          bool emittingInProgressBool = state is SendSectionEmittingState;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Opacity(
                        opacity: emittingInProgressBool ? 0.5 : 1.0,
                        child: OutlinedButton(
                          onPressed: emittingInProgressBool
                              ? null
                              : () {
                            sendSectionCubit.playSound(widget.responseMsg);
                          },
                          child: const Text('Emit audio', style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Opacity(
                        opacity: emittingInProgressBool ? 1.0 : 0.5,
                        child: OutlinedButton(
                          onPressed: emittingInProgressBool ? sendSectionCubit.stopSound : null,
                          child: const Text('Stop emission', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
