import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity/group_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/object_box_database_manager.dart';
import 'package:snggle/objectbox.g.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class GroupsRepository {
  final ObjectBoxDatabaseManager objectBoxDatabaseManager = globalLocator<ObjectBoxDatabaseManager>();

  Future<List<GroupEntity>> getAll() async => objectBoxDatabaseManager.perform((Store store) => store.box<GroupEntity>().getAll());

  Future<List<GroupEntity>> getAllByParentPath(FilesystemPath parentFilesystemPath) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Query<GroupEntity> query = store.box<GroupEntity>().query(GroupEntity_.filesystemPathString.startsWith(parentFilesystemPath.fullPath)).build();

      try {
        return query.find();
      } finally {
        query.close();
      }
    });
  }

  Future<GroupEntity> getById(int id) async {
    GroupEntity? groupEntity = objectBoxDatabaseManager.perform((Store store) => store.box<GroupEntity>().get(id));

    if (groupEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return groupEntity;
  }

  Future<GroupEntity> getByPath(FilesystemPath filesystemPath) async {
    GroupEntity? groupEntity = objectBoxDatabaseManager.perform((Store store) {
      Query<GroupEntity> query = store.box<GroupEntity>().query(GroupEntity_.filesystemPathString.equals(filesystemPath.fullPath)).build();

      try {
        return query.findFirst();
      } finally {
        query.close();
      }
    });

    if (groupEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return groupEntity;
  }

  Future<int> save(GroupEntity groupEntity) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Box<GroupEntity> box = store.box<GroupEntity>();
      return store.runInTransaction(TxMode.write, () => box.put(groupEntity));
    });
  }

  Future<List<int>> saveAll(List<GroupEntity> groupEntityList) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Box<GroupEntity> box = store.box<GroupEntity>();
      return store.runInTransaction(TxMode.write, () => box.putMany(groupEntityList));
    });
  }

  Future<void> deleteById(int id) async {
    objectBoxDatabaseManager.perform((Store store) {
      Box<GroupEntity> box = store.box<GroupEntity>();
      bool deletedBool = store.runInTransaction(TxMode.write, () => box.remove(id));

      if (deletedBool == false) {
        throw ChildKeyNotFoundException();
      }
    });
  }
}
