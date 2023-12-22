import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/wallet_list_item/wallet_list_item_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/wallet_secrets_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

// TODO(dominik): Temporary cubit implementation. Created for demo purposes.
// After UI / list implementation responsibility of this cubit may be significantly rebuilt.
// For this reason, this cubit is not covered by tests, which should be added during UI implementation.
class WalletListItemCubit extends Cubit<WalletListItemState> {
  final WalletSecretsService _walletSecretsService = globalLocator<WalletSecretsService>();
  final WalletModel walletModel;

  WalletListItemCubit({
    required this.walletModel,
  }) : super(const WalletListItemState.decrypted());

  Future<void> init() async {
    bool defaultPasswordBool = await _walletSecretsService.isSecretsPasswordValid(walletModel.uuid, PasswordModel.defaultPassword());
    if (defaultPasswordBool == true) {
      emit(const WalletListItemState.decrypted());
    } else {
      emit(const WalletListItemState.encrypted(lockedBool: true));
    }
  }

  Future<void> setPassword(PasswordModel passwordModel) async {
    PasswordModel oldPasswordModel = PasswordModel.defaultPassword();
    PasswordModel newPasswordModel = passwordModel;

    WalletSecretsModel walletSecretsModel = await _walletSecretsService.getSecrets(walletModel.uuid, oldPasswordModel);
    await _walletSecretsService.saveSecrets(walletSecretsModel, newPasswordModel);

    emit(const WalletListItemState.encrypted(lockedBool: false));
  }

  Future<void> removePassword(PasswordModel passwordModel) async {
    PasswordModel oldPasswordModel = passwordModel;
    PasswordModel newPasswordModel = PasswordModel.defaultPassword();

    WalletSecretsModel walletSecretsModel = await _walletSecretsService.getSecrets(walletModel.uuid, oldPasswordModel);
    await _walletSecretsService.saveSecrets(walletSecretsModel, newPasswordModel);

    emit(const WalletListItemState.decrypted());
  }

  Future<void> lock() async {
    emit(const WalletListItemState.encrypted(lockedBool: true));
  }

  Future<void> unlock(PasswordModel walletPasswordModel) async {
    bool passwordValidBool = await _walletSecretsService.isSecretsPasswordValid(walletModel.uuid, walletPasswordModel);
    bool lockedBool = passwordValidBool == false;
    emit(WalletListItemState.encrypted(lockedBool: lockedBool));
  }

  Future<WalletSecretsModel> getWalletSecrets(PasswordModel walletPasswordModel) async {
    WalletSecretsModel walletSecretsModel = await _walletSecretsService.getSecrets(walletModel.uuid, walletPasswordModel);
    return walletSecretsModel;
  }
}
