import 'dart:async';
import 'dart:typed_data';

import 'package:hd_wallet/hd_wallet.dart';
import 'package:snggle/bloc/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/group_secrets_model.dart';
import 'package:snggle/shared/models/groups/network_group_list_item_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

class NetworkGroupsPageCubit extends AListCubit<NetworkGroupListItemModel> {
  final VaultModel vaultModel;
  final PasswordModel vaultPasswordModel;
  final GroupsService _groupsService;
  final WalletsService _walletsService;
  final SecretsService _secretsService;

  NetworkGroupsPageCubit({
    required this.vaultModel,
    required this.vaultPasswordModel,
    GroupsService? groupsService,
    WalletsService? walletsService,
    SecretsService? secretsService,
  })  : _groupsService = groupsService ?? globalLocator<GroupsService>(),
        _walletsService = walletsService ?? globalLocator<WalletsService>(),
        _secretsService = secretsService ?? globalLocator<SecretsService>();

  // TODO(dominik): Temporary solution to get the vault name. After implementing "create-vault-ui" this method should be removed.
  Future<void> createNewWallet(String type) async {
    WalletModelFactory walletModelFactory = globalLocator<WalletModelFactory>();
    VaultSecretsModel vaultSecretsModel = await _secretsService.getSecrets(vaultModel.containerPathModel, vaultPasswordModel);

    // This section is used to determine the next derivation path segment for the new wallet
    // In current demo app, this value is calculated automatically, basing on the last wallet index existing in database
    // In the targeted app this value should be provided (or confirmed) by user an this functionality will be implemented on the next stages
    int lastWalletIndex = await _walletsService.getLastWalletIndex(vaultModel.uuid);
    int walletIndex = lastWalletIndex + 1;
    String derivationPath = "m/44'/118'/0'/0/${walletIndex}";

    // Seed calculation also will be changed (moved to the separate class). Currently, for the work organization reasons,
    // app allows to generate only one wallet type and this functionality is mocked here
    Uint8List seed = await vaultSecretsModel.mnemonicModel.calculateSeed();
    BIP32 rootNode = BIP32.fromSeed(seed);
    BIP32 derivedNode = rootNode.derivePath(derivationPath);

    WalletModel walletModel = await walletModelFactory.createNewWallet(
      WalletCreationRequestModel(
        index: walletIndex,
        type: type,
        vaultUuid: vaultModel.uuid,
        publicKey: derivedNode.publicKey,
        derivationPath: derivationPath,
        parentContainerPathModel: ContainerPathModel.fromString(vaultModel.containerPathModel.deriveChildPath(type)),
      ),
    );

    WalletSecretsModel walletSecretsModel = WalletSecretsModel(
      containerPathModel: walletModel.containerPathModel,
      privateKey: derivedNode.privateKey!,
    );

    await _walletsService.saveWallet(walletModel);
    await _secretsService.saveSecrets(walletSecretsModel, PasswordModel.defaultPassword());
    await refreshAll();
  }

  @override
  Future<void> deleteFromDatabase(NetworkGroupListItemModel item) async {
    String parentPath = item.groupModel.containerPathModel.path;
    List<WalletModel> walletModels = await _walletsService.getWalletList(parentPath, strictBool: false);
    for (WalletModel walletModel in walletModels) {
      await _walletsService.deleteWalletById(walletModel.uuid);
    }

    List<GroupModel> groupModels = await _groupsService.getGroupList(parentPath, strictBool: false);
    for (GroupModel groupModel in groupModels) {
      await _groupsService.deleteGroupByPath(groupModel.containerPathModel.path);
    }
  }

  @override
  Future<List<NetworkGroupListItemModel>> fetchAllFromDatabase() async {
    List<NetworkGroupListItemModel> networkGroupListItemModelList = <NetworkGroupListItemModel>[];

    for (NetworkConfigModel networkConfigModel in NetworkConfigModel.allNetworks) {
      NetworkGroupListItemModel? networkGroupListItemModel = await _buildNetworkGroupListItemModel(networkConfigModel);
      if (networkGroupListItemModel != null) {
        networkGroupListItemModelList.add(networkGroupListItemModel);
      }
    }

    return networkGroupListItemModelList;
  }

  @override
  Future<NetworkGroupListItemModel?> fetchSingleFromDatabase(NetworkGroupListItemModel item) async {
    NetworkGroupListItemModel? networkGroupListItemModel = await _buildNetworkGroupListItemModel(item.networkConfigModel);
    return networkGroupListItemModel;
  }

  @override
  Future<void> saveToDatabase(NetworkGroupListItemModel item) async {
    print('Saving group: ${item.groupModel}');
    await _groupsService.saveGroup(item.groupModel);
  }

  Future<NetworkGroupListItemModel?> _buildNetworkGroupListItemModel(NetworkConfigModel networkConfigModel) async {
    String groupPath = vaultModel.containerPathModel.deriveChildPath(networkConfigModel.id);
    List<WalletModel> walletModels = await _walletsService.getWalletList(groupPath, strictBool: false);

    if (walletModels.isEmpty) {
      return null;
    }

    GroupModel? groupModel = await _groupsService.getGroupById(groupPath);
    if (groupModel == null) {
      groupModel = GroupModel.fromNetworkConfig(networkConfigModel: networkConfigModel, parentPath: vaultModel.containerPathModel.path);
      GroupSecretsModel groupSecretsModel = GroupSecretsModel.generate(groupModel.containerPathModel);

      await _groupsService.saveGroup(groupModel);
      await _secretsService.saveSecrets(groupSecretsModel, PasswordModel.defaultPassword());
    }

    bool defaultPasswordBool = await _secretsService.isSecretsPasswordValid(groupModel.containerPathModel, PasswordModel.defaultPassword());
    NetworkGroupListItemModel networkGroupListItemModel = NetworkGroupListItemModel(
      encryptedBool: defaultPasswordBool == false,
      groupModel: groupModel,
      networkConfigModel: networkConfigModel,
      walletsPreview: walletModels,
    );

    return networkGroupListItemModel;
  }
}
