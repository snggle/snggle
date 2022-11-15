import 'dart:convert';

import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/dao/vault/request/save_vault_request.dart';
import 'package:snuggle/infra/dao/vault/request/save_wallet_request.dart';
import 'package:snuggle/infra/dao/vault/vault_dao.dart';
import 'package:snuggle/infra/dao/wallet/wallet_dao.dart';
import 'package:snuggle/shared/utils/vaults_secure_storage_manager.dart';

class VaultsRepository {
  final VaultsSecureStorageManager vaultsSecureStorageManager = globalLocator<VaultsSecureStorageManager>();

  Future<void> saveVault(SaveVaultRequest saveVaultRequest) async {
    VaultDao? currentVaultDao = vaultsSecureStorageManager.vaultDaoMap[saveVaultRequest.id];
    VaultDao newVaultDao = VaultDao(
      id: saveVaultRequest.id,
      name: saveVaultRequest.name,
      vaultSecretsDao: saveVaultRequest.vaultSecretsDao,
      walletDaoMap: currentVaultDao?.walletDaoMap ?? <String, WalletDao>{},
    );
    await vaultsSecureStorageManager.performWriteAction(() async {
      vaultsSecureStorageManager.vaultDaoMap[saveVaultRequest.id] = newVaultDao;
    });
  }

  Future<List<VaultDao>> getAll() async {
    List<VaultDao> vaultDaoList = List<VaultDao>.empty(growable: true);
    await vaultsSecureStorageManager.performReadAction(() async {
      vaultDaoList = vaultsSecureStorageManager.vaultDaoMap.values.toList();
    });
    return vaultDaoList;
  }
}
