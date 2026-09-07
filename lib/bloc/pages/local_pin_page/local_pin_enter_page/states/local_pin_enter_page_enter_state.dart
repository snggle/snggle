import 'package:snggle/bloc/pages/local_pin_page/local_pin_enter_page/a_local_pin_enter_page_state.dart';

class LocalPinEnterPageEnterState extends ALocalPinEnterPageState {
  const LocalPinEnterPageEnterState({required super.pinNumbers});

  LocalPinEnterPageEnterState.empty() : super(pinNumbers: <int>[]);
}
