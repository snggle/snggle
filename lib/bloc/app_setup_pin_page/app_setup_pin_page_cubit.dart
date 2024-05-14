import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_confirm_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_error_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_init_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_invalid_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_setup_later_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_success_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_controller.dart';

part 'a_app_setup_pin_page_state.dart';

class AppSetupPinPageCubit extends Cubit<AAppSetupPinPageState> {
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();
  final MasterKeyController _masterKeyController = globalLocator<MasterKeyController>();
  final PinpadController setupPinpadController;
  final PinpadController confirmPinpadController;

  AppSetupPinPageCubit({
    required this.setupPinpadController,
    required this.confirmPinpadController,
  }) : super(AppSetupPinPageInitState());

  Future<void> cancelConfirmState() async {
    confirmPinpadController.clear();
    setupPinpadController.clear();
    emit(AppSetupPinPageInitState());
  }

  Future<void> setupLater() async {
    try {
      await _masterKeyService.setDefaultMasterKey();
      _masterKeyController.setPassword(PasswordModel.defaultPassword());
      emit(AppSetupPinPageSetupLaterState());
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(AppSetupPinPageErrorState());
    }
  }

  Future<void> updateState() async {
    if (state is AppSetupPinPageInitState) {
      _handleFirstPasswordUpdate();
    } else if (state is AppSetupPinPageConfirmState) {
      await _handleRepeatedPasswordUpdate(state as AppSetupPinPageConfirmState);
    }
  }

  void _handleFirstPasswordUpdate() {
    String firstPassword = setupPinpadController.value;
    if (firstPassword.length == setupPinpadController.pinpadTextFieldsSize) {
      emit(AppSetupPinPageConfirmState(passwordModel: PasswordModel.fromPlaintext(firstPassword)));
    }
  }

  Future<void> _handleRepeatedPasswordUpdate(AppSetupPinPageConfirmState appSetupPinPageConfirmState) async {
    String secondPassword = confirmPinpadController.value;
    if (secondPassword.length != confirmPinpadController.pinpadTextFieldsSize) {
      return;
    }

    PasswordModel firstPasswordModel = appSetupPinPageConfirmState.passwordModel;
    PasswordModel secondPasswordModel = PasswordModel.fromPlaintext(confirmPinpadController.value);
    if (firstPasswordModel == secondPasswordModel) {
      await _setupPassword(firstPasswordModel);
    } else {
      emit(AppSetupPinPageInvalidState(passwordModel: firstPasswordModel));
    }
  }

  Future<void> _setupPassword(PasswordModel passwordModel) async {
    try {
      MnemonicModel mnemonicModel = MnemonicModel.generate();
      MasterKeyVO masterKeyVO = await MasterKeyVO.create(passwordModel: passwordModel, mnemonicModel: mnemonicModel);
      await _masterKeyService.setMasterKey(masterKeyVO);

      _masterKeyController.setPassword(passwordModel);
      emit(AppSetupPinPageSuccessState());
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(AppSetupPinPageErrorState());
    }
  }
}
