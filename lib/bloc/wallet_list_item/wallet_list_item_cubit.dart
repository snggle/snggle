import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/wallet_list_item/wallet_list_item_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/multi_password_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

// TODO(dominik): Temporary cubit implementation. Created for demo purposes.
// After UI / list implementation responsibility of this cubit may be significantly rebuilt.
// For this reason, this cubit is not covered by tests, which should be added during UI implementation.
class WalletListItemCubit extends Cubit<WalletListItemState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final PasswordModel vaultPasswordModel;
  final WalletModel walletModel;

  WalletListItemCubit({
    required this.vaultPasswordModel,
    required this.walletModel,
  }) : super(const WalletListItemState.decrypted());

  Future<void> init() async {
    MultiPasswordModel walletMultiPasswordModel = vaultPasswordModel.extend(PasswordModel.defaultPassword());
    bool defaultPasswordBool = await _secretsService.isSecretsPasswordValid(walletModel.path, walletMultiPasswordModel);
    if (defaultPasswordBool == true) {
      emit(const WalletListItemState.decrypted());
    } else {
      emit(const WalletListItemState.encrypted(lockedBool: true));
    }
  }

  Future<void> setPassword(PasswordModel passwordModel) async {
    MultiPasswordModel oldWalletMultiPasswordModel = vaultPasswordModel.extend(PasswordModel.defaultPassword());
    MultiPasswordModel newWalletMultiPasswordModel = vaultPasswordModel.extend(passwordModel);

    await _secretsService.changeParentPassword(walletModel.path, oldWalletMultiPasswordModel, newWalletMultiPasswordModel);
    emit(const WalletListItemState.encrypted(lockedBool: false));
  }

  Future<void> removePassword(PasswordModel passwordModel) async {
    MultiPasswordModel oldWalletMultiPasswordModel = vaultPasswordModel.extend(passwordModel);
    MultiPasswordModel newWalletMultiPasswordModel = vaultPasswordModel.extend(PasswordModel.defaultPassword());
    await _secretsService.changeParentPassword(walletModel.path, oldWalletMultiPasswordModel, newWalletMultiPasswordModel);
    emit(const WalletListItemState.decrypted());
  }

  Future<void> lock() async {
    emit(const WalletListItemState.encrypted(lockedBool: true));
  }

  Future<void> unlock(PasswordModel walletPasswordModel) async {
    MultiPasswordModel walletMultiPasswordModel = vaultPasswordModel.extend(walletPasswordModel);

    bool passwordValidBool = await _secretsService.isSecretsPasswordValid(walletModel.path, walletMultiPasswordModel);
    bool lockedBool = passwordValidBool == false;
    emit(WalletListItemState.encrypted(lockedBool: lockedBool));
  }

  Future<WalletSecretsModel> getWalletSecrets(PasswordModel walletPasswordModel) async {
    MultiPasswordModel walletMultiPasswordModel = vaultPasswordModel.extend(walletPasswordModel);
    WalletSecretsModel walletSecretsModel = await _secretsService.getSecrets(walletModel.path, walletMultiPasswordModel);
    return walletSecretsModel;
  }
}
