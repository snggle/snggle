import 'package:bip39/bip39.dart';
import 'package:blockchain_utils/bip/bip/bip.dart';
import 'package:blockchain_utils/bip/mnemonic/mnemonic.dart';
import 'package:blockchain_utils/bip/mnemonic/mnemonic_decoder_base.dart';
import 'package:blockchain_utils/bip/mnemonic/mnemonic_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultRecoverPageCubit extends Cubit<VaultRecoverPageState> {
  final VaultModelFactory _vaultModelFactory = globalLocator<VaultModelFactory>();
  final VaultsService _vaultsService = globalLocator<VaultsService>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

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
    MnemonicDecoderBase decoder = Bip39MnemonicDecoder();
    bool mnemonicValidBool = MnemonicValidator(decoder).isValid(mnemonic.toStr());

    if (mnemonicValidBool) {
      emit(const VaultRecoverPageState.loading());
      String vaultName = vaultNameTextEditingController.text;
      VaultModel vaultModel = await _vaultModelFactory.createNewVault(parentFilesystemPath, vaultName);
      VaultSecretsModel vaultSecretsModel = VaultSecretsModel(
        filesystemPath: vaultModel.filesystemPath,
        mnemonicModel: MnemonicModel.fromString(mnemonic.toStr()),
      );
      await _vaultsService.save(vaultModel);
      await _secretsService.save(vaultSecretsModel, PasswordModel.defaultPassword());

      await minimalSavingTime;
      creationSuccessfulCallback?.call();
    } else {
      emit(state.copyWith(mnemonicFilledBool: false));
    }
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
