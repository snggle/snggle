import 'package:snggle/bloc/secrets_auth_page/secrets_auth_page_cubit.dart';
import 'package:snggle/bloc/secrets_auth_page/states/secrets_auth_page_invalid_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/password_entry_result_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';

class SecretsRemovePinPagePageCubit<T extends ASecretsModel> extends SecretsAuthPageCubit {
  final SecretsService _secretsService = globalLocator<SecretsService>();

  SecretsRemovePinPagePageCubit({required super.containerModel});

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
      T secretsModel = await _secretsService.getSecrets(containerModel.containerPathModel, pinPasswordModel);
      await _secretsService.saveSecrets(secretsModel, PasswordModel.defaultPassword());
    } catch (e) {
      AppLogger().log(message: 'Cannot save pin for ${containerModel.containerPathModel}: $e');
    }
  }
}
