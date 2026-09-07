import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_auth_page/a_local_pin_auth_page_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_auth_page/states/local_pin_auth_page_enter_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_auth_page/states/local_pin_auth_page_invalid_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';

class LocalPinAuthPageCubit extends Cubit<ALocalPinAuthPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final AListItemModel listItemModel;
  final ValueChanged<PasswordModel> passwordValidCallback;

  LocalPinAuthPageCubit({
    required this.listItemModel,
    required this.passwordValidCallback,
  }) : super(LocalPinAuthPageEnterState.empty());

  void updatePinNumbers(List<int> pinNumbers) {
    emit(LocalPinAuthPageEnterState(pinNumbers: pinNumbers));
  }

  Future<void> authenticate() async {
    PasswordModel passwordModel = PasswordModel.fromPlaintext(state.pinNumbers.join(''));
    bool passwordValidBool = await _secretsService.isPasswordValid(listItemModel.filesystemPath, passwordModel);
    if (passwordValidBool) {
      passwordValidCallback(passwordModel);
    } else {
      emit(LocalPinAuthPageInvalidState(pinNumbers: state.pinNumbers));
    }
  }
}
