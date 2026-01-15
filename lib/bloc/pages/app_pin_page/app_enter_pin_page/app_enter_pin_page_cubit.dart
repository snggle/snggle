import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/a_app_enter_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/states/app_enter_invalid_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/states/app_enter_pin_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';

class AppEnterPinPageCubit extends Cubit<AAppEnterPinPageState> {
  final AppService _appService = globalLocator<AppService>();
  final MasterKeyController _masterKeyController = globalLocator<MasterKeyController>();

  AppEnterPinPageCubit() : super(const AppEnterPinPageState.empty());

  void updatePinNumbers(List<int> pinNumbers) {
    emit(AppEnterPinPageState(pinNumbers: pinNumbers));
  }

  Future<void> authenticate() async {
    PasswordModel passwordModel = PasswordModel.fromPlaintext(state.pinNumbers.join(''));
    bool passwordValidBool = await _appService.isPasswordValid(passwordModel);
    if (passwordValidBool) {
      _masterKeyController.setPassword(passwordModel);
    } else {
      emit(AppEnterInvalidPinPageState(pinNumbers: state.pinNumbers));
      throw InvalidPasswordException();
    }
  }
}
