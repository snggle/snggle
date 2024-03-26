import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/wallet_list_page/wallet_list_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_selection_model.dart';

class WalletListPageCubit extends Cubit<WalletListPageState> {
  final AContainerModel containerModel;
  final PasswordModel vaultPasswordModel;
  final WalletsService _walletsService;
  final SecretsService _secretsService;

  WalletListPageCubit({
    required this.containerModel,
    required this.vaultPasswordModel,
    WalletsService? walletsService,
    SecretsService? secretsService,
  })  : _walletsService = walletsService ?? globalLocator<WalletsService>(),
        _secretsService = secretsService ?? globalLocator<SecretsService>(),
        super(WalletListPageState(loadingBool: true));

  Future<void> deleteWallet(WalletListItemModel walletListItemModel) async {
    await _walletsService.deleteWalletById(walletListItemModel.walletModel.uuid);
    await refreshAll();
  }

  Future<void> refreshAll() async {
    List<WalletListItemModel> walletListItemModelList = <WalletListItemModel>[];
    List<WalletModel> walletModelList = await _walletsService.getWalletList(containerModel.containerPathModel.path);
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
