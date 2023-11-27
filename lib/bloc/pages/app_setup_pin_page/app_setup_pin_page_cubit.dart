import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/a_app_setup_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_loading_state.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

class AppSetupPinPageCubit extends Cubit<AAppSetupPinPageState> {
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();
  final AuthSingletonCubit _authSingletonCubit;

  AppSetupPinPageCubit({AuthSingletonCubit? authSingletonCubit})
      : _authSingletonCubit = authSingletonCubit ?? globalLocator<AuthSingletonCubit>(),
        super(const AppSetupPinPageEnterPinState.empty());

  void updateBasePin(List<int> basePinNumbers) {
    emit(AppSetupPinPageEnterPinState(basePinNumbers: basePinNumbers));
  }

  void updateConfirmPin(List<int> confirmPinNumbers) {
    assert(state is AppSetupPinPageConfirmPinState, 'State must be [AppSetupPinPageConfirmPinState] to call this method');

    AppSetupPinPageConfirmPinState appSetupPinPageConfirmPinState = state as AppSetupPinPageConfirmPinState;
    emit(appSetupPinPageConfirmPinState.copyWith(confirmPinNumbers: confirmPinNumbers));
  }

  void setupBasePin() {
    AppSetupPinPageEnterPinState appSetupPinPageEnterPinState = state as AppSetupPinPageEnterPinState;
    emit(AppSetupPinPageConfirmPinState(
      basePinNumbers: appSetupPinPageEnterPinState.basePinNumbers,
      confirmPinNumbers: const <int>[],
    ));
  }

  Future<void> setupConfirmPin() async {
    Future<void> minOperationTime = Future<void>.delayed(const Duration(seconds: 1));

    assert(state is AppSetupPinPageConfirmPinState, 'State must be [AppSetupPinPageConfirmPinState] to call this method');
    AppSetupPinPageConfirmPinState appSetupPinPageConfirmPinState = state as AppSetupPinPageConfirmPinState;

    if (appSetupPinPageConfirmPinState.arePasswordsEqual()) {
      List<int> basePinNumbers = appSetupPinPageConfirmPinState.basePinNumbers;
      PasswordModel passwordModel = PasswordModel.fromPlaintext(basePinNumbers.join(''));
      await _savePin(passwordModel);
      await minOperationTime;
    } else {
      emit(AppSetupPinPageInvalidPinState(
        basePinNumbers: appSetupPinPageConfirmPinState.basePinNumbers,
        confirmPinNumbers: appSetupPinPageConfirmPinState.confirmPinNumbers,
      ));
      throw InvalidPasswordException('PIN numbers are not equal');
    }
  }

  Future<void> setupDefaultPin() async {
    await _savePin(PasswordModel.defaultPassword());
  }

  void resetToBasePin() {
    emit(const AppSetupPinPageEnterPinState.empty());
  }

  Future<void> _savePin(PasswordModel pinPasswordModel) async {
    emit(const AppSetupPinPageLoadingState());
    MnemonicModel mnemonicModel = MnemonicModel.generate();
    MasterKeyVO masterKeyVO = await MasterKeyVO.create(passwordModel: pinPasswordModel, mnemonicModel: mnemonicModel);
    await _masterKeyService.setMasterKey(masterKeyVO);

    _authSingletonCubit.setAppPassword(pinPasswordModel);
  }
}
