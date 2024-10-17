import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultModelFactory {
  final VaultsService _vaultsService = globalLocator<VaultsService>();
  final GroupsService _groupsService = globalLocator<GroupsService>();
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final NetworkGroupsService _networkGroupsService = globalLocator<NetworkGroupsService>();

  Future<VaultModel> createNewVault(FilesystemPath parentFilesystemPath, Mnemonic mnemonic, [String? name]) async {
    int lastVaultIndex = await _vaultsService.getLastIndex();

    LegacyMnemonicSeedGenerator legacyMnemonicSeedGenerator = LegacyMnemonicSeedGenerator();

    Uint8List seed = await legacyMnemonicSeedGenerator.generateSeed(mnemonic);

    VaultModel vaultModel = VaultModel(
      id: Isar.autoIncrement,
      index: lastVaultIndex + 1,
      pinnedBool: false,
      encryptedBool: false,
      filesystemPath: const FilesystemPath.empty(),
      name: name,
      listItemsPreview: <VaultModel>[],
      fingerprint: base64Encode(sha256.convert(seed).bytes),
    );
    int vaultId = await _vaultsService.save(vaultModel);
    vaultModel = await _vaultsService.updateFilesystemPath(vaultId, parentFilesystemPath);

    VaultSecretsModel vaultSecretsModel = VaultSecretsModel(
      filesystemPath: vaultModel.filesystemPath,
      mnemonicModel: MnemonicModel(mnemonic.mnemonicList),
    );

    await _secretsService.save(vaultSecretsModel, PasswordModel.defaultPassword());
    return vaultModel;
  }

  Future<List<VaultModel>> createFromEntities(List<VaultEntity> vaultEntityList, {bool previewEmptyBool = false}) async {
    List<VaultModel> vaultModelList = <VaultModel>[];
    for (VaultEntity vaultEntity in vaultEntityList) {
      vaultModelList.add(await createFromEntity(vaultEntity, previewEmptyBool: previewEmptyBool));
    }
    return vaultModelList;
  }

  Future<VaultModel> createFromEntity(VaultEntity vaultEntity, {bool previewEmptyBool = false}) async {
    List<GroupModel> groupsPreview = <GroupModel>[];
    List<NetworkGroupModel> networkGroupsPreview = <NetworkGroupModel>[];

    if (previewEmptyBool == false) {
      groupsPreview = await _groupsService.getAllByParentPath(vaultEntity.filesystemPath, firstLevelBool: true, previewEmptyBool: true);
      networkGroupsPreview = await _networkGroupsService.getAllByParentPath(vaultEntity.filesystemPath, firstLevelBool: true, previewEmptyBool: true);
    }

    List<AListItemModel> listItemsPreview = <AListItemModel>[
      ...groupsPreview,
      ...networkGroupsPreview,
    ]..sort((AListItemModel a, AListItemModel b) => a.compareTo(b));

    return VaultModel(
      index: vaultEntity.index,
      id: vaultEntity.id,
      pinnedBool: vaultEntity.pinnedBool,
      fingerprint: vaultEntity.fingerprint,
      encryptedBool: vaultEntity.encryptedBool,
      filesystemPath: vaultEntity.filesystemPath,
      name: vaultEntity.name,
      listItemsPreview: listItemsPreview,
    );
  }
}
