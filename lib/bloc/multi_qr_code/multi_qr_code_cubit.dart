import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'multi_qr_code_state.dart';

class MultiQrCodeCubit extends Cubit<MultiQrCodeState> {
  final int maxCharacters;
  final Duration qrAnimationDuration;

  MultiQrCodeCubit({
    required this.maxCharacters,
    required this.qrAnimationDuration,
  }) : super(MultiQrCodeState(
          maxCharacters: maxCharacters,
          qrAnimationDuration: qrAnimationDuration,
        ));

  void toggleMaxCharacters(int maxCharacters) {
    emit(MultiQrCodeState(maxCharacters: maxCharacters, qrAnimationDuration: state.qrAnimationDuration));
  }

  void toggleQrAnimationDuration(Duration qrAnimationDuration) {
    emit(MultiQrCodeState(maxCharacters: state.maxCharacters, qrAnimationDuration: qrAnimationDuration));
  }
}
