import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/group_model_factory.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

abstract class AListCubit<T extends AListItemModel> extends Cubit<ListState> {
  final GroupsService groupsService = globalLocator<GroupsService>();
  final SecretsService secretsService = globalLocator<SecretsService>();

  AListCubit({
    required FilesystemPath filesystemPath,
    required int depth,
  }) : super(ListState.loading(depth: depth, filesystemPath: filesystemPath));

  Future<void> navigateNext({required FilesystemPath filesystemPath}) async {
    emit(ListState.loading(filesystemPath: filesystemPath, depth: state.depth + 1));
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

  Future<void> groupItems(AListItemModel a, AListItemModel b, String groupName) async {
    List<AListItemModel> pathsToGroup = <AListItemModel>[a, b];

    GroupModel groupModel = await globalLocator<GroupModelFactory>().createNewGroup(parentFilesystemPath: state.filesystemPath, name: groupName);

    for (AListItemModel item in pathsToGroup) {
      await moveItem(item, groupModel.filesystemPath);
    }

    await refreshAll();
  }

  Future<void> refreshAll() async {
    List<GroupModel> allGroups = await fetchAllGroups();
    List<T> allItems = await fetchAllItems();
    GroupModel? groupModel = await groupsService.getByPath(state.filesystemPath);

    List<AListItemModel> listItems = <AListItemModel>[...allGroups, ...allItems];
    emit(state.copyWith(loadingBool: false, groupModel: groupModel, allItems: _sortItems(listItems)));
  }

  Future<void> refreshSingle(AListItemModel item) async {
    late AListItemModel newItem;
    if (item is T) {
      newItem = await fetchSingleItem(item);
    } else if (item is GroupModel) {
      newItem = await fetchSingleGroup(item);
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
    List<AListItemModel> updatedItems = List<AListItemModel>.from(state.allItems);
    for (int i = 0; i < updatedItems.length; i++) {
      AListItemModel item = updatedItems[i];
      if (selectedItems.contains(item)) {
        AListItemModel updatedItem = item.setPinned(pinnedBool: pinnedBool);
        updatedItems[i] = updatedItem;
        if (updatedItem is T) {
          unawaited(saveItem(updatedItem));
        } else if (updatedItem is GroupModel) {
          unawaited(saveGroup(updatedItem));
        }
      }
    }
    emit(state.copyWith(allItems: _sortItems(updatedItems), loadingBool: false, selectionModel: null, forceOverrideBool: true));
  }

  Future<void> lockSelection({required List<AListItemModel> selectedItems, required PasswordModel newPasswordModel}) async {
    List<AListItemModel> updatedItems = List<AListItemModel>.from(state.allItems);
    for (int i = 0; i < updatedItems.length; i++) {
      AListItemModel item = updatedItems[i];
      if (selectedItems.contains(item)) {
        await secretsService.changePassword(item.filesystemPath, PasswordModel.defaultPassword(), newPasswordModel);
        AListItemModel updatedItem = item.setEncrypted(encryptedBool: true);
        updatedItems[i] = updatedItem;
        if (updatedItem is T) {
          unawaited(saveItem(updatedItem));
        } else if (updatedItem is GroupModel) {
          unawaited(saveGroup(updatedItem));
        }
      }
    }

    emit(state.copyWith(allItems: _sortItems(updatedItems), loadingBool: false, selectionModel: null, forceOverrideBool: true));
  }

  Future<void> unlockSelection({required AListItemModel selectedItem, required PasswordModel oldPasswordModel}) async {
    List<AListItemModel> updatedItems = List<AListItemModel>.from(state.allItems);
    for (int i = 0; i < updatedItems.length; i++) {
      AListItemModel item = updatedItems[i];
      if (item == selectedItem) {
        await secretsService.changePassword(
          item.filesystemPath,
          oldPasswordModel,
          PasswordModel.defaultPassword(),
        );
        AListItemModel updatedItem = item.setEncrypted(encryptedBool: false);
        updatedItems[i] = updatedItem;
        if (updatedItem is T) {
          unawaited(saveItem(updatedItem));
        } else if (updatedItem is GroupModel) {
          unawaited(saveGroup(updatedItem));
        }
      }
    }

    emit(state.copyWith(allItems: _sortItems(updatedItems), loadingBool: false, selectionModel: null, forceOverrideBool: true));
  }

  List<AListItemModel> _sortItems(List<AListItemModel> items) {
    items.sort((AListItemModel a, AListItemModel b) => a.compareTo(b));
    return items;
  }

  Future<void> moveItem(AListItemModel item, FilesystemPath newFilesystemPath);

  Future<void> deleteItem(AListItemModel item);

  @protected
  Future<List<T>> fetchAllItems();

  @protected
  Future<List<GroupModel>> fetchAllGroups();

  @protected
  Future<T> fetchSingleItem(T item);

  @protected
  Future<GroupModel> fetchSingleGroup(GroupModel group);

  @protected
  Future<void> saveItem(T item);

  @protected
  Future<void> saveGroup(GroupModel group);
}
