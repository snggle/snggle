import 'package:flutter/foundation.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/a_app_setup_pin_page_state.dart';

class AppSetupPinPageConfirmPinState extends AAppSetupPinPageState {
  final List<int> basePinNumbers;
  final List<int> confirmPinNumbers;

  const AppSetupPinPageConfirmPinState({
    required this.basePinNumbers,
    required this.confirmPinNumbers,
  });

  AppSetupPinPageConfirmPinState copyWith({
    List<int>? basePinNumbers,
    List<int>? confirmPinNumbers,
  }) {
    return AppSetupPinPageConfirmPinState(
      basePinNumbers: basePinNumbers ?? this.basePinNumbers,
      confirmPinNumbers: confirmPinNumbers ?? this.confirmPinNumbers,
    );
  }

  bool arePasswordsEqual() {
    return listEquals(basePinNumbers, confirmPinNumbers);
  }

  @override
  List<Object> get props => <Object>[basePinNumbers, confirmPinNumbers];
}
