import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/entities/network_template_entity/embedded_network_template_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/object_box_database_manager.dart';
import 'package:snggle/objectbox.g.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class NetworkGroupsRepository {
  final ObjectBoxDatabaseManager objectBoxDatabaseManager = globalLocator<ObjectBoxDatabaseManager>();

  Future<List<NetworkGroupEntity>> getAll() async => objectBoxDatabaseManager.perform((Store store) => store.box<NetworkGroupEntity>().getAll());

  Future<List<NetworkGroupEntity>> getAllByParentPath(FilesystemPath parentFilesystemPath) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Query<NetworkGroupEntity> query =
          store.box<NetworkGroupEntity>().query(NetworkGroupEntity_.filesystemPathString.startsWith(parentFilesystemPath.fullPath)).build();

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
      Box<EmbeddedNetworkTemplateEntity> embeddedNetworkTemplateBox = store.box<EmbeddedNetworkTemplateEntity>();
      return store.runInTransaction(
          TxMode.write,
          () => box.put(
              _prepareForSave(networkGroupEntity: networkGroupEntity, networkGroupBox: box, embeddedNetworkTemplateBox: embeddedNetworkTemplateBox)));
    });
  }

  Future<List<int>> saveAll(List<NetworkGroupEntity> networkGroupEntityList) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Box<NetworkGroupEntity> box = store.box<NetworkGroupEntity>();
      Box<EmbeddedNetworkTemplateEntity> embeddedNetworkTemplateBox = store.box<EmbeddedNetworkTemplateEntity>();
      return store.runInTransaction(
          TxMode.write,
          () => box.putMany(networkGroupEntityList
              .map((NetworkGroupEntity networkGroupEntity) => _prepareForSave(
                  networkGroupEntity: networkGroupEntity, networkGroupBox: box, embeddedNetworkTemplateBox: embeddedNetworkTemplateBox))
              .toList()));
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

  NetworkGroupEntity _prepareForSave({
    required NetworkGroupEntity networkGroupEntity,
    required Box<NetworkGroupEntity> networkGroupBox,
    required Box<EmbeddedNetworkTemplateEntity> embeddedNetworkTemplateBox,
  }) {
    NetworkGroupEntity entityToSave = networkGroupEntity.copyWith();

    if (entityToSave.id != 0 && networkGroupBox.get(entityToSave.id) == null) {
      entityToSave.id = 0;
    }

    EmbeddedNetworkTemplateEntity? embeddedNetworkTemplate = entityToSave.embeddedNetworkTemplate;
    if (embeddedNetworkTemplate != null) {
      entityToSave.embeddedNetworkTemplate =
          _resolveEmbeddedNetworkTemplate(embeddedNetworkTemplate: embeddedNetworkTemplate, embeddedNetworkTemplateBox: embeddedNetworkTemplateBox);
    }

    return entityToSave;
  }

  EmbeddedNetworkTemplateEntity _resolveEmbeddedNetworkTemplate({
    required EmbeddedNetworkTemplateEntity embeddedNetworkTemplate,
    required Box<EmbeddedNetworkTemplateEntity> embeddedNetworkTemplateBox,
  }) {
    for (EmbeddedNetworkTemplateEntity existingTemplate in embeddedNetworkTemplateBox.getAll()) {
      if (existingTemplate == embeddedNetworkTemplate) {
        return existingTemplate;
      }
    }

    EmbeddedNetworkTemplateEntity templateToSave = EmbeddedNetworkTemplateEntity(
      id: embeddedNetworkTemplate.id,
      name: embeddedNetworkTemplate.name,
      addressEncoderType: embeddedNetworkTemplate.addressEncoderType,
      derivationPathTemplate: embeddedNetworkTemplate.derivationPathTemplate,
      derivatorType: embeddedNetworkTemplate.derivatorType,
      dbCurveType: embeddedNetworkTemplate.dbCurveType,
      dbNetworkIconType: embeddedNetworkTemplate.dbNetworkIconType,
      dbNetworkType: embeddedNetworkTemplate.dbNetworkType,
      dbWalletType: embeddedNetworkTemplate.dbWalletType,
    );

    int templateId = embeddedNetworkTemplateBox.put(templateToSave);
    return embeddedNetworkTemplateBox.get(templateId)!;
  }
}
