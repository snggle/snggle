import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/entry_entity/entry_entity.dart';
import 'package:snggle/infra/repositories/entries_repository.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/entry_model_factory.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntriesService implements IListItemsService<EntryModel> {
  final EntriesRepository _entriesRepository = globalLocator<EntriesRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  @override
  Future<List<EntryModel>> getAllByParentPath(FilesystemPath parentFilesystemPath,
      {bool firstLevelBool = false, bool previewEmptyBool = false}) async {
    EntryModelFactory entryModelFactory = globalLocator<EntryModelFactory>();

    List<EntryEntity> secretEntityList = await _entriesRepository.getAllByParentPath(parentFilesystemPath);
    secretEntityList = secretEntityList.where((EntryEntity entryEntity) {
      return entryEntity.filesystemPath.isSubPathOf(parentFilesystemPath, firstLevelBool: firstLevelBool);
    }).toList();

    List<EntryModel> vaultModelList = await entryModelFactory.createFromEntities(secretEntityList, previewEmptyBool: previewEmptyBool);
    return vaultModelList;
  }

  @override
  Future<EntryModel> getById(int id) async {
    EntryEntity entryEntity = await _entriesRepository.getById(id);
    return globalLocator<EntryModelFactory>().createFromEntity(entryEntity);
  }

  @override
  Future<void> move(EntryModel listItem, FilesystemPath newFilesystemPath) async {
    EntryModel movedEntryModel = listItem.copyWith(filesystemPath: newFilesystemPath);
    await save(movedEntryModel);
    await _secretsService.move(listItem.filesystemPath, movedEntryModel.filesystemPath);
  }

  @override
  Future<void> moveAllByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    List<EntryModel> entryModelsToMove = await getAllByParentPath(previousFilesystemPath, firstLevelBool: false, previewEmptyBool: true);
    for (int i = 0; i < entryModelsToMove.length; i++) {
      EntryModel entryModel = entryModelsToMove[i];
      EntryModel updatedEntryModel = entryModel.copyWith(
        filesystemPath: entryModel.filesystemPath.replace(previousFilesystemPath.fullPath, newFilesystemPath.fullPath),
      );

      entryModelsToMove[i] = updatedEntryModel;
      await _secretsService.move(entryModel.filesystemPath, updatedEntryModel.filesystemPath);
    }

    await saveAll(entryModelsToMove);
  }

  @override
  Future<int> save(EntryModel listItem) async {
    return _entriesRepository.save(EntryEntity.fromEntryModel(listItem));
  }

  @override
  Future<List<int>> saveAll(List<EntryModel> listItems) async {
    return _entriesRepository.saveAll(listItems.map(EntryEntity.fromEntryModel).toList());
  }

  @override
  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<EntryModel> entryModelList = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);

    // Sort entries by the length of their paths, ensuring the deepest entry is deleted first
    entryModelList.sort((EntryModel a, EntryModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (EntryModel entryModel in entryModelList) {
      await _secretsService.delete(entryModel.filesystemPath);
      await _entriesRepository.deleteById(entryModel.id);
    }
  }

  @override
  Future<void> deleteById(int id) async {
    EntryModel entryModel = await getById(id);

    await _secretsService.delete(entryModel.filesystemPath);
    await _entriesRepository.deleteById(id);
  }

  Future<int> getLastIndex() async {
    int? lastIndex = await _entriesRepository.getLastIndex();
    return lastIndex ?? -1;
  }

  Future<EntryModel> updateFilesystemPath(int id, FilesystemPath parentFilesystemPath) async {
    EntryEntity entryEntity = await _entriesRepository.getById(id);
    entryEntity = entryEntity.copyWith(filesystemPathString: parentFilesystemPath.add('entry$id').fullPath);
    await _entriesRepository.save(entryEntity);
    return globalLocator<EntryModelFactory>().createFromEntity(entryEntity);
  }
}
