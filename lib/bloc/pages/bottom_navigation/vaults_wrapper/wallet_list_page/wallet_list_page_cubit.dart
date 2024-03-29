import 'dart:async';
import 'dart:typed_data';

import 'package:hd_wallet/hd_wallet.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';
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
  final PasswordModel vaultPasswordModel;
  final SecretsService _secretsService;
  final WalletsService _walletsService;

  WalletListPageCubit({
    required this.vaultModel,
    required this.containerPathModel,
    required this.vaultPasswordModel,
    SecretsService? secretsService,
    WalletsService? walletsService,
  })  : _secretsService = secretsService ?? globalLocator<SecretsService>(),
        _walletsService = walletsService ?? globalLocator<WalletsService>();

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
        network: 'kira',
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
    } else {
      throw StateError('List item not supported');
    }
  }

  @override
  Future<List<AListItemModel>> fetchAllFromDatabase() async {
    List<WalletModel> walletModelList = await _walletsService.getWalletList(containerPathModel.fullPath, strictBool: true);

    List<WalletListItemModel> walletListItemModelList = <WalletListItemModel>[];
    for (WalletModel walletModel in walletModelList) {
      WalletListItemModel walletListItemModel = await _buildWalletListItemModel(walletModel);
      walletListItemModelList.add(walletListItemModel);
    }

    return <AListItemModel>[...walletListItemModelList];
  }

  @override
  Future<AListItemModel?> fetchSingleFromDatabase(AListItemModel item) async {
    if (item is WalletListItemModel) {
      WalletModel walletModel = await _walletsService.getById(item.walletModel.uuid);
      WalletListItemModel walletListItemModel = await _buildWalletListItemModel(walletModel);
      return walletListItemModel;
    } else {
      throw StateError('List item not supported');
    }
  }

  @override
  Future<void> saveToDatabase(AListItemModel item) async {
    if (item is WalletListItemModel) {
      await _walletsService.saveWallet(item.walletModel);
    } else {
      throw StateError('List item not supported');
    }
  }

  @override
  Future<List<AListItemModel>> filterBySearchPattern(List<AListItemModel> allItems, String searchPattern) async {
    List<WalletListItemModel> walletListItemModels = allItems.whereType<WalletListItemModel>().toList();

    List<WalletListItemModel> filteredWallets = walletListItemModels.where((WalletListItemModel item) {
      return item.name.toLowerCase().contains(searchPattern.toLowerCase());
    }).toList();

    return <AListItemModel>[...filteredWallets];
  }

  @override
  List<AListItemModel> sortItems(List<AListItemModel> items) {
    List<WalletListItemModel> walletListItemModels = items.whereType<WalletListItemModel>().toList()
      ..sort((WalletListItemModel a, WalletListItemModel b) {
        return a.walletModel.index.compareTo(b.walletModel.index);
      });

    List<WalletListItemModel> pinnedWallets = walletListItemModels.where((WalletListItemModel item) => item.walletModel.pinnedBool).toList();
    List<WalletListItemModel> unpinnedWallets = walletListItemModels.where((WalletListItemModel item) => item.walletModel.pinnedBool == false).toList();

    return <AListItemModel>[...pinnedWallets, ...unpinnedWallets];
  }

  Future<WalletListItemModel> _buildWalletListItemModel(WalletModel walletModel) async {
    bool defaultPasswordBool = await _secretsService.isSecretsPasswordValid(walletModel.containerPathModel, PasswordModel.defaultPassword());
    WalletListItemModel walletListItemModel = WalletListItemModel(
      encryptedBool: defaultPasswordBool == false,
      walletModel: walletModel,
    );
    return walletListItemModel;
  }
}
