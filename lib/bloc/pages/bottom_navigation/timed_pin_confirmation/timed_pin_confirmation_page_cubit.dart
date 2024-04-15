import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/timed_pin_confirmation/a_timed_pin_confirmation_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/timed_pin_confirmation/states/timed_pin_confirmation_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/timed_pin_confirmation/states/timed_pin_confirmation_page_invalid_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_auth_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';

class TimedPinConfirmationPageCubit extends Cubit<ATimedPinConfirmationPageState> {
  final AppAuthService _appAuthService = globalLocator<AppAuthService>();

  TimedPinConfirmationPageCubit()
      : super(TimedPinConfirmationPageEnterPinState.empty());

  void updatePinNumbers(List<int> pinNumbers) {
    emit(TimedPinConfirmationPageEnterPinState(pinNumbers: pinNumbers));
  }

  Future<void> authenticate() async {
    PasswordModel passwordModel = PasswordModel.fromPlaintext(state.pinNumbers.join(''));
    bool passwordValidBool = await _appAuthService.isPasswordValid(passwordModel);
    if (passwordValidBool == false) {
      emit(TimedPinConfirmationPageInvalidPinState(pinNumbers: state.pinNumbers));
      throw InvalidPasswordException();
    }
  }
}
