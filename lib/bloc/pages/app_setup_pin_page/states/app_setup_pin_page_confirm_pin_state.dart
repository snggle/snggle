import 'package:flutter/foundation.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/a_app_setup_pin_page_state.dart';

class AppSetupPinPageConfirmPinState extends AAppSetupPinPageState {
  final List<int> firstPinNumbers;
  final List<int> confirmPinNumbers;

  const AppSetupPinPageConfirmPinState({
    required this.firstPinNumbers,
    required this.confirmPinNumbers,
  });

  AppSetupPinPageConfirmPinState copyWith({
    List<int>? firstPinNumbers,
    List<int>? confirmPinNumbers,
  }) {
    return AppSetupPinPageConfirmPinState(
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
