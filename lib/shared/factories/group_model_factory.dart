import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity.dart';
import 'package:snggle/infra/entities/network_group_entity.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:uuid/uuid.dart';

class GroupModelFactory {
  final VaultsService _vaultsService = globalLocator<VaultsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final GroupsService _groupsService = globalLocator<GroupsService>();

  GroupModel createNewGroup({required FilesystemPath parentFilesystemPath, required String name}) {
    String uuid = const Uuid().v4();

    return GroupModel(
      pinnedBool: false,
      encryptedBool: false,
      uuid: uuid,
      listItemsPreview: List<AListItemModel>.empty(),
      filesystemPath: FilesystemPath(<String>[...parentFilesystemPath.pathSegments, uuid]),
      name: name,
    );
  }

  Future<GroupModel> createFromEntity(GroupEntity groupEntity, {bool previewEmptyBool = false}) async {
    List<GroupModel> groupsPreview = <GroupModel>[];
    List<VaultModel> vaultsPreview = <VaultModel>[];
    List<WalletModel> walletsPreview = <WalletModel>[];

    if (previewEmptyBool == false) {
      groupsPreview = await _groupsService.getAllByParentPath(groupEntity.filesystemPath, firstLevelBool: true, previewEmptyBool: true);
      vaultsPreview = await _vaultsService.getAllByParentPath(groupEntity.filesystemPath, firstLevelBool: true, previewEmptyBool: true);
      walletsPreview = await _walletsService.getAllByParentPath(groupEntity.filesystemPath, firstLevelBool: true);
    }

    List<AListItemModel> listItemsPreview = <AListItemModel>[
      ...groupsPreview,
      ...vaultsPreview,
      ...walletsPreview,
    ]..sort((AListItemModel a, AListItemModel b) => a.compareTo(b));

    if (groupEntity is NetworkGroupEntity) {
      return NetworkGroupModel(
        pinnedBool: groupEntity.pinnedBool,
        encryptedBool: groupEntity.encryptedBool,
        uuid: groupEntity.uuid,
        filesystemPath: groupEntity.filesystemPath,
        listItemsPreview: listItemsPreview,
        networkConfigModel: NetworkConfigModel.getByNetworkId(groupEntity.networkId),
      );
    } else {
      return GroupModel(
        pinnedBool: groupEntity.pinnedBool,
        encryptedBool: groupEntity.encryptedBool,
        uuid: groupEntity.uuid,
        filesystemPath: groupEntity.filesystemPath,
        name: groupEntity.name,
        listItemsPreview: listItemsPreview,
      );
    }
  }
}
