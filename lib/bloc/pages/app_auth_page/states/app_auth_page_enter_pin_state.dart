import 'package:snggle/bloc/pages/app_auth_page/a_app_auth_page_state.dart';

class AppAuthPageEnterPinState extends AAppAuthPageState {
  const AppAuthPageEnterPinState({required super.pinNumbers});

  const AppAuthPageEnterPinState.empty() : super(pinNumbers: const <int>[]);
}
