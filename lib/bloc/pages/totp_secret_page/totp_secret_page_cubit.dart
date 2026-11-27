import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/totp_secret_page/totp_secret_page_state.dart';
import 'package:snggle/shared/utils/totp_secret_input_parser.dart';

class TotpSecretPageCubit extends Cubit<TotpSecretPageState> {
  final TextEditingController secretTextEditingController = TextEditingController();

  TotpSecretPageCubit() : super(const TotpSecretPageState()) {
    secretTextEditingController.addListener(_clearValidation);
  }

  @override
  Future<void> close() async {
    secretTextEditingController.dispose();
    await super.close();
  }

  String? confirm() {
    String totpSecret = TotpSecretInputParser.fromInput(secretTextEditingController.text);
    bool secretValidBool = totpSecret.isEmpty || TotpSecretInputParser.isValidTotpSecret(totpSecret);
    if (secretValidBool) {
      return totpSecret;
    }

    emit(const TotpSecretPageState(secretInvalidBool: true));
    return null;
  }

  bool isSecretInputEmpty() {
    return secretTextEditingController.text.trim().isEmpty;
  }

  // TODO(Kamil): incons
  void _clearValidation() {
    bool secretInvalidBool = state.secretInvalidBool;
    if (secretInvalidBool) {
      emit(const TotpSecretPageState());
    }
  }
}
