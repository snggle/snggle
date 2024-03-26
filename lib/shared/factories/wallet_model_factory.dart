import 'package:blockchain_utils/bip/address/encoders.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:uuid/uuid.dart';

class WalletModelFactory {
  Future<WalletModel> createNewWallet(WalletCreationRequestModel walletCreationRequestModel) async {
    String uuid = const Uuid().v4();

    return WalletModel(
      pinnedBool: false,
      index: walletCreationRequestModel.index,
      uuid: uuid,
      vaultUuid: walletCreationRequestModel.vaultUuid,
      name: walletCreationRequestModel.name,
      type: walletCreationRequestModel.type,
      address: AtomAddrEncoder().encodeKey(walletCreationRequestModel.publicKey, <String, dynamic>{'hrp': walletCreationRequestModel.type}),
      containerPathModel: ContainerPathModel.fromString(walletCreationRequestModel.parentContainerPathModel.deriveChildPath(uuid)),
      derivationPath: walletCreationRequestModel.derivationPath,
    );
  }

  WalletModel createFromEntity(WalletEntity walletEntity) {
    return WalletModel(
      pinnedBool: walletEntity.pinnedBool,
      index: walletEntity.index,
      uuid: walletEntity.uuid,
      vaultUuid: walletEntity.accessPath,
      type: walletEntity.type,
      address: walletEntity.address,
      derivationPath: walletEntity.derivationPath,
      containerPathModel: ContainerPathModel.fromString(walletEntity.accessPath),
      name: walletEntity.name,
    );
  }
}
