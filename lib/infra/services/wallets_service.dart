import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletsService {
  final WalletsRepository _walletsRepository = globalLocator<WalletsRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<WalletModel> updateFilesystemPath(int id, FilesystemPath parentFilesystemPath) async {
    WalletEntity walletEntity = await _walletsRepository.getById(id);
    walletEntity = walletEntity.copyWith(filesystemPathString: parentFilesystemPath.add('wallet$id').fullPath);
    await _walletsRepository.save(walletEntity);
    return globalLocator<WalletModelFactory>().createFromEntity(walletEntity);
  }

  Future<int> getLastIndex(FilesystemPath parentFilesystemPath) async {
    int? lastIndex = await _walletsRepository.getLastIndex(parentFilesystemPath);
    return lastIndex ?? -1;
  }

  Future<WalletModel> getById(int id) async {
    WalletEntity walletEntity = await _walletsRepository.getById(id);
    return globalLocator<WalletModelFactory>().createFromEntity(walletEntity);
  }

  Future<List<WalletModel>> getAllByParentPath(FilesystemPath parentFilesystemPath, {bool firstLevelBool = false}) async {
    WalletModelFactory walletModelFactory = globalLocator<WalletModelFactory>();

    List<WalletEntity> walletEntityList = await _walletsRepository.getAllByParentPath(parentFilesystemPath);
    walletEntityList = walletEntityList.where((WalletEntity walletEntity) {
      return walletEntity.filesystemPath.isSubPathOf(parentFilesystemPath, firstLevelBool: firstLevelBool);
    }).toList();

    List<WalletModel> walletModelList = walletModelFactory.createFromEntities(walletEntityList);
    return walletModelList;
  }

  Future<void> move(WalletModel walletModel, FilesystemPath newFilesystemPath) async {
    WalletModel movedWalletModel = walletModel.copyWith(filesystemPath: newFilesystemPath);
    await save(movedWalletModel);
    await _secretsService.move(walletModel.filesystemPath, movedWalletModel.filesystemPath);
  }

  Future<void> moveByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    List<WalletModel> walletModelsToMove = await getAllByParentPath(previousFilesystemPath, firstLevelBool: false);
    for (int i = 0; i < walletModelsToMove.length; i++) {
      WalletModel walletModel = walletModelsToMove[i];
      WalletModel updatedWalletModel = walletModel.copyWith(
        filesystemPath: walletModel.filesystemPath.replace(previousFilesystemPath.fullPath, newFilesystemPath.fullPath),
      );

      walletModelsToMove[i] = updatedWalletModel;
      await _secretsService.move(walletModel.filesystemPath, updatedWalletModel.filesystemPath);
    }

    await saveAll(walletModelsToMove);
  }

  Future<int> save(WalletModel walletModel) async {
    return _walletsRepository.save(WalletEntity.fromWalletModel(walletModel));
  }

  Future<List<int>> saveAll(List<WalletModel> walletModelList) async {
    return _walletsRepository.saveAll(walletModelList.map(WalletEntity.fromWalletModel).toList());
  }

  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<WalletModel> walletModelList = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);
    walletModelList.sort((WalletModel a, WalletModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (WalletModel walletModel in walletModelList) {
      await _secretsService.delete(walletModel.filesystemPath);
      await _walletsRepository.deleteById(walletModel.id);
    }
  }

  Future<void> deleteById(int id) async {
    WalletModel walletModel = await getById(id);

    await _secretsService.delete(walletModel.filesystemPath);
    await _walletsRepository.deleteById(id);
  }
}
