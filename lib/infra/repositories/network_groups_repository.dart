import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/objectbox_database_manager.dart';
import 'package:snggle/shared/objectbox/objectbox.g.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class NetworkGroupsRepository {
  final ObjectboxDatabaseManager objectBoxDatabaseManager = globalLocator<ObjectboxDatabaseManager>();

  Future<List<NetworkGroupEntity>> getAll() async => objectBoxDatabaseManager.perform((Store store) => store.box<NetworkGroupEntity>().getAll());

  Future<List<NetworkGroupEntity>> getAllByParentPath(FilesystemPath parentFilesystemPath) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Query<NetworkGroupEntity> query = store
          .box<NetworkGroupEntity>()
          .query(NetworkGroupEntity_.filesystemPathString.startsWith(parentFilesystemPath.fullPath))
          .build();

      try {
        return query.find();
      } finally {
        query.close();
      }
    });
  }

  Future<NetworkGroupEntity> getById(int id) async {
    NetworkGroupEntity? networkGroupEntity = objectBoxDatabaseManager.perform((Store store) => store.box<NetworkGroupEntity>().get(id));

    if (networkGroupEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return networkGroupEntity;
  }

  Future<int> save(NetworkGroupEntity networkGroupEntity) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Box<NetworkGroupEntity> box = store.box<NetworkGroupEntity>();
      return store.runInTransaction(TxMode.write, () => box.put(networkGroupEntity));
    });
  }

  Future<List<int>> saveAll(List<NetworkGroupEntity> networkGroupEntityList) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Box<NetworkGroupEntity> box = store.box<NetworkGroupEntity>();
      return store.runInTransaction(TxMode.write, () => box.putMany(networkGroupEntityList));
    });
  }

  Future<void> deleteById(int id) async {
    objectBoxDatabaseManager.perform((Store store) {
      Box<NetworkGroupEntity> box = store.box<NetworkGroupEntity>();
      bool deletedBool = store.runInTransaction(TxMode.write, () => box.remove(id));

      if (deletedBool == false) {
        throw ChildKeyNotFoundException();
      }
    });
  }
}
