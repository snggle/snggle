import 'package:snggle/bloc/pages/app_setup_pin_page/a_app_setup_pin_page_state.dart';

class AppSetupPinPageEnterPinState extends AAppSetupPinPageState {
  final List<int> firstPinNumbers;

  const AppSetupPinPageEnterPinState({required this.firstPinNumbers});

  const AppSetupPinPageEnterPinState.empty() : firstPinNumbers = const <int>[];

  @override
  List<Object> get props => <Object>[firstPinNumbers];
}
