import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletsService {
  final WalletsRepository _walletsRepository = globalLocator<WalletsRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<int> getLastIndex(FilesystemPath parentFilesystemPath) async {
    List<WalletModel> walletModelList = await getAllByParentPath(parentFilesystemPath);
    List<int> walletIndexList = walletModelList.map((WalletModel walletModel) => walletModel.index).toList();

    if (walletIndexList.isEmpty) {
      return -1;
    }
    int currentMaxIndex = walletIndexList.reduce((int currentMaxIndex, int currentIndex) {
      return currentMaxIndex > currentIndex ? currentMaxIndex : currentIndex;
    });
    return currentMaxIndex;
  }

  Future<WalletModel> getById(String uuid) async {
    WalletEntity walletEntity = await _walletsRepository.getById(uuid);
    WalletModelFactory walletModelFactory = WalletModelFactory();
    return walletModelFactory.createFromEntity(walletEntity);
  }

  Future<List<WalletModel>> getAllByParentPath(FilesystemPath parentFilesystemPath, {bool firstLevelBool = false}) async {
    List<WalletEntity> walletEntityList = await _walletsRepository.getAll();

    walletEntityList = walletEntityList.where((WalletEntity walletEntity) {
      return walletEntity.filesystemPath.isSubPathOf(parentFilesystemPath, singleLevelBool: firstLevelBool);
    }).toList();

    List<WalletModel> walletModelList = walletEntityList.map(globalLocator<WalletModelFactory>().createFromEntity).toList();
    return walletModelList..sort((WalletModel a, WalletModel b) => a.compareTo(b));
  }

  Future<void> save(WalletModel walletModel) async {
    await _walletsRepository.save(WalletEntity.fromWalletModel(walletModel));
  }

  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<WalletModel> walletModelList = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);
    walletModelList.sort((WalletModel a, WalletModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (WalletModel walletModel in walletModelList) {
      await _secretsService.delete(walletModel.filesystemPath);
      await _walletsRepository.deleteById(walletModel.uuid);
    }
  }

  Future<void> deleteById(String uuid) async {
    WalletModel walletModel = await getById(uuid);
    await _secretsService.delete(walletModel.filesystemPath);
    await _walletsRepository.deleteById(uuid);
  }
}
