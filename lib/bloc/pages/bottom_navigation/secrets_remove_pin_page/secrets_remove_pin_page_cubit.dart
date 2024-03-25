import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/secrets_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_invalid_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_entry_result_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';

class SecretsRemovePinPagePageCubit extends SecretsAuthPageCubit {
  final SecretsService _secretsService;

  SecretsRemovePinPagePageCubit({
    required super.containerModel,
    super.secretsService,
  }) : _secretsService = secretsService ?? globalLocator<SecretsService>();

  @override
  Future<PasswordEntryResultModel> authenticate() async {
    PasswordModel passwordModel = PasswordModel.fromPlaintext(state.pinNumbers.join(''));
    bool passwordValidBool = await _secretsService.isSecretsPasswordValid(containerModel.containerPathModel, passwordModel);
    if (passwordValidBool) {
      await _removePin(passwordModel);
      return PasswordEntryResultModel(passwordModel: passwordValidBool ? passwordModel : null, validBool: passwordValidBool);
    } else {
      emit(SecretsAuthPageInvalidPinState(pinNumbers: state.pinNumbers));
      throw InvalidPasswordException();
    }
  }

  Future<void> _removePin(PasswordModel pinPasswordModel) async {
    try {
      await _secretsService.changePassword(containerModel.containerPathModel, pinPasswordModel, PasswordModel.defaultPassword());
    } catch (e) {
      AppLogger().log(message: 'Cannot save pin for ${containerModel.containerPathModel}: $e');
    }
  }
}
