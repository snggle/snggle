import 'dart:async';

import 'package:snggle/bloc/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletListPageCubit extends AListCubit<WalletListItemModel> {
  final ContainerPathModel containerPathModel;
  final PasswordModel vaultPasswordModel;
  final WalletsService _walletsService;
  final SecretsService _secretsService;

  WalletListPageCubit({
    required this.containerPathModel,
    required this.vaultPasswordModel,
    WalletsService? walletsService,
    SecretsService? secretsService,
  })  : _walletsService = walletsService ?? globalLocator<WalletsService>(),
        _secretsService = secretsService ?? globalLocator<SecretsService>();

  @override
  Future<void> deleteFromDatabase(WalletListItemModel item) async {
    await _walletsService.deleteWalletById(item.walletModel.uuid);
  }

  @override
  Future<List<WalletListItemModel>> fetchAllFromDatabase() async {
    List<WalletModel> walletModelList = await _walletsService.getWalletList(containerPathModel.path);

    List<WalletListItemModel> walletListItemModelList = <WalletListItemModel>[];
    for (WalletModel walletModel in walletModelList) {
      WalletListItemModel walletListItemModel = await _buildWalletListItemModel(walletModel);
      walletListItemModelList.add(walletListItemModel);
    }

    return walletListItemModelList;
  }

  @override
  Future<WalletListItemModel> fetchSingleFromDatabase(WalletListItemModel item) async {
    List<WalletModel> walletModelList = await _walletsService.getWalletList(containerPathModel.path);

    WalletModel walletModel = walletModelList.firstWhere((WalletModel element) => element.uuid == item.walletModel.uuid);
    WalletListItemModel walletListItemModel = await _buildWalletListItemModel(walletModel);

    return walletListItemModel;
  }

  @override
  Future<void> saveToDatabase(WalletListItemModel item) async {
    await _walletsService.saveWallet(item.walletModel);
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
