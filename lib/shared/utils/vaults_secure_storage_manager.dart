import 'dart:convert';

import 'package:snuggle/infra/dao/vault/vault_dao.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';
import 'package:snuggle/shared/utils/storage_manager.dart';

class VaultsSecureStorageManager {
  final StorageManager storageManager = StorageManager();

  String seedHash = '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773eccede65606529a0';
  bool _initialized = false;
  Map<String, VaultDao> vaultDaoMap = <String, VaultDao>{};

  VaultsSecureStorageManager();

  Future<void> reloadVaultDaoMap() async {
    try {
      String vaultDaoMapString = await storageManager.read(key: 'vaults');
      String vaultDaoMapStringDecrypted = Aes256.decrypt(seedHash, vaultDaoMapString);

      Map<String, dynamic> decodedVaultDaoMap = jsonDecode(vaultDaoMapStringDecrypted) as Map<String, dynamic>;
      Map<String, VaultDao> newVaultDaoMap = <String, VaultDao>{};
      decodedVaultDaoMap.forEach((String key, dynamic value) {
        newVaultDaoMap[key] = VaultDao.fromJson(value as Map<String, dynamic>);
      });
      vaultDaoMap = newVaultDaoMap;
    } catch(e) {
  
      vaultDaoMap = <String, VaultDao>{};
      rethrow;
    }
  }

  Future<void> performWriteAction(Future<dynamic> Function() action) async {
    if (_initialized == false) {
      await reloadVaultDaoMap();
      _initialized = true;
    }
    Map<String, VaultDao> vaultDaoMapBackup = vaultDaoMap;
    try {
      await action();
    } catch (e) {
      // TODO(dominik): log error
      vaultDaoMap = vaultDaoMapBackup;
    }

    await _save();
  }

  Future<void> performReadAction(Future<dynamic> Function() action) async {
    if (_initialized == false) {
      await reloadVaultDaoMap();
      _initialized = true;
    }
    await action();
  }

  Future<void> _save() async {
    Map<String, dynamic> vaultDaoMapJson = <String, dynamic>{};
    vaultDaoMap.forEach((String key, VaultDao vaultDao) {
      vaultDaoMapJson[key] = vaultDao.toJson();
    });
    String vaultDaoMapJsonString = jsonEncode(vaultDaoMapJson);
    String vaultDaoMapJsonStringEncrypted = Aes256.encrypt(seedHash, vaultDaoMapJsonString);
    await storageManager.write(key: 'vaults', data: vaultDaoMapJsonStringEncrypted);
  }
}
