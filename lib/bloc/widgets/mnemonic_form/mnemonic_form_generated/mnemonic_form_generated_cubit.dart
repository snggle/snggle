import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/mnemonic_form/mnemonic_form_generated/mnemonic_form_generated_state.dart';
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

class MnemonicFormGeneratedCubit extends Cubit<MnemonicFormGeneratedState> {
  final NetworkGroupModelFactory _networkGroupsModelFactory = globalLocator<NetworkGroupModelFactory>();
  final VaultModelFactory _vaultModelFactory = globalLocator<VaultModelFactory>();
  final VaultsService _vaultsService = globalLocator<VaultsService>();

  final TextEditingController vaultNameTextEditingController = TextEditingController();
  final FilesystemPath _parentFilesystemPath;

  MnemonicFormGeneratedCubit({
    required FilesystemPath parentFilesystemPath,
    required MnemonicSize mnemonicSize,
  })  : _parentFilesystemPath = parentFilesystemPath,
        super(
          MnemonicFormGeneratedState(
            mnemonicSize: mnemonicSize,
            mnemonic: MnemonicModel.generate(mnemonicSize).mnemonicList,
          ),
        ) {
    _init();
  }

  @override
  Future<void> close() async {
    vaultNameTextEditingController.dispose();
    await super.close();
  }

  Future<void> _init() async {
    List<VaultModel> vaultsList = await _vaultsService.getAllByParentPath(const FilesystemPath.empty());

    int lastVaultIndex = await _vaultsService.getLastIndex();

    if (lastVaultIndex == -1) {
      vaultNameTextEditingController.text = 'Vault';
    } else {
      vaultNameTextEditingController.text = 'Vault ${lastVaultIndex + 1}';
    }
  }

  Future<void> saveMnemonic() async {
    List<String> mnemonicWords = state.mnemonic;
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

  Future<void> _createVault(List<String> mnemonicWords) async {
    Mnemonic mnemonic = Mnemonic(mnemonicWords);

    String vaultName = vaultNameTextEditingController.text;
    VaultModel vaultModel = await _vaultModelFactory.createNewVault(_parentFilesystemPath, mnemonic, vaultName);

    // TODO(dominik): Temporary solution to use network template. In the future, there will be dedicated page to create network template
    NetworkTemplateModel networkTemplateModel = PredefinedNetworkTemplates.ethereum;
    await _networkGroupsModelFactory.createNewNetworkGroup(vaultModel.filesystemPath, networkTemplateModel.name, networkTemplateModel);
  }
}
