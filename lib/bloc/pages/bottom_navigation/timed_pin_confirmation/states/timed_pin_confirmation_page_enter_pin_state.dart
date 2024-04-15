import 'package:snggle/bloc/pages/bottom_navigation/timed_pin_confirmation/a_timed_pin_confirmation_page_state.dart';

class TimedPinConfirmationPageEnterPinState extends ATimedPinConfirmationPageState {
  const TimedPinConfirmationPageEnterPinState({required super.pinNumbers});

  TimedPinConfirmationPageEnterPinState.empty() : super(pinNumbers: <int>[]);

  @override
  List<Object> get props => <Object>[pinNumbers];
}
