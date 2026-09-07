import 'package:flutter/foundation.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/a_app_pin_set_up_page_state.dart';

class AppPinSetUpPageConfirmState extends AAppPinSetUpPageState {
  final List<int> firstPinNumbers;
  final List<int> confirmPinNumbers;

  const AppPinSetUpPageConfirmState({
    required this.firstPinNumbers,
    required this.confirmPinNumbers,
  });

  AppPinSetUpPageConfirmState copyWith({
    List<int>? firstPinNumbers,
    List<int>? confirmPinNumbers,
  }) {
    return AppPinSetUpPageConfirmState(
      firstPinNumbers: firstPinNumbers ?? this.firstPinNumbers,
      confirmPinNumbers: confirmPinNumbers ?? this.confirmPinNumbers,
    );
  }

  bool arePasswordsEqual() {
    return listEquals(firstPinNumbers, confirmPinNumbers);
  }

  @override
  List<Object> get props => <Object>[firstPinNumbers, confirmPinNumbers];
}
