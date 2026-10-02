import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/a_local_pin_set_up_page_state.dart';

class LocalPinSetUpPageEnterState extends ALocalPinSetUpPageState {
  final List<int> firstPinNumbers;

  const LocalPinSetUpPageEnterState({required this.firstPinNumbers});

  const LocalPinSetUpPageEnterState.empty() : firstPinNumbers = const <int>[];

  @override
  List<Object?> get props => <Object?>[firstPinNumbers];
}
