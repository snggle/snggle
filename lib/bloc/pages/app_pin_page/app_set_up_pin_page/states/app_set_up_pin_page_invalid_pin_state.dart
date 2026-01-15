import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_confirm_pin_state.dart';

class AppSetUpPinPageInvalidPinState extends AppSetUpPinPageConfirmPinState {
  const AppSetUpPinPageInvalidPinState({
    required super.firstPinNumbers,
    required super.confirmPinNumbers,
  });

  @override
  List<Object> get props => <Object>[firstPinNumbers, confirmPinNumbers];
}
