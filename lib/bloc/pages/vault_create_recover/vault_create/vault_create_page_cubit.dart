import 'package:blockchain_utils/bip/mnemonic/mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_secrets_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:uuid/uuid.dart';

class VaultCreatePageCubit extends Cubit<VaultCreatePageState> {
  final VaultModelFactory _vaultModelFactory = globalLocator<VaultModelFactory>();
  final GroupsService _groupsService = globalLocator<GroupsService>();
  final VaultsService _vaultsService = globalLocator<VaultsService>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  final TextEditingController vaultNameTextEditingController = TextEditingController();
  final FilesystemPath parentFilesystemPath;
  final VoidCallback? creationSuccessfulCallback;

  VaultCreatePageCubit({
    required this.parentFilesystemPath,
    this.creationSuccessfulCallback,
  }) : super(const VaultCreatePageState());

  @override
  Future<void> close() async {
    vaultNameTextEditingController.dispose();
    await super.close();
  }

  Future<void> init(int mnemonicSize) async {
    emit(VaultCreatePageState(mnemonicSize: mnemonicSize, confirmPageEnabledBool: false));

    int lastVaultIndex = await _vaultsService.getLastIndex();
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

    await _createVault(mnemonicWords);
    await minimalSavingTime;

    creationSuccessfulCallback?.call();
  }

  Future<void> _createVault(List<String> mnemonicWords) async {
    // TODO(dominik): Temporary solution to build and validate mnemonic. It should be improved after 'cryptography_utils' package implementation
    Mnemonic mnemonic = Mnemonic(mnemonicWords);

    String vaultName = vaultNameTextEditingController.text;
    VaultModel vaultModel = await _vaultModelFactory.createNewVault(parentFilesystemPath, vaultName);
    VaultSecretsModel vaultSecretsModel = VaultSecretsModel(filesystemPath: vaultModel.filesystemPath, mnemonicModel: MnemonicModel(mnemonic.toList()));

    await _vaultsService.save(vaultModel);
    await _secretsService.save(vaultSecretsModel, PasswordModel.defaultPassword());

    await _createNewNetworkGroup(vaultModel.filesystemPath);
  }

  // TODO(dominik): Temporary solution to create Network Group Model. After implementing Network Templates this method should be removed.
  Future<void> _createNewNetworkGroup(FilesystemPath filesystemPath) async {
    String uuid = const Uuid().v4();

    NetworkGroupModel networkGroupModel = NetworkGroupModel(
      pinnedBool: false,
      encryptedBool: false,
      uuid: uuid,
      listItemsPreview: <AListItemModel>[],
      filesystemPath: FilesystemPath(<String>[...filesystemPath.pathSegments, uuid]),
      networkConfigModel: NetworkConfigModel.ethereum,
    );
    GroupSecretsModel groupSecretsModel = GroupSecretsModel.generate(networkGroupModel.filesystemPath);

    await _groupsService.save(networkGroupModel);
    await _secretsService.save(groupSecretsModel, PasswordModel.defaultPassword());
  }
}
