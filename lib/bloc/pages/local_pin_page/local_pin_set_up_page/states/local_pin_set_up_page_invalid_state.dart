import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/states/local_pin_set_up_page_confirm_state.dart';

class LocalPinSetUpPageInvalidState extends LocalPinSetUpPageConfirmState {
  const LocalPinSetUpPageInvalidState({
    required super.firstPinNumbers,
    required super.confirmPinNumbers,
  });

  @override
  List<Object?> get props => <Object?>[firstPinNumbers, confirmPinNumbers];
}
