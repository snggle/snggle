import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_enter_page/a_app_pin_enter_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_enter_page/states/app_pin_enter_page_invalid_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_enter_page/states/app_pin_enter_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';

class AppPinEnterPageCubit extends Cubit<AAppPinEnterPageState> {
  final AppService _appService = globalLocator<AppService>();
  final MasterKeyController _masterKeyController = globalLocator<MasterKeyController>();

  AppPinEnterPageCubit() : super(const AppPinEnterPageState.empty());

  void updatePinNumbers(List<int> pinNumbers) {
    emit(AppPinEnterPageState(
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
      bool pinEnterBool = (appPinType == AppPinType.enter);
      if (pinEnterBool) {
        invalidAttemptsCountTmp++;
      }
      if (invalidAttemptsCountTmp >= AAppPinEnterPageState.maxInvalidAttempts && pinEnterBool) {
        await _appService.wipeSecureStorage();
      }
      emit(AppPinEnterPageInvalidState(pinNumbers: state.pinNumbers, invalidAttemptsCount: invalidAttemptsCountTmp));
      throw InvalidPasswordException();
    }
  }
}
