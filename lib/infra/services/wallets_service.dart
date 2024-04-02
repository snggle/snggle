import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletsService {
  final WalletsRepository _walletsRepository;
  final SecretsService _secretsService;

  WalletsService({
    WalletsRepository? walletsRepository,
    SecretsService? secretsService,
  })  : _walletsRepository = walletsRepository ?? globalLocator<WalletsRepository>(),
        _secretsService = secretsService ?? globalLocator<SecretsService>();

  Future<int> getLastWalletIndex(String vaultUuid) async {
    List<WalletModel> walletModelList = await getWalletList(vaultUuid);
    List<int> walletIndexList = walletModelList.map((WalletModel walletModel) => walletModel.index).toList();

    if (walletIndexList.isEmpty) {
      return -1;
    }
    int currentMaxIndex = walletIndexList.reduce((int currentMaxIndex, int currentIndex) {
      return currentMaxIndex > currentIndex ? currentMaxIndex : currentIndex;
    });
    return currentMaxIndex;
  }

  Future<List<WalletModel>> getWalletList(String path, {bool strictBool = false}) async {
    WalletModelFactory walletModelFactory = WalletModelFactory();
    List<WalletEntity> walletEntityList = await _walletsRepository.getAll();
    walletEntityList = walletEntityList.where((WalletEntity walletEntity) {
      return strictBool ? walletEntity.parentPath == path : walletEntity.parentPath.startsWith(path);
    }).toList();

    List<WalletModel> walletModelList = walletEntityList.map(walletModelFactory.createFromEntity).toList();
    return walletModelList;
  }

  Future<void> saveWallet(WalletModel walletModel) async {
    await _walletsRepository.save(WalletEntity.fromWalletModel(walletModel));
  }

  Future<void> deleteWalletById(String uuid) async {
    WalletModel walletModel = await getById(uuid);
    await _secretsService.deleteSecrets(walletModel.containerPathModel);
    await _walletsRepository.deleteById(uuid);
  }

  Future<void> moveWallet(String uuid, ContainerPathModel newParentPath) async {
    WalletModel previousWalletModel = await getById(uuid);

    WalletModel movedWalletModel = previousWalletModel.copyWith(parentPath: newParentPath.fullPath);
    await saveWallet(movedWalletModel);
    await _secretsService.moveSecrets(previousWalletModel.containerPathModel, movedWalletModel.containerPathModel);
  }

  Future<WalletModel> getById(String uuid) async {
    WalletEntity walletEntity = await _walletsRepository.getById(uuid);
    WalletModelFactory walletModelFactory = WalletModelFactory();
    return walletModelFactory.createFromEntity(walletEntity);
  }
}
