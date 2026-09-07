import 'package:flutter/foundation.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/a_local_pin_set_up_page_state.dart';

class LocalPinSetUpPageConfirmState extends ALocalPinSetUpPageState {
  final List<int> firstPinNumbers;
  final List<int> confirmPinNumbers;

  const LocalPinSetUpPageConfirmState({
    required this.firstPinNumbers,
    required this.confirmPinNumbers,
  });

  LocalPinSetUpPageConfirmState copyWith({
    List<int>? firstPinNumbers,
    List<int>? confirmPinNumbers,
  }) {
    return LocalPinSetUpPageConfirmState(
      firstPinNumbers: firstPinNumbers ?? this.firstPinNumbers,
      confirmPinNumbers: confirmPinNumbers ?? this.confirmPinNumbers,
    );
  }

  bool arePasswordsEqual() {
    return listEquals(firstPinNumbers, confirmPinNumbers);
  }

  @override
  List<Object?> get props => <Object?>[firstPinNumbers, confirmPinNumbers];
}
