import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_page_confirm_state.dart';

class AppPinSetUpPageInvalidState extends AppPinSetUpPageConfirmState {
  const AppPinSetUpPageInvalidState({
    required super.firstPinNumbers,
    required super.confirmPinNumbers,
  });

  @override
  List<Object> get props => <Object>[firstPinNumbers, confirmPinNumbers];
}
