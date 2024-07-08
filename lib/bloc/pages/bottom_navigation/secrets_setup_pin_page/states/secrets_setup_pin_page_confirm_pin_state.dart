import 'package:flutter/foundation.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/a_secrets_setup_pin_page_state.dart';

class SecretsSetupPinPageConfirmPinState extends ASecretsSetupPinPageState {
  final List<int> firstPinNumbers;
  final List<int> confirmPinNumbers;

  const SecretsSetupPinPageConfirmPinState({
    required this.firstPinNumbers,
    required this.confirmPinNumbers,
  });

  SecretsSetupPinPageConfirmPinState copyWith({
    List<int>? firstPinNumbers,
    List<int>? confirmPinNumbers,
  }) {
    return SecretsSetupPinPageConfirmPinState(
      firstPinNumbers: firstPinNumbers ?? this.firstPinNumbers,
      confirmPinNumbers: confirmPinNumbers ?? this.confirmPinNumbers,
    );
  }

  bool arePasswordsEqual() {
    return listEquals(firstPinNumbers, confirmPinNumbers);
  }

  @override
  List<Object?> get props => <Object?>[firstPinNumbers, confirmPinNumbers];
}
