import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/a_receive_section_state.dart';

class ReceiveSectionResultState extends AReceiveSectionState {
  final int brokenFramesCount;
  final int allFramesCount;

  ReceiveSectionResultState({required this.brokenFramesCount, required this.allFramesCount});

  @override
  List<Object?> get props => <Object>[brokenFramesCount, allFramesCount];
}
