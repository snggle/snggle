import 'package:snggle/infra/entities/group_entity.dart';
import 'package:snggle/infra/managers/database_collection_wrapper.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/encrypted_database_manager.dart';

class GroupsRepository {
  final EncryptedDatabaseManager _encryptedDatabaseManager = EncryptedDatabaseManager();
  late final DatabaseCollectionWrapper<Map<String, dynamic>> _databaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
    databaseManager: _encryptedDatabaseManager,
    databaseParentKey: DatabaseParentKey.groups,
  );

  Future<List<GroupEntity>> getAll() async {
    List<Map<String, dynamic>> allGroupsJson = await _databaseCollectionWrapper.getAll();
    List<GroupEntity> allGroups = allGroupsJson.map(GroupEntity.fromJson).toList();
    return allGroups;
  }

  Future<GroupEntity> getByPath(String path) async {
    Map<String, dynamic> groupJson = await _databaseCollectionWrapper.getById(path);
    GroupEntity groupEntity = GroupEntity.fromJson(groupJson);
    return groupEntity;
  }

  Future<void> save(GroupEntity groupEntity) async {
    await _databaseCollectionWrapper.saveWithId('${groupEntity.parentPath}/${groupEntity.id}', groupEntity.toJson());
  }

  Future<void> deleteByPath(String path) async {
    await _databaseCollectionWrapper.deleteById(path);
  }
}
