import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/a_app_enter_pin_page_state.dart';

class AppEnterPinPageState extends AAppEnterPinPageState {
  const AppEnterPinPageState({
    required super.pinNumbers,
    super.invalidAttemptsCount,
  });

  const AppEnterPinPageState.empty()
      : super(
          pinNumbers: const <int>[],
          invalidAttemptsCount: 0,
        );
}
