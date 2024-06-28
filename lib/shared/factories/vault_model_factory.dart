import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:uuid/uuid.dart';

class VaultModelFactory {
  final VaultsService _vaultsService = globalLocator<VaultsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final GroupsService _groupsService = globalLocator<GroupsService>();

  Future<VaultModel> createNewVault(FilesystemPath parentFilesystemPath, [String? name]) async {
    int lastVaultIndex = await _vaultsService.getLastIndex();
    String uuid = const Uuid().v4();

    VaultModel vaultModel = VaultModel(
      index: lastVaultIndex + 1,
      pinnedBool: false,
      encryptedBool: false,
      uuid: uuid,
      filesystemPath: FilesystemPath(<String>[...parentFilesystemPath.pathSegments, uuid]),
      name: name,
      listItemsPreview: <VaultModel>[],
    );

    return vaultModel;
  }

  Future<VaultModel> createFromEntity(VaultEntity vaultEntity, {bool previewEmptyBool = false}) async {
    List<GroupModel> groupsPreview = <GroupModel>[];
    List<WalletModel> walletsPreview = <WalletModel>[];

    if (previewEmptyBool == false) {
      groupsPreview = await _groupsService.getAllByParentPath(vaultEntity.filesystemPath, firstLevelBool: true, previewEmptyBool: true);
      walletsPreview = await _walletsService.getAllByParentPath(vaultEntity.filesystemPath, firstLevelBool: true);
    }

    List<AListItemModel> listItemsPreview = <AListItemModel>[
      ...groupsPreview,
      ...walletsPreview,
    ]..sort((AListItemModel a, AListItemModel b) => a.compareTo(b));

    return VaultModel(
      index: vaultEntity.index,
      uuid: vaultEntity.uuid,
      pinnedBool: vaultEntity.pinnedBool,
      encryptedBool: vaultEntity.encryptedBool,
      filesystemPath: vaultEntity.filesystemPath,
      name: vaultEntity.name,
      listItemsPreview: listItemsPreview,
    );
  }
}
