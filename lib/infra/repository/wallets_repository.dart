import 'dart:convert';

import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/dao/vault/request/save_vault_request.dart';
import 'package:snuggle/infra/dao/vault/request/save_wallet_request.dart';
import 'package:snuggle/infra/dao/vault/vault_dao.dart';
import 'package:snuggle/infra/dao/wallet/wallet_dao.dart';
import 'package:snuggle/shared/utils/vaults_secure_storage_manager.dart';

class WalletsRepository {
  final VaultsSecureStorageManager vaultsSecureStorageManager = globalLocator<VaultsSecureStorageManager>();

  Future<void> save(SaveWalletRequest saveWalletRequest) async {
    if (vaultsSecureStorageManager.vaultDaoMap[saveWalletRequest.vaultId] == null) {
      throw Exception('Vault with id ${saveWalletRequest.vaultId} not found.');
    }

    await vaultsSecureStorageManager.performWriteAction(() async {
      vaultsSecureStorageManager.vaultDaoMap[saveWalletRequest.vaultId]!.walletDaoMap[saveWalletRequest.walletDao.id] = saveWalletRequest.walletDao;
    });
  }

  Future<List<WalletDao>> getAll(String vaultId) async {
    if (vaultsSecureStorageManager.vaultDaoMap[vaultId] == null) {
      throw Exception('Vault with id ${vaultId} not found.');
    }
    
    List<WalletDao> walletDaoList = List<WalletDao>.empty(growable: true);
    await vaultsSecureStorageManager.performReadAction(() async {
      walletDaoList = vaultsSecureStorageManager.vaultDaoMap[vaultId]!.walletDaoMap.values.toList();
    });
    return walletDaoList;
  }
}
