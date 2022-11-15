import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/dao/vault/request/save_wallet_request.dart';
import 'package:snuggle/infra/dao/wallet/wallet_dao.dart';
import 'package:snuggle/infra/mappers/wallet_secrets_mapper.dart';
import 'package:snuggle/infra/repository/wallets_repository.dart';
import 'package:snuggle/shared/models/address_model.dart';
import 'package:snuggle/shared/models/vaults/vault_info_model.dart';
import 'package:snuggle/shared/models/wallet/wallet_model.dart';

class WalletsService {
  final WalletsRepository _walletsRepository = globalLocator<WalletsRepository>();

  Future<void> save(WalletModel walletModel) async {
    return _walletsRepository.save(
      SaveWalletRequest(
        vaultId: walletModel.parentVaultInfoModel.id,
        walletDao: WalletDao(
          id: walletModel.id,
          name: walletModel.name,
          address: walletModel.addressModel.bech32Address,
          walletSecretsDao: WalletSecretsMapper.mapWalletSecretsModelToDao(walletModel.walletSecretsModel),
        ),
      ),
    );
  }

  Future<List<AddressModel>> getAllWalletAddresses(String vaultId) async {
    List<WalletDao> walletDaoList = await _walletsRepository.getAll(vaultId);
    return walletDaoList.map((WalletDao walletDao) => AddressModel.fromBech32(walletDao.address)).toList();
  }

  Future<List<WalletModel>> getAll(VaultInfoModel vaultInfoModel) async {
    List<WalletDao> walletDaoList = await _walletsRepository.getAll(vaultInfoModel.id);
    return walletDaoList.map((WalletDao walletDao) {
      return WalletModel(
        id: walletDao.id,
        name: walletDao.name,
        addressModel: AddressModel.fromBech32(walletDao.address),
        parentVaultInfoModel: vaultInfoModel,
        walletSecretsModel: WalletSecretsMapper.mapWalletSecretsDaoToModel(walletDao.walletSecretsDao),
      );
    }).toList();
  }
}
