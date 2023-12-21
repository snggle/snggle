import 'package:blockchain_utils/bip/address/encoders.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:uuid/uuid.dart';

class WalletModelFactory {
  Future<WalletModel> createNewWallet(WalletCreationRequestModel walletCreationRequestModel) async {
    return WalletModel(
      index: walletCreationRequestModel.index,
      uuid: const Uuid().v4(),
      vaultUuid: walletCreationRequestModel.vaultUuid,
      name: walletCreationRequestModel.name,
      address: AtomAddrEncoder().encodeKey(walletCreationRequestModel.publicKey, <String, dynamic>{'hrp': 'kira'}),
      derivationPath: walletCreationRequestModel.derivationPath,
    );
  }

  WalletModel createFromEntity(WalletEntity walletEntity) {
    return WalletModel(
      index: walletEntity.index,
      uuid: walletEntity.uuid,
      vaultUuid: walletEntity.vaultUuid,
      address: walletEntity.address,
      derivationPath: walletEntity.derivationPath,
      name: walletEntity.name,
    );
  }
}
