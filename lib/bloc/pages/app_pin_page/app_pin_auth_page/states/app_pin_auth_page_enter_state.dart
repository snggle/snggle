import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/a_app_pin_auth_page_state.dart';

class AppPinAuthPageEnterState extends AAppPinAuthPageState {
  const AppPinAuthPageEnterState({
    required super.pinNumbers,
    super.invalidAttemptsCount,
  });

  const AppPinAuthPageEnterState.empty()
      : super(
          pinNumbers: const <int>[],
          invalidAttemptsCount: 0,
        );
}
