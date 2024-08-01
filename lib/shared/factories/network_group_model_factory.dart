import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/group_secrets_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class NetworkGroupModelFactory {
  final VaultsService _vaultsService = globalLocator<VaultsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final GroupsService _groupsService = globalLocator<GroupsService>();
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final NetworkGroupsService _networkGroupsService = globalLocator<NetworkGroupsService>();

  Future<NetworkGroupModel> createNewNetworkGroup(FilesystemPath parentFilesystemPath) async {
    NetworkGroupModel networkGroupModel = NetworkGroupModel(
      pinnedBool: false,
      encryptedBool: false,
      id: Isar.autoIncrement,
      listItemsPreview: <AListItemModel>[],
      filesystemPath: const FilesystemPath.empty(),
      networkConfigModel: NetworkConfigModel.ethereum,
    );

    int networkGroupId = await _networkGroupsService.save(networkGroupModel);
    networkGroupModel = await _networkGroupsService.updateFilesystemPath(networkGroupId, parentFilesystemPath);

    GroupSecretsModel groupSecretsModel = GroupSecretsModel.generate(networkGroupModel.filesystemPath);
    await _secretsService.save(groupSecretsModel, PasswordModel.defaultPassword());

    return networkGroupModel;
  }

  Future<List<NetworkGroupModel>> createFromEntities(List<NetworkGroupEntity> networkGroupEntities, {bool previewEmptyBool = false}) async {
    List<NetworkGroupModel> networkGroupModels = <NetworkGroupModel>[];
    for (NetworkGroupEntity networkGroupEntity in networkGroupEntities) {
      networkGroupModels.add(await createFromEntity(networkGroupEntity, previewEmptyBool: previewEmptyBool));
    }
    return networkGroupModels;
  }

  Future<NetworkGroupModel> createFromEntity(NetworkGroupEntity networkGroupEntity, {bool previewEmptyBool = false}) async {
    List<GroupModel> groupsPreview = <GroupModel>[];
    List<VaultModel> vaultsPreview = <VaultModel>[];
    List<WalletModel> walletsPreview = <WalletModel>[];

    if (previewEmptyBool == false) {
      groupsPreview = await _groupsService.getAllByParentPath(networkGroupEntity.filesystemPath, firstLevelBool: true, previewEmptyBool: true);
      vaultsPreview = await _vaultsService.getAllByParentPath(networkGroupEntity.filesystemPath, firstLevelBool: true, previewEmptyBool: true);
      walletsPreview = await _walletsService.getAllByParentPath(networkGroupEntity.filesystemPath, firstLevelBool: true);
    }

    List<AListItemModel> listItemsPreview = <AListItemModel>[
      ...groupsPreview,
      ...vaultsPreview,
      ...walletsPreview,
    ]..sort((AListItemModel a, AListItemModel b) => a.compareTo(b));

    return NetworkGroupModel(
      pinnedBool: networkGroupEntity.pinnedBool,
      encryptedBool: networkGroupEntity.encryptedBool,
      id: networkGroupEntity.id,
      filesystemPath: networkGroupEntity.filesystemPath,
      listItemsPreview: listItemsPreview,
      networkConfigModel: NetworkConfigModel.getByNetworkId(networkGroupEntity.networkId),
    );
  }
}
