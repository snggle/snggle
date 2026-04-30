import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_master_key_recover_page/app_master_key_recover_page_state.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';

class AppMasterKeyRecoverPageCubit extends Cubit<AppMasterKeyRecoverPageState> {
  AppMasterKeyRecoverPageCubit() : super(const AppMasterKeyRecoverPageState());

  @override
  Future<void> close() async {
    _disposeControllers();
    return super.close();
  }

  Future<void> init(int mnemonicSize) async {
    _disposeControllers();

    List<TextEditingController> textControllersList = List<TextEditingController>.generate(mnemonicSize, (_) => TextEditingController());

    for (TextEditingController textEditingController in textControllersList) {
      textEditingController.addListener(_validateMnemonic);
    }

    emit(
      state.copyWith(
        textControllersList: textControllersList,
        mnemonicFilledBool: false,
        mnemonicValidBool: false,
      ),
    );
  }

  Future<void> saveMnemonic() async {
    _validateMnemonic();
  }

  void _disposeControllers() {
    for (TextEditingController textEditingController in state.textControllersList) {
      textEditingController.dispose();
    }
  }

  void _validateMnemonic() {
    List<String> mnemonicWordsList =
        state.textControllersList.map((TextEditingController textEditingController) => textEditingController.text.trim()).toList();

    bool filledBool = mnemonicWordsList.every((String word) => word.isNotEmpty);

    if (mnemonicWordsList.any((String mnemonicWord) => mnemonicWord.isEmpty)) {
      emit(state.copyWith(mnemonicFilledBool: false));
    } else {
      bool mnemonicValidBool = Mnemonic.isValidMnemonic(mnemonicWordsList);
      MnemonicModel mnemonicModel = MnemonicModel(mnemonicWordsList);

      emit(
        state.copyWith(mnemonicFilledBool: filledBool, mnemonicValidBool: mnemonicValidBool, mnemonicModel: mnemonicModel),
      );
    }
  }
}
