import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/a_receive_section_state.dart';

class ReceiveSectionMissingDataState extends AReceiveSectionState {
  final int brokenFramesCount;
  final int allFramesCount;

  ReceiveSectionMissingDataState({required this.brokenFramesCount, required this.allFramesCount});

  @override
  List<Object?> get props => <Object>[brokenFramesCount, allFramesCount];
}
