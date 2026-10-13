import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/passkey_entity/passkey_entity.dart';
import 'package:snggle/infra/repositories/passkeys_repository.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/passkey_model_factory.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class PasskeysService implements IListItemsService<PasskeyModel> {
  final PasskeysRepository _repository = globalLocator<PasskeysRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  @override
  Future<List<PasskeyModel>> getAllByParentPath(FilesystemPath parentFilesystemPath,
      {bool firstLevelBool = false, bool previewEmptyBool = false}) async {
    List<PasskeyEntity> entities = await _repository.getAllByParentPath(parentFilesystemPath);
    entities = entities.where((PasskeyEntity entity) =>
        entity.filesystemPath.isSubPathOf(parentFilesystemPath, firstLevelBool: firstLevelBool)).toList();
    return globalLocator<PasskeyModelFactory>().createFromEntities(entities);
  }

  Future<List<PasskeyModel>> getAllByRpId(String rpId) async {
    List<PasskeyEntity> entities = await _repository.getAllByRpId(rpId);
    return globalLocator<PasskeyModelFactory>().createFromEntities(entities);
  }

  Future<PasskeyModel> getByCredentialId(List<int> credentialId) async {
    PasskeyEntity entity = await _repository.getByCredentialId(credentialId);
    return globalLocator<PasskeyModelFactory>().createFromEntity(entity);
  }

  @override
  Future<PasskeyModel> getById(int id) async {
    PasskeyEntity entity = await _repository.getById(id);
    return globalLocator<PasskeyModelFactory>().createFromEntity(entity);
  }

  @override
  Future<int> save(PasskeyModel item) => _repository.save(PasskeyEntity.fromPasskeyModel(item));

  @override
  Future<List<int>> saveAll(List<PasskeyModel> items) =>
      _repository.saveAll(items.map(PasskeyEntity.fromPasskeyModel).toList());

  Future<PasskeyModel> updateFilesystemPath(int id, FilesystemPath parentFilesystemPath) async {
    PasskeyEntity entity = await _repository.getById(id);
    entity = entity.copyWith(filesystemPathString: parentFilesystemPath.add('passkey$id').fullPath);
    await _repository.save(entity);
    return globalLocator<PasskeyModelFactory>().createFromEntity(entity);
  }

  @override
  Future<void> move(PasskeyModel item, FilesystemPath newFilesystemPath) async {
    PasskeyModel moved = item.copyWith(filesystemPath: newFilesystemPath);
    await _secretsService.move(item.filesystemPath, newFilesystemPath);
    await save(moved);
  }

  @override
  Future<void> moveAllByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    List<PasskeyModel> items = await getAllByParentPath(previousFilesystemPath);
    // The deepest items first, as in the wallet implementation.
    items.sort((PasskeyModel a, PasskeyModel b) =>
        b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));
    for (PasskeyModel item in items) {
      FilesystemPath target = item.filesystemPath.replace(previousFilesystemPath.fullPath, newFilesystemPath.fullPath);
      await move(item, target);
    }
  }

  @override
  Future<void> deleteById(int id) async {
    PasskeyModel item = await getById(id);
    await _secretsService.delete(item.filesystemPath);
    await _repository.deleteById(id);
  }

  @override
  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<PasskeyModel> items = await getAllByParentPath(parentFilesystemPath);
    items.sort((PasskeyModel a, PasskeyModel b) =>
        b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));
    for (PasskeyModel item in items) {
      await deleteById(item.id);
    }
  }
}
