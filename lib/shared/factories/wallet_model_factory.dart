import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletModelFactory {
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<WalletModel> createNewWallet(WalletCreationRequestModel walletCreationRequestModel) async {
    WalletModel walletModel = WalletModel(
      id: Isar.autoIncrement,
      encryptedBool: false,
      pinnedBool: false,
      index: walletCreationRequestModel.index,
      name: walletCreationRequestModel.name,
      address: walletCreationRequestModel.hdWallet.address,
      filesystemPath: const FilesystemPath.empty(),
      derivationPath: walletCreationRequestModel.derivationPathString,
    );

    int walletId = await _walletsService.save(walletModel);
    walletModel = await _walletsService.updateFilesystemPath(walletId, walletCreationRequestModel.parentFilesystemPath);

    WalletSecretsModel walletSecretsModel = WalletSecretsModel(
      filesystemPath: walletModel.filesystemPath,
      privateKey: walletCreationRequestModel.hdWallet.privateKey.bytes,
    );
    await _secretsService.save(walletSecretsModel, PasswordModel.defaultPassword());

    return walletModel;
  }

  List<WalletModel> createFromEntities(List<WalletEntity> walletEntityList) {
    return walletEntityList.map(createFromEntity).toList();
  }

  WalletModel createFromEntity(WalletEntity walletEntity) {
    return WalletModel(
      pinnedBool: walletEntity.pinnedBool,
      encryptedBool: walletEntity.encryptedBool,
      index: walletEntity.index,
      id: walletEntity.id,
      address: walletEntity.address,
      derivationPath: walletEntity.derivationPath,
      filesystemPath: walletEntity.filesystemPath,
      name: walletEntity.name,
    );
  }
}
