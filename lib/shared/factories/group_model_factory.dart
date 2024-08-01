import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity/group_entity.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/group_secrets_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class GroupModelFactory {
  final VaultsService _vaultsService = globalLocator<VaultsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final GroupsService _groupsService = globalLocator<GroupsService>();
  final NetworkGroupsService _networkGroupsService = globalLocator<NetworkGroupsService>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<GroupModel> createNewGroup({required FilesystemPath parentFilesystemPath, required String name}) async {
    GroupModel groupModel = GroupModel(
      id: Isar.autoIncrement,
      pinnedBool: false,
      encryptedBool: false,
      listItemsPreview: List<AListItemModel>.empty(),
      filesystemPath: const FilesystemPath.empty(),
      name: name,
    );
    int groupId = await _groupsService.save(groupModel);
    groupModel = await _groupsService.updateFilesystemPath(groupId, parentFilesystemPath);
    GroupSecretsModel groupSecretsModel = GroupSecretsModel.generate(groupModel.filesystemPath);
    await _secretsService.save(groupSecretsModel, PasswordModel.defaultPassword());

    return groupModel;
  }

  Future<List<GroupModel>> createFromEntities(List<GroupEntity> groupEntities, {bool previewEmptyBool = false}) async {
    List<GroupModel> groupModels = <GroupModel>[];
    for (GroupEntity groupEntity in groupEntities) {
      groupModels.add(await createFromEntity(groupEntity, previewEmptyBool: previewEmptyBool));
    }
    return groupModels;
  }

  Future<GroupModel> createFromEntity(GroupEntity groupEntity, {bool previewEmptyBool = false}) async {
    List<GroupModel> groupsPreview = <GroupModel>[];
    List<VaultModel> vaultsPreview = <VaultModel>[];
    List<NetworkGroupModel> networkGroupsPreview = <NetworkGroupModel>[];
    List<WalletModel> walletsPreview = <WalletModel>[];

    if (previewEmptyBool == false) {
      groupsPreview = await _groupsService.getAllByParentPath(groupEntity.filesystemPath, firstLevelBool: true, previewEmptyBool: true);
      networkGroupsPreview = await _networkGroupsService.getAllByParentPath(groupEntity.filesystemPath, firstLevelBool: true, previewEmptyBool: true);
      vaultsPreview = await _vaultsService.getAllByParentPath(groupEntity.filesystemPath, firstLevelBool: true, previewEmptyBool: true);
      walletsPreview = await _walletsService.getAllByParentPath(groupEntity.filesystemPath, firstLevelBool: true);
    }

    List<AListItemModel> listItemsPreview = <AListItemModel>[
      ...groupsPreview,
      ...vaultsPreview,
      ...networkGroupsPreview,
      ...walletsPreview,
    ]..sort((AListItemModel a, AListItemModel b) => a.compareTo(b));

    return GroupModel(
      pinnedBool: groupEntity.pinnedBool,
      encryptedBool: groupEntity.encryptedBool,
      id: groupEntity.id,
      filesystemPath: groupEntity.filesystemPath,
      name: groupEntity.name,
      listItemsPreview: listItemsPreview,
    );
  }
}
