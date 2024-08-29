import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

abstract interface class IListItemsService<T extends AListItemModel> {
  Future<List<T>> getAllByParentPath(FilesystemPath parentFilesystemPath, {bool firstLevelBool = false, bool previewEmptyBool = false});

  Future<T> getById(int id);

  Future<void> move(T listItem, FilesystemPath newFilesystemPath);

  Future<void> moveAllByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath);

  Future<int> save(T listItem);

  Future<List<int>> saveAll(List<T> listItems);

  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath);

  Future<void> deleteById(int id);
}
