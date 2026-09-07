import 'package:snggle/bloc/pages/app_pin_page/app_pin_enter_page/a_app_pin_enter_page_state.dart';

class AppPinEnterPageState extends AAppPinEnterPageState {
  const AppPinEnterPageState({
    required super.pinNumbers,
    super.invalidAttemptsCount,
  });

  const AppPinEnterPageState.empty()
      : super(
          pinNumbers: const <int>[],
          invalidAttemptsCount: 0,
        );
}
