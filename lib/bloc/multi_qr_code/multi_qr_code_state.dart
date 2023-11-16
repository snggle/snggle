part of 'multi_qr_code_cubit.dart';

class MultiQrCodeState extends Equatable {
  final int maxCharacters;
  final Duration qrAnimationDuration;

  const MultiQrCodeState({
    required this.maxCharacters,
    required this.qrAnimationDuration,
  });

  @override
  List<Object?> get props => <dynamic>[maxCharacters, qrAnimationDuration];
}
