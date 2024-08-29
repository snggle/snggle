import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/group_model_factory.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

typedef SelectionModifier = Future<AListItemModel> Function(AListItemModel selectedItem);

abstract class AListCubit<T extends AListItemModel> extends Cubit<ListState> {
  final GroupsService groupsService = globalLocator<GroupsService>();
  final SecretsService secretsService = globalLocator<SecretsService>();

  final IListItemsService<T> listItemsService;
  final List<IListItemsService<AListItemModel>> childItemsServices;

  AListCubit({
    required this.listItemsService,
    required this.childItemsServices,
    required FilesystemPath filesystemPath,
    required int depth,
  }) : super(ListState.loading(depth: depth, filesystemPath: filesystemPath));

  Future<void> deleteItem(AListItemModel item) async {
    await _deleteChildItemsByPath(item.filesystemPath);
    await _deleteMainItem(item);

    GroupModel? previousGroupModel = await groupsService.getByPath(item.filesystemPath.pop());
    if (previousGroupModel != null && previousGroupModel.hasSingleItem) {
      FilesystemPath newFilesystemPath = await _ungroup(previousGroupModel);
      await navigateTo(filesystemPath: newFilesystemPath, depth: state.depth - 1);
    } else {
      await refreshAll();
    }
  }

  Future<void> groupItems(AListItemModel a, AListItemModel b, String groupName) async {
    List<AListItemModel> itemsToGroup = <AListItemModel>[a, b];
    GroupModel newGroupModel = await globalLocator<GroupModelFactory>().createNewGroup(parentFilesystemPath: state.filesystemPath, name: groupName);

    for (AListItemModel item in itemsToGroup) {
      await moveItem(item, newGroupModel.filesystemPath);
    }
  }

  Future<void> moveItem(AListItemModel item, FilesystemPath newFilesystemPath, {bool reloadBool = true}) async {
    FilesystemPath previousItemFilesystemPath = item.filesystemPath;
    FilesystemPath newItemFilesystemPath = item.filesystemPath.replace(item.filesystemPath.parentPath, newFilesystemPath.fullPath);

    await _moveChildItemsByPath(previousItemFilesystemPath, newItemFilesystemPath);
    await _moveMainItem(item, newItemFilesystemPath);

    GroupModel? previousGroupModel = await groupsService.getByPath(item.filesystemPath.pop());
    if (previousGroupModel != null && previousGroupModel.hasSingleItem) {
      await _ungroup(previousGroupModel);
    }

    if (reloadBool) {
      await refreshAll();
    }
  }

  Future<void> navigateNext({required FilesystemPath filesystemPath}) async {
    int newDepth = state.depth + 1;

    emit(ListState.loading(filesystemPath: filesystemPath, depth: newDepth));
    await refreshAll();
  }

  Future<void> navigateTo({required FilesystemPath filesystemPath, required int depth}) async {
    emit(ListState.loading(filesystemPath: filesystemPath, depth: depth));
    await refreshAll();
  }

  Future<bool> navigateBack() async {
    if (state.depth > 0) {
      emit(ListState.loading(filesystemPath: state.filesystemPath.pop(), depth: state.depth - 1));
      await refreshAll();
      return true;
    } else {
      return false;
    }
  }

  Future<void> refreshAll() async {
    List<T> allItems = await listItemsService.getAllByParentPath(state.filesystemPath, firstLevelBool: true);
    List<GroupModel> allGroups = await groupsService.getAllByParentPath(state.filesystemPath, firstLevelBool: true);
    GroupModel? groupModel = await groupsService.getByPath(state.filesystemPath);

    List<AListItemModel> listItems = <AListItemModel>[...allGroups, ...allItems];
    emit(state.copyWith(loadingBool: false, groupModel: groupModel, allItems: _sortItems(listItems)));
  }

  Future<void> refreshSingle(AListItemModel item) async {
    late AListItemModel newItem;
    if (item is T) {
      newItem = await listItemsService.getById(item.id);
    } else if (item is GroupModel) {
      newItem = await groupsService.getById(item.id);
    }

    List<AListItemModel> newItems = state.allItems.map((AListItemModel e) => e == item ? newItem : e).toList();
    emit(state.copyWith(allItems: _sortItems(newItems)));
  }

  void selectSingle(AListItemModel item) {
    List<AListItemModel> selectedItems = List<AListItemModel>.from(state.selectedItems, growable: true)..add(item);
    emit(state.copyWith(selectionModel: SelectionModel(selectedItems: selectedItems, allItemsCount: state.allItems.length)));
  }

  void unselectSingle(AListItemModel item) {
    List<AListItemModel> selectedItems = List<AListItemModel>.from(state.selectedItems, growable: true)..remove(item);
    emit(state.copyWith(selectionModel: SelectionModel(selectedItems: selectedItems, allItemsCount: state.allItems.length)));
  }

