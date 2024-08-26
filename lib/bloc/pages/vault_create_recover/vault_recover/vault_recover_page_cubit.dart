import 'package:bip39/bip39.dart';
import 'package:blockchain_utils/bip/bip/bip.dart';
import 'package:blockchain_utils/bip/mnemonic/mnemonic.dart';
import 'package:blockchain_utils/bip/mnemonic/mnemonic_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultRecoverPageCubit extends Cubit<VaultRecoverPageState> {
  final VaultModelFactory _vaultModelFactory = globalLocator<VaultModelFactory>();
  final VaultsService _vaultsService = globalLocator<VaultsService>();

  final TextEditingController vaultNameTextEditingController = TextEditingController();
  final FilesystemPath parentFilesystemPath;
  final VoidCallback? creationSuccessfulCallback;

  VaultRecoverPageCubit({
    required this.parentFilesystemPath,
    this.creationSuccessfulCallback,
  }) : super(const VaultRecoverPageState());

  @override
  Future<void> close() async {
    vaultNameTextEditingController.dispose();
    _disposeControllers();
    await super.close();
  }

  Future<void> init(int mnemonicSize) async {
    emit(state.copyWith(confirmPageEnabledBool: false));

    _disposeControllers();

    List<TextEditingController> textControllers = List<TextEditingController>.generate(mnemonicSize, (_) => TextEditingController());

    for (TextEditingController textEditingController in textControllers) {
      textEditingController.addListener(_validateMnemonic);
    }

    int lastVaultIndex = await _vaultsService.getLastIndex();

    emit(VaultRecoverPageState(
      confirmPageEnabledBool: true,
      lastVaultIndex: lastVaultIndex,
      mnemonicSize: mnemonicSize,
      textControllers: textControllers,
    ));
  }

  Future<void> saveMnemonic() async {
    // To avoid flickering of loading indicator, wait at least 1 second before completing saving operation
    Future<void> minimalSavingTime = Future<void>.delayed(const Duration(seconds: 1));

    List<String> mnemonicWords = state.textControllers!.map((TextEditingController textController) => textController.text).toList();

    // TODO(dominik): Temporary solution to build and validate mnemonic. It should be improved after 'cryptography_utils' package implementation
    Mnemonic mnemonic = Mnemonic(mnemonicWords);
    Bip39MnemonicDecoder decoder = Bip39MnemonicDecoder();
    bool mnemonicValidBool = MnemonicValidator<Bip39MnemonicDecoder>(decoder).isValid(mnemonic.toStr());

    if (mnemonicValidBool) {
      emit(const VaultRecoverPageState.loading());

      await _createVault(mnemonicWords);
      await minimalSavingTime;
      creationSuccessfulCallback?.call();
    } else {
      emit(state.copyWith(mnemonicFilledBool: false));
    }
  }

  Future<void> _createVault(List<String> mnemonicWords) async {
    // TODO(dominik): Temporary solution to build and validate mnemonic. It should be improved after 'cryptography_utils' package implementation
    Mnemonic mnemonic = Mnemonic(mnemonicWords);

    String vaultName = vaultNameTextEditingController.text;
    await _vaultModelFactory.createNewVault(parentFilesystemPath, mnemonic, vaultName);
  }

  void _disposeControllers() {
    state.textControllers?.forEach((TextEditingController textController) => textController.dispose());
  }

  void _validateMnemonic() {
    List<String> mnemonicWords = state.textControllers!.map((TextEditingController textController) => textController.text).toList();
    if (mnemonicWords.any((String mnemonicWord) => mnemonicWord.isEmpty)) {
      emit(state.copyWith(mnemonicFilledBool: false));
    } else {
      // TODO(dominik): Temporary solution to validate mnemonic phrase. After 'cryptography_utils' package implementation it should be improved
      bool mnemonicValidBool = validateMnemonic(mnemonicWords.join(' '));
      emit(state.copyWith(mnemonicFilledBool: true, mnemonicValidBool: mnemonicValidBool));
    }
  }
}
