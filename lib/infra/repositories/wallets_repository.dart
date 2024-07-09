import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/infra/managers/secure_storage/encrypted_secure_storage_manager.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_collection_wrapper.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';

class WalletsRepository {
  final EncryptedSecureStorageManager _encryptedSecureStorageManager = EncryptedSecureStorageManager();
  late final SecureStorageCollectionWrapper<Map<String, dynamic>> _secureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
    secureStorageManager: _encryptedSecureStorageManager,
    secureStorageKey: SecureStorageKey.wallets,
  );

  Future<List<WalletEntity>> getAll() async {
    List<Map<String, dynamic>> allWalletsJson = await _secureStorageCollectionWrapper.getAll();
    List<WalletEntity> allWallets = allWalletsJson.map(WalletEntity.fromJson).toList();
    return allWallets;
  }

  Future<WalletEntity> getById(String id) async {
    Map<String, dynamic> walletJson = await _secureStorageCollectionWrapper.getById(id);
    WalletEntity walletEntity = WalletEntity.fromJson(walletJson);
    return walletEntity;
  }

  Future<void> save(WalletEntity walletEntity) async {
    await _secureStorageCollectionWrapper.saveWithId(walletEntity.uuid, walletEntity.toJson());
  }

  Future<void> deleteById(String id) async {
    await _secureStorageCollectionWrapper.deleteById(id);
  }
}
