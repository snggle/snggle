import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_confirm_pin_state.dart';

class SecretsSetupPinPageInvalidPinState extends SecretsSetupPinPageConfirmPinState {
  const SecretsSetupPinPageInvalidPinState({
    required super.basePinNumbers,
    required super.confirmPinNumbers,
  });

  @override
  List<Object?> get props => <Object?>[basePinNumbers, confirmPinNumbers];
}
