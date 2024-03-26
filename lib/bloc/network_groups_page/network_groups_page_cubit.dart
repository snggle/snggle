import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hd_wallet/hd_wallet.dart';
import 'package:snggle/bloc/network_groups_page/network_groups_page_state.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/groups/network_group_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

class NetworkGroupsPageCubit extends Cubit<NetworkGroupsPageState> {
  final VaultModel vaultModel;
  final PasswordModel vaultPasswordModel;
  final WalletsService _walletsService;
  final SecretsService _secretsService;

  NetworkGroupsPageCubit({
    required this.vaultModel,
    required this.vaultPasswordModel,
    WalletsService? walletsService,
    SecretsService? secretsService,
  })  : _walletsService = walletsService ?? globalLocator<WalletsService>(),
        _secretsService = secretsService ?? globalLocator<SecretsService>(),
        super(NetworkGroupsPageState(loadingBool: true));

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

  Future<void> refreshAll() async {
    List<NetworkGroupListItemModel> networkGroupListItemModelList = <NetworkGroupListItemModel>[];

    for (NetworkConfigModel networkConfigModel in NetworkConfigModel.allNetworks) {
      String accessPath = vaultModel.containerPathModel.deriveChildPath(networkConfigModel.id);
      List<WalletModel> walletModels = await _walletsService.getWalletList(accessPath, strictBool: false);

      networkGroupListItemModelList.add(NetworkGroupListItemModel(
        encryptedBool: false,
        networkConfigModel: networkConfigModel,
        walletsPreview: walletModels,
        containerPathModel: ContainerPathModel.fromString(accessPath),
      ));
    }

    emit(NetworkGroupsPageState(loadingBool: false, allNetworks: networkGroupListItemModelList));
  }
}

class NetworkConfigModel extends Equatable {
  static const NetworkConfigModel kira = NetworkConfigModel(id: 'kira', name: 'Kira', iconData: AppIcons.token_kira);
  static const NetworkConfigModel ethereum = NetworkConfigModel(id: 'ethereum', name: 'Ethereum', iconData: AppIcons.token_eth);
  static const NetworkConfigModel polkadot = NetworkConfigModel(id: 'polkadot', name: 'Polkadot', iconData: AppIcons.token_polkadot);
  static const NetworkConfigModel bitcoin = NetworkConfigModel(id: 'bitcoin', name: 'Bitcoin', iconData: AppIcons.token_btc);
  static const NetworkConfigModel cosmos = NetworkConfigModel(id: 'cosmos', name: 'Cosmos', iconData: AppIcons.token_cosmos);

  static const List<NetworkConfigModel> allNetworks = <NetworkConfigModel>[kira, ethereum, polkadot, bitcoin, cosmos];

  final String id;
  final String name;
  final IconData iconData;

  const NetworkConfigModel({
    required this.id,
    required this.name,
    required this.iconData,
  });

  @override
  List<Object?> get props => <Object>[id, name, iconData];
}
