import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletsService {
  final WalletsRepository _walletsRepository;

  WalletsService({
    WalletsRepository? walletsRepository,
  }) : _walletsRepository = walletsRepository ?? globalLocator<WalletsRepository>();

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

  Future<List<WalletModel>> getWalletList(String vaultUuid) async {
    WalletModelFactory walletModelFactory = globalLocator<WalletModelFactory>();
    List<WalletEntity> walletEntityList = await _walletsRepository.getAll();
    walletEntityList = walletEntityList.where((WalletEntity walletEntity) => walletEntity.vaultUuid == vaultUuid).toList();

    List<WalletModel> walletModelList = walletEntityList.map(walletModelFactory.createFromEntity).toList();
    return walletModelList;
  }

  Future<void> saveWallet(WalletModel walletModel) async {
    await _walletsRepository.save(WalletEntity.fromWalletModel(walletModel));
  }

  Future<void> deleteWalletById(String uuid) {
    return _walletsRepository.deleteById(uuid);
  }
}
