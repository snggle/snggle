import 'package:snggle/bloc/pages/local_pin_page/local_pin_auth_page/a_local_pin_auth_page_state.dart';

class LocalPinAuthPageEnterState extends ALocalPinAuthPageState {
  const LocalPinAuthPageEnterState({required super.pinNumbers});

  LocalPinAuthPageEnterState.empty() : super(pinNumbers: <int>[]);
}
