import 'package:snggle/infra/entities/group_entity.dart';
import 'package:snggle/infra/entities/network_group_entity.dart';
import 'package:snggle/infra/managers/database_collection_wrapper.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/encrypted_database_manager.dart';
import 'package:snggle/shared/models/groups/group_type.dart';

class GroupsRepository {
  final EncryptedDatabaseManager _encryptedDatabaseManager = EncryptedDatabaseManager();
  late final DatabaseCollectionWrapper<Map<String, dynamic>> _databaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
    databaseManager: _encryptedDatabaseManager,
    databaseParentKey: DatabaseParentKey.groups,
  );

  Future<List<GroupEntity>> getAll() async {
    List<Map<String, dynamic>> allGroupsJson = await _databaseCollectionWrapper.getAll();
    List<GroupEntity> allGroups = allGroupsJson.map((Map<String, dynamic> json) {
      if (json['type'] == GroupType.network.name) {
        return NetworkGroupEntity.fromJson(json);
      } else {
        return GroupEntity.fromJson(json);
      }
    }).toList();
    return allGroups;
  }

  Future<GroupEntity> getById(String id) async {
    Map<String, dynamic> groupJson = await _databaseCollectionWrapper.getById(id);
    if (groupJson['type'] == GroupType.network.name) {
      return NetworkGroupEntity.fromJson(groupJson);
    } else {
      return GroupEntity.fromJson(groupJson);
    }
  }

  Future<void> save(GroupEntity groupEntity) async {
    await _databaseCollectionWrapper.saveWithId(groupEntity.uuid, groupEntity.toJson());
  }

  Future<void> deleteById(String id) async {
    await _databaseCollectionWrapper.deleteById(id);
  }
}
