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
import 'package:snggle/shared/utils/crypto/mnemonic_fingerprint_calculator.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

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
    List<String> mnemonicWords = state.textControllers!.map((TextEditingController textController) => textController.text).toList();

    Mnemonic mnemonic = Mnemonic(mnemonicWords);

    String fingerprint = await MnemonicFingerprintCalculator.calc(mnemonic);

    try {
      VaultModel repeatedVaultModel = await _vaultsService.getDuplicateVault(fingerprint);
      emit(state.copyWith(repeatedVaultModel: repeatedVaultModel));
    } catch (e) {
      AppLogger().log(
        message: 'Did not find the repeated vault, proceeded with vault recovery',
        logLevel: LogLevel.info,
      );
      await _createVault(mnemonicWords);
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
      bool mnemonicValidBool = Mnemonic.isValidMnemonic(mnemonicWords);

      emit(state.copyWith(mnemonicFilledBool: true, mnemonicValidBool: mnemonicValidBool, clearRepeatedVaultModelBool: true));
    }
  }

  Future<void> _createVault(List<String> mnemonicWords) async {
    Mnemonic mnemonic = Mnemonic(mnemonicWords);

    String vaultName = vaultNameTextEditingController.text;
    VaultModel vaultModel = await _vaultModelFactory.createNewVault(_parentFilesystemPath, mnemonic, vaultName);

    // TODO(dominik): Temporary solution to use network template. In the future, there will be dedicated page to create network template
    NetworkTemplateModel networkTemplateModelEthereum = PredefinedNetworkTemplates.ethereum;
    NetworkTemplateModel networkTemplateModelSolana = PredefinedNetworkTemplates.solana;

    await _networkGroupsModelFactory.createNewNetworkGroup(
        vaultModel.filesystemPath, networkTemplateModelEthereum.name, networkTemplateModelEthereum);
    await _networkGroupsModelFactory.createNewNetworkGroup(vaultModel.filesystemPath, networkTemplateModelSolana.name, networkTemplateModelSolana);
  }
}
