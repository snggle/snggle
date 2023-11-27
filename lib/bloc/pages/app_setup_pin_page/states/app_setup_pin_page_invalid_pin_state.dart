import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_confirm_pin_state.dart';

class AppSetupPinPageInvalidPinState extends AppSetupPinPageConfirmPinState {
  const AppSetupPinPageInvalidPinState({
    required super.basePinNumbers,
    required super.confirmPinNumbers,
  });

  @override
  List<Object> get props => <Object>[basePinNumbers, confirmPinNumbers];
}
