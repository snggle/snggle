import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletsService implements IListItemsService<WalletModel> {
  final WalletsRepository _walletsRepository = globalLocator<WalletsRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  @override
  Future<List<WalletModel>> getAllByParentPath(FilesystemPath parentFilesystemPath, {bool firstLevelBool = false, bool previewEmptyBool = false}) async {
    WalletModelFactory walletModelFactory = globalLocator<WalletModelFactory>();

    List<WalletEntity> walletEntityList = await _walletsRepository.getAllByParentPath(parentFilesystemPath);
    walletEntityList = walletEntityList.where((WalletEntity walletEntity) {
      return walletEntity.filesystemPath.isSubPathOf(parentFilesystemPath, firstLevelBool: firstLevelBool);
    }).toList();

    List<WalletModel> walletModelList = walletModelFactory.createFromEntities(walletEntityList);
    return walletModelList;
  }

  @override
  Future<WalletModel> getById(int id) async {
    WalletEntity walletEntity = await _walletsRepository.getById(id);
    return globalLocator<WalletModelFactory>().createFromEntity(walletEntity);
  }

  @override
  Future<void> move(WalletModel listItem, FilesystemPath newFilesystemPath) async {
    WalletModel movedWalletModel = listItem.copyWith(filesystemPath: newFilesystemPath);
    await save(movedWalletModel);
    await _secretsService.move(listItem.filesystemPath, movedWalletModel.filesystemPath);
  }

  @override
  Future<void> moveAllByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
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

  @override
  Future<int> save(WalletModel listItem) async {
    return _walletsRepository.save(WalletEntity.fromWalletModel(listItem));
  }

  @override
  Future<List<int>> saveAll(List<WalletModel> listItems) async {
    return _walletsRepository.saveAll(listItems.map(WalletEntity.fromWalletModel).toList());
  }

  @override
  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<WalletModel> walletModelList = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);

    // Sort wallets by the length of their paths, ensuring the deepest wallet is deleted first
    walletModelList.sort((WalletModel a, WalletModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (WalletModel walletModel in walletModelList) {
      await _secretsService.delete(walletModel.filesystemPath);
      await _walletsRepository.deleteById(walletModel.id);
    }
  }

  @override
  Future<void> deleteById(int id) async {
    WalletModel walletModel = await getById(id);

    await _secretsService.delete(walletModel.filesystemPath);
    await _walletsRepository.deleteById(id);
  }

  Future<WalletModel> getByAddress(String address) async {
    WalletEntity walletEntity = await _walletsRepository.getByAddress(address);
    return globalLocator<WalletModelFactory>().createFromEntity(walletEntity);
  }

  Future<int> getLastIndex(FilesystemPath parentFilesystemPath) async {
    int? lastIndex = await _walletsRepository.getLastIndex(parentFilesystemPath);
    return lastIndex ?? -1;
  }

  Future<int> getLastDerivationIndex(FilesystemPath parentFilesystemPath) async {
    List<String> derivationPaths = await _walletsRepository.getAllDerivationPaths(parentFilesystemPath);
    List<int> derivationIndexes = derivationPaths.map((String derivationPath) {
      return int.parse(derivationPath.replaceAll("''", '').split('/').last);
    }).toList()
      ..sort();

    return derivationIndexes.isEmpty ? -1 : derivationIndexes.last;
  }

  Future<bool> isDerivationPathExists(FilesystemPath parentFilesystemPath, String derivationPathString) async {
    List<String> derivationPaths = await _walletsRepository.getAllDerivationPaths(parentFilesystemPath);
    return derivationPaths.contains(derivationPathString);
  }

  Future<WalletModel> updateFilesystemPath(int id, FilesystemPath parentFilesystemPath) async {
    WalletEntity walletEntity = await _walletsRepository.getById(id);
    walletEntity = walletEntity.copyWith(filesystemPathString: parentFilesystemPath.add('wallet$id').fullPath);
    await _walletsRepository.save(walletEntity);
    return globalLocator<WalletModelFactory>().createFromEntity(walletEntity);
  }
}
