import 'dart:async';
import 'dart:typed_data';

import 'package:hd_wallet/hd_wallet.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletListPageCubit extends AListCubit<WalletModel> {
  final WalletsService _walletsService = globalLocator<WalletsService>();

  final VaultModel vaultModel;
  final PasswordModel vaultPasswordModel;

  WalletListPageCubit({
    required super.depth,
    required super.filesystemPath,
    required this.vaultModel,
    required this.vaultPasswordModel,
  }) : super(
          listItemsService: globalLocator<WalletsService>(),
          childItemsServices: <IListItemsService<AListItemModel>>[],
        );

  // TODO(dominik): Temporary solution to create new wallet.
  // The process of creating a new wallet will be extracted into a separate page with its own designs.
  Future<void> createNewWallet() async {
    WalletModelFactory walletModelFactory = globalLocator<WalletModelFactory>();
    VaultSecretsModel vaultSecretsModel = await secretsService.get(vaultModel.filesystemPath, vaultPasswordModel);

    // This section is used to determine the next derivation path segment for the new wallet
    // In current demo app, this value is calculated automatically, basing on the last wallet index existing in database
    // In the targeted app this value should be provided (or confirmed) by user an this functionality will be implemented on the next stages
    int lastWalletIndex = await _walletsService.getLastDerivationIndex(state.filesystemPath);
    int walletIndex = lastWalletIndex + 1;
    String derivationPath = "m/44'/60'/0'/0/${walletIndex}";

    // Seed calculation also will be changed (moved to the separate class). Currently, for the work organization reasons,
    // app allows to generate only one wallet type and this functionality is mocked here
    Uint8List seed = await vaultSecretsModel.mnemonicModel.calculateSeed();
    BIP32 rootNode = BIP32.fromSeed(seed);
    BIP32 derivedNode = rootNode.derivePath(derivationPath);

    await walletModelFactory.createNewWallet(
      WalletCreationRequestModel(
        derivationPath: derivationPath,
        publicKey: derivedNode.publicKey,
        privateKey: derivedNode.privateKey!,
        parentFilesystemPath: state.filesystemPath,
        name: 'Wallet ${walletIndex}',
      ),
    );

    await refreshAll();
  }
}
