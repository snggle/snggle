import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/a_app_pin_set_up_page_state.dart';

class AppPinSetUpPageEnterState extends AAppPinSetUpPageState {
  final List<int> firstPinNumbers;

  const AppPinSetUpPageEnterState({required this.firstPinNumbers});

  const AppPinSetUpPageEnterState.empty() : firstPinNumbers = const <int>[];

  @override
  List<Object> get props => <Object>[firstPinNumbers];
}
