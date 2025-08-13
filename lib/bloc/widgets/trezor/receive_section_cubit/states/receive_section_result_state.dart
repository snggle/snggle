import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/a_receive_section_state.dart';

class ReceiveSectionResultState extends AReceiveSectionState {
  final String recordedMsg;

  ReceiveSectionResultState({required this.recordedMsg,});

  @override
  List<Object?> get props => <Object>[recordedMsg];
}
