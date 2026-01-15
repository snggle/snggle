import 'package:flutter/foundation.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/a_app_set_up_pin_page_state.dart';

class AppSetUpPinPageConfirmPinState extends AAppSetUpPinPageState {
  final List<int> firstPinNumbers;
  final List<int> confirmPinNumbers;

  const AppSetUpPinPageConfirmPinState({
    required this.firstPinNumbers,
    required this.confirmPinNumbers,
  });

  AppSetUpPinPageConfirmPinState copyWith({
    List<int>? firstPinNumbers,
    List<int>? confirmPinNumbers,
  }) {
    return AppSetUpPinPageConfirmPinState(
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
