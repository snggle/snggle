import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/entry_entity/entry_entity.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntryModelFactory {
  final EntriesService _entriesService = globalLocator<EntriesService>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<EntryModel> createNewEntry(FilesystemPath parentFilesystemPath, [String? name, String? login, String? password]) async {
    int lastEntryIndex = await _entriesService.getLastIndex();

    EntryModel entryModel = EntryModel(
      id: Isar.autoIncrement,
      index: lastEntryIndex + 1,
      pinnedBool: false,
      encryptedBool: false,
      filesystemPath: const FilesystemPath.empty(),
      name: name,
    );
    int entryId = await _entriesService.save(entryModel);
    entryModel = await _entriesService.updateFilesystemPath(entryId, parentFilesystemPath);

    EntrySecretsModel entrySecretsModel = EntrySecretsModel(
      filesystemPath: entryModel.filesystemPath,
      username: login,
      password: password,
    );

    await _secretsService.save(entrySecretsModel, PasswordModel.defaultPassword());
    return entryModel;
  }

  Future<List<EntryModel>> createFromEntities(List<EntryEntity> entryEntityList, {bool previewEmptyBool = false}) async {
    List<EntryModel> entryList = <EntryModel>[];
    for (EntryEntity entryEntity in entryEntityList) {
      entryList.add(await createFromEntity(entryEntity, previewEmptyBool: previewEmptyBool));
    }
    return entryList;
  }

  Future<EntryModel> createFromEntity(EntryEntity entryEntity, {bool previewEmptyBool = false}) async {
    return EntryModel(
      index: entryEntity.index,
      id: entryEntity.id,
      pinnedBool: entryEntity.pinnedBool,
      encryptedBool: entryEntity.encryptedBool,
      filesystemPath: entryEntity.filesystemPath,
      name: entryEntity.name,
    );
  }
}
