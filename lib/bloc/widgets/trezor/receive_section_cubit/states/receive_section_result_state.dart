import 'package:codec_utils/codec_utils.dart';
import 'package:snggle/bloc/widgets/trezor/receive_section_cubit/a_receive_section_state.dart';

class ReceiveSectionResultState extends AReceiveSectionState {
  final ACborTaggedObject cborTaggedObject;

  ReceiveSectionResultState({required this.cborTaggedObject,});

  @override
  List<Object?> get props => <Object>[cborTaggedObject];
}
