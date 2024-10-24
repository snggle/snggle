import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:blockchain_utils/bip/bip/bip.dart';
import 'package:blockchain_utils/bip/mnemonic/mnemonic_validator.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/config/predefined_network_templates.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/factories/network_group_model_factory.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/crypto/fingerprinter.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultRecoverPageCubit extends Cubit<VaultRecoverPageState> {
  final NetworkGroupModelFactory _networkGroupsModelFactory = globalLocator<NetworkGroupModelFactory>();
  final VaultModelFactory _vaultModelFactory = globalLocator<VaultModelFactory>();
  final VaultsService _vaultsService = globalLocator<VaultsService>();

  final TextEditingController vaultNameTextEditingController = TextEditingController();
  final FilesystemPath _parentFilesystemPath;

  VaultRecoverPageCubit({
    required FilesystemPath parentFilesystemPath,
  })  : _parentFilesystemPath = parentFilesystemPath,
        super(const VaultRecoverPageState());

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

    if (lastVaultIndex == -1) {
      vaultNameTextEditingController.text = 'Vault';
    } else {
      vaultNameTextEditingController.text = 'Vault ${lastVaultIndex + 1}';
    }

    emit(VaultRecoverPageState(
      confirmPageEnabledBool: true,
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
    bool mnemonicValidBool = MnemonicValidator<Bip39MnemonicDecoder>(decoder).isValid(mnemonic.toString());

    bool mnemonicRepeatedBool = await _isFingerprintRepeated(mnemonic);
    mnemonicValidBool = mnemonicValidBool && (mnemonicRepeatedBool == false);

    if (mnemonicValidBool) {
      await _createVault(mnemonicWords);
      await minimalSavingTime;

      emit(state.copyWith(mnemonicFilledBool: false, mnemonicValidBool: mnemonicValidBool, mnemonicRepeatedBool: mnemonicRepeatedBool));
    } else {
      emit(state.copyWith(mnemonicValidBool: mnemonicValidBool, mnemonicRepeatedBool: mnemonicRepeatedBool));
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
      emit(state.copyWith(mnemonicFilledBool: true, mnemonicValidBool: mnemonicValidBool, mnemonicRepeatedBool: false));
    }
  }

  Future<void> _createVault(List<String> mnemonicWords) async {
    // TODO(dominik): Temporary solution to build and validate mnemonic. It should be improved after 'cryptography_utils' package implementation
    Mnemonic mnemonic = Mnemonic(mnemonicWords);

    String vaultName = vaultNameTextEditingController.text;
    VaultModel vaultModel = await _vaultModelFactory.createNewVault(_parentFilesystemPath, mnemonic, vaultName);

    // TODO(dominik): Temporary solution to use network template. In the future, there will be dedicated page to create network template
    NetworkTemplateModel networkTemplateModel = PredefinedNetworkTemplates.ethereum;
    await _networkGroupsModelFactory.createNewNetworkGroup(vaultModel.filesystemPath, networkTemplateModel.name, networkTemplateModel);
  }

  Future<bool> _isFingerprintRepeated(Mnemonic mnemonic) async {
    LegacyMnemonicSeedGenerator legacyMnemonicSeedGenerator = LegacyMnemonicSeedGenerator();
    Uint8List seed = await legacyMnemonicSeedGenerator.generateSeed(mnemonic);
    String fingerprint = Fingerprinter.createFingerprint(seed);

    List<VaultModel> allVaultModels = await _vaultsService.getAllByParentPath(const FilesystemPath.empty());
    List<String> allFingerprints = allVaultModels.map((VaultModel e) => e.fingerprint).toList();

    bool fingerprintRepeatedBool = false;
    for (String savedFingerprint in allFingerprints) {
      if (savedFingerprint == fingerprint) {
        fingerprintRepeatedBool = true;
      }
    }
    return fingerprintRepeatedBool;
  }
}
