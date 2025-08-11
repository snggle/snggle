import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/a_receive_section_state.dart';

class ReceiveSectionResultState extends AReceiveSectionState {
  final List<String> decodedMessageParts;
  final List<int> brokenMessageIndexes;

  ReceiveSectionResultState({required this.decodedMessageParts, required this.brokenMessageIndexes});

  @override
  List<Object?> get props => <Object>[decodedMessageParts, brokenMessageIndexes];
}
