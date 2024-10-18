import 'dart:typed_data';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/config/predefined_network_templates.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/factories/network_group_model_factory.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/crypto/fingerprinter.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultCreatePageCubit extends Cubit<VaultCreatePageState> {
  final NetworkGroupModelFactory _networkGroupsModelFactory = globalLocator<NetworkGroupModelFactory>();
  final VaultModelFactory _vaultModelFactory = globalLocator<VaultModelFactory>();
  final VaultsService _vaultsService = globalLocator<VaultsService>();

  final TextEditingController vaultNameTextEditingController = TextEditingController();
  final FilesystemPath _parentFilesystemPath;

  VaultCreatePageCubit({
    required FilesystemPath parentFilesystemPath,
  })  : _parentFilesystemPath = parentFilesystemPath,
        super(const VaultCreatePageState());

  @override
  Future<void> close() async {
    vaultNameTextEditingController.dispose();
    await super.close();
  }

  Future<void> init(int mnemonicSize) async {
    emit(VaultCreatePageState(mnemonicSize: mnemonicSize, confirmPageEnabledBool: false));

    int lastVaultIndex = await _vaultsService.getLastIndex();
    List<String> mnemonic = MnemonicModel.generate(mnemonicSize).mnemonicList;

    if (lastVaultIndex == -1) {
      vaultNameTextEditingController.text = 'Vault';
    } else {
      vaultNameTextEditingController.text = 'Vault ${lastVaultIndex + 1}';
    }

    emit(state.copyWith(
      confirmPageEnabledBool: true,
      lastVaultIndex: lastVaultIndex,
      mnemonicSize: mnemonicSize,
      mnemonic: mnemonic,
    ));
  }

  Future<void> saveMnemonic() async {
    assert(state.mnemonic != null, 'Method saveMnemonic() can be called only when mnemonic is set');

    List<String> mnemonicWords = state.mnemonic!;
    Mnemonic mnemonic = Mnemonic(state.mnemonic!);
    bool mnemonicRepeatedBool = await _isFingerprintRepeated(mnemonic);

    // To avoid flickering of loading indicator, wait at least 1 second before completing saving operation
    Future<void> minimalSavingTime = Future<void>.delayed(const Duration(seconds: 1));

    if (mnemonicRepeatedBool) {
      emit(state.copyWith(mnemonicRepeatedBool: mnemonicRepeatedBool));
    } else {
      await _createVault(mnemonicWords);
      await minimalSavingTime;

      emit(state.copyWith(mnemonicRepeatedBool: mnemonicRepeatedBool));
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
