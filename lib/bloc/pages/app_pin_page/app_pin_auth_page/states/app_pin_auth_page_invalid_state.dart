import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/a_app_pin_auth_page_state.dart';

class AppPinAuthPageInvalidState extends AAppPinAuthPageState {
  const AppPinAuthPageInvalidState({
    required super.pinNumbers,
    super.invalidAttemptsCount,
  });
}