  void toggleSelectAll() {
    if (state.selectedItems.length == state.allItems.length) {
      emit(state.copyWith(selectionModel: SelectionModel.empty(allItemsCount: state.allItems.length)));
    } else {
      emit(state.copyWith(selectionModel: SelectionModel(selectedItems: state.allItems, allItemsCount: state.allItems.length)));
    }
  }

  void disableSelection() {
    emit(state.copyWith(selectionModel: null, forceOverrideBool: true));
  }

  Future<void> pinSelection({required List<AListItemModel> selectedItems, required bool pinnedBool}) async {
    List<AListItemModel> updatedItems = await _updateSelection(
      selectedItems: selectedItems,
      selectionModifier: (AListItemModel item) async {
        return item.setPinned(pinnedBool: pinnedBool);
      },
    );

    emit(state.copyWith(allItems: _sortItems(updatedItems), loadingBool: false, selectionModel: null, forceOverrideBool: true));
  }

  Future<void> lockSelection({required List<AListItemModel> selectedItems, required PasswordModel newPasswordModel}) async {
    List<AListItemModel> updatedItems = await _updateSelection(
      selectedItems: selectedItems,
      selectionModifier: (AListItemModel item) async {
        await secretsService.changePassword(item.filesystemPath, PasswordModel.defaultPassword(), newPasswordModel);
        return item.setEncrypted(encryptedBool: true);
      },
    );

    emit(state.copyWith(allItems: _sortItems(updatedItems), loadingBool: false, selectionModel: null, forceOverrideBool: true));
  }

  Future<void> unlockSelection({required AListItemModel selectedItem, required PasswordModel oldPasswordModel}) async {
    List<AListItemModel> updatedItems = await _updateSelection(
      selectedItems: <AListItemModel>[selectedItem],
      selectionModifier: (AListItemModel item) async {
        await secretsService.changePassword(item.filesystemPath, oldPasswordModel, PasswordModel.defaultPassword());
        return item.setEncrypted(encryptedBool: false);
      },
    );

    emit(state.copyWith(allItems: _sortItems(updatedItems), loadingBool: false, selectionModel: null, forceOverrideBool: true));
  }

  Future<void> _deleteChildItemsByPath(FilesystemPath filesystemPath) async {
    for (IListItemsService<AListItemModel> childListItemsService in childItemsServices) {
      await childListItemsService.deleteAllByParentPath(filesystemPath);
    }
  }

  Future<void> _deleteMainItem(AListItemModel item) async {
    if (item is T) {
      await listItemsService.deleteById(item.id);
    } else if (item is GroupModel) {
      await listItemsService.deleteAllByParentPath(item.filesystemPath);
      await groupsService.deleteById(item.id);
    } else {
      throw UnsupportedError('Unsupported item type: ${item.runtimeType}');
    }
  }

  Future<void> _moveChildItemsByPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    for (IListItemsService<AListItemModel> childListItemsService in childItemsServices) {
      await childListItemsService.moveAllByParentPath(previousFilesystemPath, newFilesystemPath);
    }
  }

  Future<void> _moveMainItem(AListItemModel item, FilesystemPath newItemFilesystemPath) async {
    if (item is T) {
      await listItemsService.move(item, newItemFilesystemPath);
    } else if (item is GroupModel) {
      await listItemsService.moveAllByParentPath(item.filesystemPath, newItemFilesystemPath);
      await groupsService.move(item, newItemFilesystemPath);
    } else {
      throw UnsupportedError('Unsupported item type: ${item.runtimeType}');
    }
  }

  Future<FilesystemPath> _ungroup(GroupModel groupModel) async {
    FilesystemPath newFilesystemPath = groupModel.filesystemPath.pop();
    await moveItem(groupModel.listItemsPreview.first, newFilesystemPath, reloadBool: false);
    await groupsService.deleteById(groupModel.id);
    return newFilesystemPath;
  }

  List<AListItemModel> _sortItems(List<AListItemModel> items) {
    items.sort((AListItemModel a, AListItemModel b) => a.compareTo(b));
    return items;
  }

  Future<List<AListItemModel>> _updateSelection({required List<AListItemModel> selectedItems, required SelectionModifier selectionModifier}) async {
    List<AListItemModel> updatedItems = List<AListItemModel>.from(state.allItems);
    for (int i = 0; i < updatedItems.length; i++) {
      AListItemModel item = updatedItems[i];
      if (selectedItems.contains(item)) {
        AListItemModel updatedItem = await selectionModifier(item);
        updatedItems[i] = updatedItem;
        if (updatedItem is T) {
          unawaited(listItemsService.save(updatedItem));
        } else if (updatedItem is GroupModel) {
          unawaited(groupsService.save(updatedItem));
        }
      }
    }
    return updatedItems;
  }
}
