import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/trezor/audio_transfer_cubit/a_audio_transfer_state.dart';
import 'package:snggle/bloc/widgets/trezor/audio_transfer_cubit/states/audio_transfer_receive_state.dart';

class AudioTransferCubit extends Cubit<AAudioTransferState> {
  AudioTransferCubit() : super(AudioTransferReceiveState());
}
