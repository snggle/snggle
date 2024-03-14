import 'dart:async';
import 'dart:typed_data';

import 'package:hd_wallet/hd_wallet.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallet_groups_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_list_item_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_secrets_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

class WalletListPageCubit extends AListCubit<AListItemModel> {
  final VaultModel vaultModel;
  final ContainerPathModel containerPathModel;
  final NetworkConfigModel networkConfigModel;
  final PasswordModel vaultPasswordModel;
  final SecretsService _secretsService;
  final WalletsService _walletsService;
  final WalletGroupsService _walletGroupsService;

  WalletListPageCubit({
    required this.vaultModel,
    required this.containerPathModel,
    required this.networkConfigModel,
    required this.vaultPasswordModel,
    SecretsService? secretsService,
    WalletsService? walletsService,
    WalletGroupsService? walletGroupsService,
  })  : _secretsService = secretsService ?? globalLocator<SecretsService>(),
        _walletsService = walletsService ?? globalLocator<WalletsService>(),
        _walletGroupsService = walletGroupsService ?? globalLocator<WalletGroupsService>();

  // TODO(dominik): Temporary solution to create new wallet. After implementing "create-wallet-ui" this method should be removed.
  Future<void> createNewWallet() async {
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
        derivationPath: derivationPath,
        network: networkConfigModel.name,
        publicKey: derivedNode.publicKey,
        parentContainerPathModel: containerPathModel,
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
  Future<void> deleteFromDatabase(AListItemModel item) async {
    if (item is WalletListItemModel) {
      await _walletsService.deleteWalletById(item.walletModel.uuid);
    } else if (item is WalletGroupListItemModel) {
      await _walletGroupsService.deleteByPath(item.walletGroupModel.containerPathModel.fullPath, recursiveBool: true);
    } else {
      throw StateError('List item not supported');
    }
  }

  @override
  Future<List<AListItemModel>> fetchAllFromDatabase() async {
    List<WalletModel> walletModelList = await _walletsService.getWalletList(containerPathModel.fullPath, strictBool: true);
    List<WalletGroupModel> walletGroupModelList = await _walletGroupsService.getAll(containerPathModel.fullPath, strictBool: true);

    List<WalletListItemModel> walletListItemModelList = <WalletListItemModel>[];
    for (WalletModel walletModel in walletModelList) {
      WalletListItemModel walletListItemModel = await _buildWalletListItemModel(walletModel);
      walletListItemModelList.add(walletListItemModel);
    }

    List<WalletGroupListItemModel> walletGroupListItemModelList = <WalletGroupListItemModel>[];
    for (WalletGroupModel walletGroupModel in walletGroupModelList) {
      WalletGroupListItemModel walletGroupListItemModel = await _buildGroupListItemModel(walletGroupModel);
      walletGroupListItemModelList.add(walletGroupListItemModel);
    }

    return <AListItemModel>[
      ...walletGroupListItemModelList,
      ...walletListItemModelList,
    ];
  }

  @override
  Future<AListItemModel?> fetchSingleFromDatabase(AListItemModel item) async {
    if (item is WalletListItemModel) {
      WalletModel walletModel = await _walletsService.getById(item.walletModel.uuid);
      WalletListItemModel walletListItemModel = await _buildWalletListItemModel(walletModel);
      return walletListItemModel;
    } else if (item is WalletGroupListItemModel) {
      WalletGroupModel? walletGroupModel = await _walletGroupsService.getByPath(item.walletGroupModel.containerPathModel.fullPath);
      if (walletGroupModel == null) {
        return null;
      }
      WalletGroupListItemModel walletGroupListItemModel = await _buildGroupListItemModel(walletGroupModel);

      return walletGroupListItemModel;
    } else {
      throw StateError('List item not supported');
    }
  }

  @override
  Future<void> saveToDatabase(AListItemModel item) async {
    if (item is WalletListItemModel) {
      await _walletsService.saveWallet(item.walletModel);
    } else if (item is WalletGroupListItemModel) {
      await _walletGroupsService.saveGroup(item.walletGroupModel);
    } else {
      throw StateError('List item not supported');
    }
  }

  @override
  Future<List<AListItemModel>> filterBySearchPattern(List<AListItemModel> allItems, String searchPattern) async {
    List<WalletGroupListItemModel> walletGroupListItemModels = allItems.whereType<WalletGroupListItemModel>().toList();
    List<WalletListItemModel> walletListItemModels = allItems.whereType<WalletListItemModel>().toList();

    List<WalletGroupListItemModel> filteredGroups = walletGroupListItemModels.where((WalletGroupListItemModel item) {
      return item.walletGroupModel.name.toLowerCase().contains(searchPattern.toLowerCase());
    }).toList();

    List<WalletListItemModel> filteredWallets = walletListItemModels.where((WalletListItemModel item) {
      return item.name.toLowerCase().contains(searchPattern.toLowerCase());
    }).toList();

    return <AListItemModel>[...filteredGroups, ...filteredWallets];
  }

  @override
  List<AListItemModel> sortItems(List<AListItemModel> items) {
    List<WalletGroupListItemModel> walletGroupListItemModels = items.whereType<WalletGroupListItemModel>().toList();
    List<WalletListItemModel> walletListItemModels = items.whereType<WalletListItemModel>().toList();

    walletGroupListItemModels.sort((WalletGroupListItemModel a, WalletGroupListItemModel b) {
      return a.walletGroupModel.name.compareTo(b.walletGroupModel.name);
    });

    walletListItemModels.sort((WalletListItemModel a, WalletListItemModel b) {
      return a.walletModel.index.compareTo(b.walletModel.index);
    });

    List<WalletGroupListItemModel> pinnedWalletGroups =
        walletGroupListItemModels.where((WalletGroupListItemModel item) => item.walletGroupModel.pinnedBool).toList();
    List<WalletGroupListItemModel> unpinnedWalletGroups =
        walletGroupListItemModels.where((WalletGroupListItemModel item) => item.walletGroupModel.pinnedBool == false).toList();

    List<WalletListItemModel> pinnedWallets = walletListItemModels.where((WalletListItemModel item) => item.walletModel.pinnedBool).toList();
    List<WalletListItemModel> unpinnedWallets = walletListItemModels.where((WalletListItemModel item) => item.walletModel.pinnedBool == false).toList();

    return <AListItemModel>[...pinnedWalletGroups, ...unpinnedWalletGroups, ...pinnedWallets, ...unpinnedWallets];
  }

  Future<void> groupSelection({required List<AListItemModel> selectedItems}) async {
    WalletGroupModel walletGroupModel = WalletGroupModel.generate(parentPath: containerPathModel.fullPath);
    WalletGroupSecretsModel walletGroupSecretsModel = WalletGroupSecretsModel.generate(walletGroupModel.containerPathModel);

    await _walletGroupsService.saveGroup(walletGroupModel);
    await _secretsService.saveSecrets(walletGroupSecretsModel, PasswordModel.defaultPassword());

    for (AListItemModel item in selectedItems) {
      if (item is WalletListItemModel) {
        await _walletsService.moveWallet(item.walletModel.uuid, walletGroupModel.containerPathModel);
      } else if (item is WalletGroupListItemModel) {
        WalletGroupModel movedWalletGroupModel = item.walletGroupModel.copyWith(parentPath: walletGroupModel.containerPathModel.fullPath);
        await _walletGroupsService.moveGroup(item.walletGroupModel.containerPathModel, movedWalletGroupModel.containerPathModel);
      } else {
        throw StateError('List item not supported');
      }
    }

    await refreshAll();
  }

  Future<WalletListItemModel> _buildWalletListItemModel(WalletModel walletModel) async {
    bool defaultPasswordBool = await _secretsService.isSecretsPasswordValid(walletModel.containerPathModel, PasswordModel.defaultPassword());
    WalletListItemModel walletListItemModel = WalletListItemModel(
      encryptedBool: defaultPasswordBool == false,
      walletModel: walletModel,
    );
    return walletListItemModel;
  }

  Future<WalletGroupListItemModel> _buildGroupListItemModel(WalletGroupModel walletGroupModel) async {
    List<WalletModel> walletModels = await _walletsService.getWalletList(walletGroupModel.containerPathModel.fullPath, strictBool: false);
    bool defaultPasswordBool = await _secretsService.isSecretsPasswordValid(walletGroupModel.containerPathModel, PasswordModel.defaultPassword());

    WalletGroupListItemModel walletGroupListItemModel = WalletGroupListItemModel(
      encryptedBool: defaultPasswordBool == false,
      walletAddressesPreview: walletModels.map((WalletModel walletModel) => walletModel.address).toList(),
      walletGroupModel: walletGroupModel,
    );
    return walletGroupListItemModel;
  }
}
