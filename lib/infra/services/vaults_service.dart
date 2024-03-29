import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class VaultsService {
  final VaultsRepository _vaultsRepository;
  final SecretsService _secretsService;
  final WalletsService _walletsService;

  VaultsService({
    VaultsRepository? vaultsRepository,
    SecretsService? secretsService,
    WalletsService? walletsService,
  })  : _vaultsRepository = vaultsRepository ?? globalLocator<VaultsRepository>(),
        _secretsService = secretsService ?? globalLocator<SecretsService>(),
        _walletsService = walletsService ?? globalLocator<WalletsService>();

  Future<int> getLastVaultIndex() async {
    List<VaultEntity> vaultEntityList = await _vaultsRepository.getAll();
    if (vaultEntityList.isEmpty) {
      return -1;
    }
    List<int> vaultEntityIndexList = vaultEntityList.map((VaultEntity vaultEntity) => vaultEntity.index).toList();
    int currentMaxIndex = vaultEntityIndexList.reduce((int currentMaxIndex, int currentIndex) {
      return currentMaxIndex > currentIndex ? currentMaxIndex : currentIndex;
    });
    return currentMaxIndex;
  }

  Future<List<VaultModel>> getVaultList() async {
    VaultModelFactory vaultModelFactory = VaultModelFactory(vaultsService: this);

    List<VaultEntity> vaultEntityList = await _vaultsRepository.getAll();
    List<VaultModel> vaultModelList = vaultEntityList.map(vaultModelFactory.createFromEntity).toList();
    return vaultModelList;
  }

  Future<VaultModel> getVaultById(String uuid) async {
    VaultEntity vaultEntity = await _vaultsRepository.getById(uuid);
    VaultModelFactory vaultModelFactory = VaultModelFactory(vaultsService: this);

    return vaultModelFactory.createFromEntity(vaultEntity);
  }

  Future<void> saveVault(VaultModel vaultModel) async {
    await _vaultsRepository.save(VaultEntity.fromVaultModel(vaultModel));
  }

  Future<void> deleteVaultById(String uuid) async {
    List<WalletModel> walletModels = await _walletsService.getWalletList(uuid);
    for (WalletModel walletModel in walletModels) {
      await _walletsService.deleteWalletById(walletModel.containerPathModel.fullPath);
    }

    VaultModel vaultModel = await getVaultById(uuid);
    await _secretsService.deleteSecrets(vaultModel.containerPathModel);
    await _vaultsRepository.deleteById(uuid);
  }
}
