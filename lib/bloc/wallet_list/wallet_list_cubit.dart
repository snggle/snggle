import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/infra/services/vaults_service.dart';
import 'package:snuggle/infra/services/wallets_service.dart';
import 'package:snuggle/shared/models/vaults/vault_info_model.dart';
import 'package:snuggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snuggle/shared/models/wallet/wallet_model.dart';

class WalletListCubit extends Cubit<List<WalletModel>> {
  final WalletsService _walletsService = WalletsService();
  final VaultInfoModel vaultInfoModel;

  WalletListCubit({
    required this.vaultInfoModel,
  }) : super(<WalletModel>[]);

  Future<void> reload() async {
    emit(await _walletsService.getAll(vaultInfoModel));
  }
}
