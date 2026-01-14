import 'package:equatable/equatable.dart';

class ScanTotpQRPageState extends Equatable {
  final bool processingQRBool;

  const ScanTotpQRPageState({
    this.processingQRBool = false,
  });

  ScanTotpQRPageState copyWith({
    bool? processingQRBool,
  }) {
    return ScanTotpQRPageState(
      processingQRBool: processingQRBool ?? this.processingQRBool,
    );
  }

  bool canReceiveQRCode() {
    return processingQRBool == false;
  }

  @override
  List<Object?> get props => <Object?>[processingQRBool];
}
