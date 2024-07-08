import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/a_secrets_auth_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_invalid_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';

class SecretsAuthPageCubit extends Cubit<ASecretsAuthPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final AListItemModel listItemModel;
  final ValueChanged<PasswordModel> passwordValidCallback;

  SecretsAuthPageCubit({
    required this.listItemModel,
    required this.passwordValidCallback,
  }) : super(SecretsAuthPageEnterPinState.empty());

  void updatePinNumbers(List<int> pinNumbers) {
    emit(SecretsAuthPageEnterPinState(pinNumbers: pinNumbers));
  }

  Future<void> authenticate() async {
    PasswordModel passwordModel = PasswordModel.fromPlaintext(state.pinNumbers.join(''));
    bool passwordValidBool = await _secretsService.isPasswordValid(listItemModel.filesystemPath, passwordModel);
    if (passwordValidBool) {
      passwordValidCallback(passwordModel);
    } else {
      emit(SecretsAuthPageInvalidPinState(pinNumbers: state.pinNumbers));
    }
  }
}
