import 'package:blockchain_utils/bip/mnemonic/mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';

class VaultCreatePageCubit extends Cubit<VaultCreatePageState> {
  final TextEditingController vaultNameTextEditingController = TextEditingController();

  final VoidCallback? creationSuccessfulCallback;
  final VaultModelFactory _vaultModelFactory;
  final VaultsService _vaultsService;
  final SecretsService _secretsService;

  VaultCreatePageCubit({
    this.creationSuccessfulCallback,
    VaultModelFactory? vaultModelFactory,
    VaultsService? vaultsService,
    SecretsService? secretsService,
  })  : _vaultModelFactory = vaultModelFactory ?? globalLocator<VaultModelFactory>(),
        _vaultsService = vaultsService ?? globalLocator<VaultsService>(),
        _secretsService = secretsService ?? globalLocator<SecretsService>(),
        super(const VaultCreatePageState());

  @override
  Future<void> close() async {
    vaultNameTextEditingController.dispose();
    await super.close();
  }

  Future<void> init(int mnemonicSize) async {
    emit(VaultCreatePageState(mnemonicSize: mnemonicSize, confirmPageEnabledBool: false));

    int lastVaultIndex = await _vaultsService.getLastVaultIndex();
    List<String> mnemonic = MnemonicModel.generate(mnemonicSize).mnemonicList;

    emit(state.copyWith(
      confirmPageEnabledBool: true,
      lastVaultIndex: lastVaultIndex,
      mnemonicSize: mnemonicSize,
      mnemonic: mnemonic,
    ));
  }

  Future<void> saveMnemonic() async {
    assert(state.mnemonic != null, 'Method saveMnemonic() can be called only when mnemonic is set');

    // To avoid flickering of loading indicator, wait at least 1 second before completing saving operation
    Future<void> minimalSavingTime = Future<void>.delayed(const Duration(seconds: 1));

    List<String> mnemonicWords = state.mnemonic!;
    emit(const VaultCreatePageState.loading());

    // TODO(dominik): Temporary solution to build and validate mnemonic. It should be improved after 'cryptography_utils' package implementation
    Mnemonic mnemonic = Mnemonic(mnemonicWords);

    String vaultName = vaultNameTextEditingController.text;
    VaultModel vaultModel = await _vaultModelFactory.createNewVault(vaultName);
    VaultSecretsModel vaultSecretsModel = VaultSecretsModel(
      filesystemPath: vaultModel.filesystemPath,
      mnemonicModel: MnemonicModel.fromString(mnemonic.toStr()),
    );
    await _vaultsService.saveVault(vaultModel);
    await _secretsService.save(vaultSecretsModel, PasswordModel.defaultPassword());

    await minimalSavingTime;
    creationSuccessfulCallback?.call();
  }
}
