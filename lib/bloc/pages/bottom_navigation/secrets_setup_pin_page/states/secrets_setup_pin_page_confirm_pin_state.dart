import 'package:flutter/foundation.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/a_secrets_setup_pin_page_state.dart';

class SecretsSetupPinPageConfirmPinState extends ASecretsSetupPinPageState {
  final List<int> basePinNumbers;
  final List<int> confirmPinNumbers;

  const SecretsSetupPinPageConfirmPinState({
    required this.basePinNumbers,
    required this.confirmPinNumbers,
  });

  SecretsSetupPinPageConfirmPinState copyWith({
    List<int>? basePinNumbers,
    List<int>? confirmPinNumbers,
  }) {
    return SecretsSetupPinPageConfirmPinState(
      basePinNumbers: basePinNumbers ?? this.basePinNumbers,
      confirmPinNumbers: confirmPinNumbers ?? this.confirmPinNumbers,
    );
  }

  bool arePasswordsEqual() {
    return listEquals(basePinNumbers, confirmPinNumbers);
  }

  @override
  List<Object?> get props => <Object?>[basePinNumbers, confirmPinNumbers];
}
