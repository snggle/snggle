import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hd_wallet/hd_wallet.dart';
import 'package:snggle/bloc/wallet_list_page/wallet_list_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_selection_model.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart';

class WalletListPageCubit extends Cubit<WalletListPageState> {
  final VaultModel vaultModel;
  final PasswordModel vaultPasswordModel;
  final WalletsService _walletsService;
  final SecretsService _secretsService;

  WalletListPageCubit({
    required this.vaultModel,
    required this.vaultPasswordModel,
    WalletsService? walletsService,
    SecretsService? secretsService,
  })  : _walletsService = walletsService ?? globalLocator<WalletsService>(),
        _secretsService = secretsService ?? globalLocator<SecretsService>(),
        super(WalletListPageState(loadingBool: true));

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
        vaultUuid: vaultModel.uuid,
        publicKey: derivedNode.publicKey,
        derivationPath: derivationPath,
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

  Future<void> deleteWallet(WalletListItemModel walletListItemModel) async {
    await _walletsService.deleteWalletById(walletListItemModel.walletModel.uuid);
    await refreshAll();
  }

  Future<void> refreshAll() async {
    List<WalletListItemModel> walletListItemModelList = <WalletListItemModel>[];
    List<WalletModel> walletModelList = await _walletsService.getWalletList(vaultModel.uuid);
    for (WalletModel walletModel in walletModelList) {
      bool defaultPasswordBool = await _secretsService.isSecretsPasswordValid(walletModel.containerPathModel, PasswordModel.defaultPassword());
      WalletListItemModel walletListItemModel = WalletListItemModel(
        encryptedBool: defaultPasswordBool == false,
        walletModel: walletModel,
      );
      walletListItemModelList.add(walletListItemModel);
    }

    emit(WalletListPageState(loadingBool: false, allWallets: walletListItemModelList));
  }

  void searchWallets(String? searchPattern) {
    emit(WalletListPageState(
      loadingBool: false,
      searchBoxVisibleBool: searchPattern != null,
      walletSelectionModel: state.walletSelectionModel,
      searchPattern: searchPattern,
      allWallets: state.allWallets,
    ));
  }

  void selectWallet(WalletListItemModel walletListItemModel) {
    List<WalletListItemModel> selectedWallets = List<WalletListItemModel>.from(state.selectedWallets, growable: true)..add(walletListItemModel);
    emit(state.copyWith(walletSelectionModel: WalletSelectionModel(selectedWallets)));
  }

  void selectAll() {
    if (state.selectedWallets.length == state.allWallets.length) {
      emit(state.copyWith(walletSelectionModel: WalletSelectionModel.empty()));
    } else {
      emit(state.copyWith(walletSelectionModel: WalletSelectionModel(state.allWallets)));
    }
  }

  void unselectWallet(WalletListItemModel walletListItemModel) {
    List<WalletListItemModel> selectedWallets = List<WalletListItemModel>.from(state.selectedWallets, growable: true)..remove(walletListItemModel);
    emit(state.copyWith(walletSelectionModel: WalletSelectionModel(selectedWallets)));
  }

  void disableSelection() {
    emit(WalletListPageState(allWallets: state.allWallets, loadingBool: false));
  }

  Future<void> updatePinnedWallets({required List<WalletListItemModel> selectedWallets, required bool pinnedBool}) async {
    List<WalletListItemModel> newWallets = state.allWallets;
    for (int i = 0; i < newWallets.length; i++) {
      WalletListItemModel walletListItemModel = newWallets[i];
      if (selectedWallets.contains(walletListItemModel)) {
        WalletModel walletModel = walletListItemModel.walletModel.copyWith(pinnedBool: pinnedBool);
        newWallets[i] = walletListItemModel.copyWith(walletModel: walletModel);
        unawaited(_walletsService.saveWallet(walletModel));
      }
    }
    emit(WalletListPageState(allWallets: newWallets, loadingBool: false));
  }

  Future<void> updateEncryptedWallets({required List<WalletListItemModel> selectedWallets, required bool encryptedBool}) async {
    List<WalletListItemModel> newWallets = List<WalletListItemModel>.from(state.allWallets);
    for (int i = 0; i < newWallets.length; i++) {
      WalletListItemModel walletListItemModel = newWallets[i];
      if (selectedWallets.contains(walletListItemModel)) {
        // TODO(dominik): Temporary solution to get user password. After implementing "secrets-pin-pages-ui" this condition should be replaced by custom page requesting user's password
        if (encryptedBool) {
          WalletSecretsModel secretsModel = await _secretsService.getSecrets(walletListItemModel.walletModel.containerPathModel, PasswordModel.defaultPassword());
          unawaited(_secretsService.saveSecrets(secretsModel, PasswordModel.fromPlaintext('1111')));
        } else {
          WalletSecretsModel secretsModel = await _secretsService.getSecrets(
            walletListItemModel.walletModel.containerPathModel,
            PasswordModel.fromPlaintext('1111'),
          );
          unawaited(_secretsService.saveSecrets(secretsModel, PasswordModel.defaultPassword()));
        }

        newWallets[i] = walletListItemModel.copyWith(encryptedBool: encryptedBool);
      }
    }
    emit(WalletListPageState(allWallets: newWallets, loadingBool: false));
  }
}
