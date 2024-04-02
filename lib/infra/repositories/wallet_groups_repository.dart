import 'package:snggle/infra/entities/wallet_group_entity.dart';
import 'package:snggle/infra/managers/database_collection_wrapper.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/encrypted_database_manager.dart';

class WalletGroupsRepository {
  final EncryptedDatabaseManager _encryptedDatabaseManager = EncryptedDatabaseManager();
  late final DatabaseCollectionWrapper<Map<String, dynamic>> _databaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
    databaseManager: _encryptedDatabaseManager,
    databaseParentKey: DatabaseParentKey.walletGroups,
  );

  Future<List<WalletGroupEntity>> getAll() async {
    List<Map<String, dynamic>> allWalletGroupsJson = await _databaseCollectionWrapper.getAll();
    List<WalletGroupEntity> allWalletGroups = allWalletGroupsJson.map(WalletGroupEntity.fromJson).toList();
    return allWalletGroups;
  }

  Future<WalletGroupEntity> getByPath(String path) async {
    Map<String, dynamic> walletGroupJson = await _databaseCollectionWrapper.getById(path);
    WalletGroupEntity walletGroupEntity = WalletGroupEntity.fromJson(walletGroupJson);
    return walletGroupEntity;
  }

  Future<void> save(WalletGroupEntity walletGroupEntity) async {
    await _databaseCollectionWrapper.saveWithId('${walletGroupEntity.parentPath}/${walletGroupEntity.id}', walletGroupEntity.toJson());
  }

  Future<void> deleteByPath(String path) async {
    await _databaseCollectionWrapper.deleteById(path);
  }
}
