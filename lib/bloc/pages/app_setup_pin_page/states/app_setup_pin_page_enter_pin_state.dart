import 'package:snggle/bloc/pages/app_setup_pin_page/a_app_setup_pin_page_state.dart';

class AppSetupPinPageEnterPinState extends AAppSetupPinPageState {
  final List<int> basePinNumbers;

  const AppSetupPinPageEnterPinState({required this.basePinNumbers});

  const AppSetupPinPageEnterPinState.empty() : basePinNumbers = const <int>[];

  @override
  List<Object> get props => <Object>[basePinNumbers];
}
