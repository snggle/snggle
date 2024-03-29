import 'package:blockchain_utils/bip/address/encoders.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:uuid/uuid.dart';

class WalletModelFactory {
  Future<WalletModel> createNewWallet(WalletCreationRequestModel walletCreationRequestModel) async {
    String uuid = const Uuid().v4();

    return WalletModel(
      encryptedBool: false,
      pinnedBool: false,
      index: walletCreationRequestModel.index,
      uuid: uuid,
      name: walletCreationRequestModel.name,
      network: walletCreationRequestModel.network,
      address: EthAddrEncoder().encodeKey(walletCreationRequestModel.publicKey),
      filesystemPath: FilesystemPath(<String>[...walletCreationRequestModel.parentFilesystemPath.pathSegments, uuid]),
      derivationPath: walletCreationRequestModel.derivationPath,
    );
  }

  WalletModel createFromEntity(WalletEntity walletEntity) {
    return WalletModel(
      pinnedBool: walletEntity.pinnedBool,
      encryptedBool: walletEntity.encryptedBool,
      index: walletEntity.index,
      uuid: walletEntity.uuid,
      network: walletEntity.network,
      address: walletEntity.address,
      derivationPath: walletEntity.derivationPath,
      filesystemPath: walletEntity.filesystemPath,
      name: walletEntity.name,
    );
  }
}
