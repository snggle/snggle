import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/a_app_set_up_pin_page_state.dart';

class AppSetUpPinPageEnterPinState extends AAppSetUpPinPageState {
  final List<int> firstPinNumbers;

  const AppSetUpPinPageEnterPinState({required this.firstPinNumbers});

  const AppSetUpPinPageEnterPinState.empty() : firstPinNumbers = const <int>[];

  @override
  List<Object> get props => <Object>[firstPinNumbers];
}
