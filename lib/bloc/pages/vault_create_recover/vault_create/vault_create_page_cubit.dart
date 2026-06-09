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
import 'package:snggle/shared/utils/crypto/mnemonic_fingerprint_calculator.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

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

  Future<void> init(MnemonicSize mnemonicSize) async {
    emit(const VaultCreatePageState(mnemonicFormVisibleBool: false));

    // TODO(kamil): Temporary workaround for the repeated init triggering bug, we ensure the Listener is removed before adding a new one
    vaultNameTextEditingController
      ..removeListener(_updateVaultNameEmptyState)
      ..addListener(_updateVaultNameEmptyState);

    int lastVaultIndex = await _vaultsService.getLastIndex();
    MnemonicModel mnemonicModel = MnemonicModel.vault(mnemonicSize);

    if (lastVaultIndex == -1) {
      vaultNameTextEditingController.text = 'Vault';
    } else {
      vaultNameTextEditingController.text = 'Vault ${lastVaultIndex + 1}';
    }

    emit(state.copyWith(
      mnemonicFormVisibleBool: true,
      mnemonicModel: mnemonicModel,
    ));
  }

  Future<void> saveMnemonic() async {
    MnemonicModel? mnemonicModel = state.mnemonicModel;
    if (mnemonicModel == null) {
      AppLogger().log(message: 'Method saveMnemonic() can be called only when mnemonic is set');
      return;
    }

    List<String> mnemonicWords = mnemonicModel.mnemonicList;
    Mnemonic mnemonic = Mnemonic(mnemonicWords);
    String fingerprint = await MnemonicFingerprintCalculator.calc(mnemonic);

    try {
      VaultModel repeatedVaultModel = await _vaultsService.getDuplicateVault(fingerprint);
      emit(state.copyWith(repeatedVaultModel: repeatedVaultModel));
    } catch (e) {
      AppLogger().log(
        message: 'Did not find the repeated vault, proceeded with vault creation',
        logLevel: LogLevel.info,
      );
      await _createVault(mnemonicWords);
    }
  }

  void _updateVaultNameEmptyState() {
    bool tmpNameEmptyBool = vaultNameTextEditingController.text.trim().isEmpty;

    if (state.nameEmptyBool != tmpNameEmptyBool) {
      emit(state.copyWith(nameEmptyBool: tmpNameEmptyBool));
    }
  }

  Future<void> _createVault(List<String> mnemonicWords) async {
    Mnemonic mnemonic = Mnemonic(mnemonicWords);

    String vaultName = vaultNameTextEditingController.text.trim();
    VaultModel vaultModel = await _vaultModelFactory.createNewVault(_parentFilesystemPath, mnemonic, vaultName);

    // TODO(dominik): Temporary solution to use network template. In the future, there will be dedicated page to create network template
    NetworkTemplateModel networkTemplateModelEthereum = PredefinedNetworkTemplates.ethereum;
    NetworkTemplateModel networkTemplateModelSolana = PredefinedNetworkTemplates.solana;

    await _networkGroupsModelFactory.createNewNetworkGroup(
        vaultModel.filesystemPath, networkTemplateModelEthereum.name, networkTemplateModelEthereum);
    await _networkGroupsModelFactory.createNewNetworkGroup(vaultModel.filesystemPath, networkTemplateModelSolana.name, networkTemplateModelSolana);
  }
}
