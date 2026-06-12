import 'package:equatable/equatable.dart';

class ScanTotpQRPageState extends Equatable {
  final bool processingQRBool;
  final String? secret;

  const ScanTotpQRPageState({
    this.processingQRBool = false,
    this.secret,
  });

  ScanTotpQRPageState copyWith({
    bool? processingQRBool,
    String? secret,
  }) {
    return ScanTotpQRPageState(
      processingQRBool: processingQRBool ?? this.processingQRBool,
      secret: secret ?? this.secret,
    );
  }

  bool canReceiveQRCode() {
    return processingQRBool == false && _secretExistsBool == false;
  }

  bool shouldFinishScanning() {
    return processingQRBool && _secretExistsBool;
  }

  bool get _secretExistsBool => secret != null;

  @override
  List<Object?> get props => <Object?>[processingQRBool, secret];
}
