import 'package:snggle/infra/entities/group_entity.dart';
import 'package:snggle/infra/entities/network_group_entity.dart';
import 'package:snggle/infra/managers/secure_storage/encrypted_secure_storage_manager.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_collection_wrapper.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/models/groups/group_type.dart';

class GroupsRepository {
  final EncryptedSecureStorageManager _encryptedSecureStorageManager = EncryptedSecureStorageManager();
  late final SecureStorageCollectionWrapper<Map<String, dynamic>> _secureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
    secureStorageManager: _encryptedSecureStorageManager,
    secureStorageKey: SecureStorageKey.groups,
  );

  Future<List<GroupEntity>> getAll() async {
    List<Map<String, dynamic>> allGroupsJson = await _secureStorageCollectionWrapper.getAll();
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
    Map<String, dynamic> groupJson = await _secureStorageCollectionWrapper.getById(id);
    if (groupJson['type'] == GroupType.network.name) {
      return NetworkGroupEntity.fromJson(groupJson);
    } else {
      return GroupEntity.fromJson(groupJson);
    }
  }

  Future<void> save(GroupEntity groupEntity) async {
    await _secureStorageCollectionWrapper.saveWithId(groupEntity.uuid, groupEntity.toJson());
  }

  Future<void> deleteById(String id) async {
    await _secureStorageCollectionWrapper.deleteById(id);
  }
}
