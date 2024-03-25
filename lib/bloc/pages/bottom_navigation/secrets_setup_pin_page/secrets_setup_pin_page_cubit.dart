import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/a_secrets_setup_pin_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_loading_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';

class SecretsSetupPinPageCubit extends Cubit<ASecretsSetupPinPageState> {
  final SecretsService _secretsService;
  final List<AContainerModel> containerModels;

  SecretsSetupPinPageCubit({
    required this.containerModels,
    SecretsService? secretsService,
  })  : _secretsService = secretsService ?? globalLocator<SecretsService>(),
        super(const SecretsSetupPinPageEnterPinState.empty());

  void updateBasePin(List<int> basePinNumbers) {
    emit(SecretsSetupPinPageEnterPinState(basePinNumbers: basePinNumbers));
  }

  void updateConfirmPin(List<int> confirmPinNumbers) {
    assert(state is SecretsSetupPinPageConfirmPinState, 'State must be [PinSetupPageConfirmPinState] to call this method');

    SecretsSetupPinPageConfirmPinState pinSetupPageConfirmPinState = state as SecretsSetupPinPageConfirmPinState;
    emit(pinSetupPageConfirmPinState.copyWith(confirmPinNumbers: confirmPinNumbers));
  }

  void setupBasePin() {
    SecretsSetupPinPageEnterPinState pinSetupPageEnterPinState = state as SecretsSetupPinPageEnterPinState;
    emit(SecretsSetupPinPageConfirmPinState(
      basePinNumbers: pinSetupPageEnterPinState.basePinNumbers,
      confirmPinNumbers: const <int>[],
    ));
  }

  Future<void> setupConfirmPin() async {
    assert(state is SecretsSetupPinPageConfirmPinState, 'State must be [AppSetupPinPageConfirmPinState] to call this method');
    SecretsSetupPinPageConfirmPinState pinSetupPageConfirmPinState = state as SecretsSetupPinPageConfirmPinState;

    if (pinSetupPageConfirmPinState.arePasswordsEqual()) {
      List<int> basePinNumbers = pinSetupPageConfirmPinState.basePinNumbers;
      PasswordModel passwordModel = PasswordModel.fromPlaintext(basePinNumbers.join(''));
      await _savePin(passwordModel);
    } else {
      emit(SecretsSetupPinPageInvalidPinState(
        basePinNumbers: pinSetupPageConfirmPinState.basePinNumbers,
        confirmPinNumbers: pinSetupPageConfirmPinState.confirmPinNumbers,
      ));
      throw InvalidPasswordException('PIN numbers are not equal');
    }
  }

  void resetToBasePin() {
    emit(const SecretsSetupPinPageEnterPinState.empty());
  }

  Future<void> _savePin(PasswordModel pinPasswordModel) async {
    emit(const SecretsSetupPinPageLoadingState());
    for (AContainerModel containerModel in containerModels) {
      try {
        await _secretsService.changePassword(containerModel.containerPathModel, PasswordModel.defaultPassword(), pinPasswordModel);
      } catch (e) {
        AppLogger().log(message: 'Cannot save pin for ${containerModel.containerPathModel}: $e');
      }
    }
  }
}
