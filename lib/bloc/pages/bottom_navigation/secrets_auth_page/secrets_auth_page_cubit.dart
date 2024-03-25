import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/a_secrets_auth_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_invalid_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/password_entry_result_model.dart';
import 'package:snggle/shared/models/password_model.dart';

class SecretsAuthPageCubit extends Cubit<ASecretsAuthPageState> {
  final SecretsService _secretsService;

  final AContainerModel containerModel;

  SecretsAuthPageCubit({
    required this.containerModel,
    SecretsService? secretsService,
  })  : _secretsService = secretsService ?? globalLocator<SecretsService>(),
        super(SecretsAuthPageEnterPinState.empty());

  void updatePinNumbers(List<int> pinNumbers) {
    emit(SecretsAuthPageEnterPinState(pinNumbers: pinNumbers));
  }

  Future<PasswordEntryResultModel> authenticate() async {
    PasswordModel passwordModel = PasswordModel.fromPlaintext(state.pinNumbers.join(''));
    bool passwordValidBool = await _secretsService.isSecretsPasswordValid(containerModel.containerPathModel, passwordModel);
    if (passwordValidBool) {
      return PasswordEntryResultModel(passwordModel: passwordValidBool ? passwordModel : null, validBool: passwordValidBool);
    } else {
      emit(SecretsAuthPageInvalidPinState(pinNumbers: state.pinNumbers));
      throw InvalidPasswordException();
    }
  }
}
