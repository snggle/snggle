import 'dart:async';
import 'dart:typed_data';

import 'package:hd_wallet/hd_wallet.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallet_groups_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/groups/network_group_list_item_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_secrets_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

class NetworkGroupsListPageCubit extends AListCubit<NetworkGroupListItemModel> {
  final VaultModel vaultModel;
  final PasswordModel vaultPasswordModel;
  final SecretsService _secretsService;
  final WalletsService _walletsService;
  final WalletGroupsService _walletGroupsService;

  NetworkGroupsListPageCubit({
    required this.vaultModel,
    required this.vaultPasswordModel,
    SecretsService? secretsService,
    WalletsService? walletsService,
    WalletGroupsService? walletGroupsService,
  })  : _secretsService = secretsService ?? globalLocator<SecretsService>(),
        _walletsService = walletsService ?? globalLocator<WalletsService>(),
        _walletGroupsService = walletGroupsService ?? globalLocator<WalletGroupsService>();

  @override
  Future<void> deleteFromDatabase(NetworkGroupListItemModel item) async {
    await _walletGroupsService.deleteByPath(item.walletGroupModel.containerPathModel.fullPath, recursiveBool: true);
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
    await _walletGroupsService.saveGroup(item.walletGroupModel);
  }

  @override
  Future<List<NetworkGroupListItemModel>> filterBySearchPattern(List<NetworkGroupListItemModel> allItems, String searchPattern) async {
    List<NetworkGroupListItemModel> filteredItems = allItems.where((NetworkGroupListItemModel item) {
      return item.walletGroupModel.name.toLowerCase().contains(searchPattern.toLowerCase());
    }).toList();

    return filteredItems;
  }

  @override
  List<NetworkGroupListItemModel> sortItems(List<NetworkGroupListItemModel> items) {
    items.sort((NetworkGroupListItemModel a, NetworkGroupListItemModel b) {
      return a.walletGroupModel.name.compareTo(b.walletGroupModel.name);
    });

    List<NetworkGroupListItemModel> pinnedItems = items.where((NetworkGroupListItemModel item) => item.walletGroupModel.pinnedBool).toList();
    List<NetworkGroupListItemModel> unpinnedItems = items.where((NetworkGroupListItemModel item) => item.walletGroupModel.pinnedBool == false).toList();

    return <NetworkGroupListItemModel>[...pinnedItems, ...unpinnedItems];
  }

  // TODO(dominik): Temporary solution to get the vault name. After implementing "create-vault-ui" this method should be removed.
  Future<void> createNewWallet(String network) async {
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
        network: network,
        publicKey: derivedNode.publicKey,
        derivationPath: derivationPath,
        parentContainerPathModel: vaultModel.containerPathModel.deriveChildPath(network),
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

  Future<NetworkGroupListItemModel?> _buildNetworkGroupListItemModel(NetworkConfigModel networkConfigModel) async {
    ContainerPathModel groupPath = vaultModel.containerPathModel.deriveChildPath(networkConfigModel.id);
    List<WalletModel> walletModels = await _walletsService.getWalletList(groupPath.fullPath, strictBool: false);

    if (walletModels.isEmpty) {
      return null;
    }

    WalletGroupModel? walletGroupModel = await _walletGroupsService.getByPath(groupPath.fullPath);
    if (walletGroupModel == null) {
      walletGroupModel = WalletGroupModel.fromNetworkConfig(networkConfigModel: networkConfigModel, parentPath: vaultModel.containerPathModel.fullPath);
      WalletGroupSecretsModel walletGroupSecretsModel = WalletGroupSecretsModel.generate(walletGroupModel.containerPathModel);

      await _walletGroupsService.saveGroup(walletGroupModel);
      await _secretsService.saveSecrets(walletGroupSecretsModel, PasswordModel.defaultPassword());
    }

    bool defaultPasswordBool = await _secretsService.isSecretsPasswordValid(walletGroupModel.containerPathModel, PasswordModel.defaultPassword());
    NetworkGroupListItemModel networkGroupListItemModel = NetworkGroupListItemModel(
      encryptedBool: defaultPasswordBool == false,
      walletGroupModel: walletGroupModel,
      networkConfigModel: networkConfigModel,
      walletAddressesPreview: walletModels.map((WalletModel walletModel) => walletModel.address).toList(),
    );

    return networkGroupListItemModel;
  }
}
