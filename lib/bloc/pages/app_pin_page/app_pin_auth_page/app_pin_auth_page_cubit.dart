import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/a_app_pin_auth_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/states/app_pin_auth_page_enter_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/states/app_pin_auth_page_invalid_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';

class AppPinAuthPageCubit extends Cubit<AAppPinAuthPageState> {
  final AppService _appService = globalLocator<AppService>();
  final MasterKeyController _masterKeyController = globalLocator<MasterKeyController>();

  AppPinAuthPageCubit() : super(const AppPinAuthPageEnterState.empty());

  void updatePinNumbers(List<int> pinNumbers) {
    emit(AppPinAuthPageEnterState(
      pinNumbers: pinNumbers,
      invalidAttemptsCount: state.invalidAttemptsCount,
    ));
  }

  Future<void> authenticate({required AppPinType appPinType}) async {
    PasswordModel passwordModel = PasswordModel.fromPlaintext(state.pinNumbers.join(''));
    bool passwordValidBool = await _appService.isPasswordValid(passwordModel);
    if (passwordValidBool) {
      _masterKeyController.setPassword(passwordModel);
    } else {
      int invalidAttemptsCountTmp = state.invalidAttemptsCount;
      bool pinAuthBool = (appPinType == AppPinType.auth);
      if (pinAuthBool) {
        invalidAttemptsCountTmp++;
      }
      if (invalidAttemptsCountTmp >= AAppPinAuthPageState.maxInvalidAttempts && pinAuthBool) {
        await _appService.wipeSecureStorage();
      }
      emit(AppPinAuthPageInvalidState(pinNumbers: state.pinNumbers, invalidAttemptsCount: invalidAttemptsCountTmp));
      throw InvalidPasswordException();
    }
  }
}
