import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

abstract class AListCubit<T extends AListItemModel> extends Cubit<ListState> {
  final SecretsService secretsService = globalLocator<SecretsService>();

  AListCubit({
    required FilesystemPath filesystemPath,
  }) : super(ListState.loading(filesystemPath: filesystemPath));

  Future<void> refreshAll() async {
    List<T> allItems = await fetchAllItems();

    List<AListItemModel> listItems = <AListItemModel>[...allItems];
    emit(state.copyWith(loadingBool: false, allItems: _sortItems(listItems)));
  }

  Future<void> refreshSingle(AListItemModel item) async {
    AListItemModel? newItem;
    if (item is T) {
      newItem = await fetchSingleItem(item);
    }

    if (newItem == null) {
      List<AListItemModel> newItems = state.allItems..remove(item);
      emit(state.copyWith(allItems: _sortItems(newItems)));
    } else {
      List<AListItemModel> newItems = state.allItems.map((AListItemModel e) => e == item ? newItem! : e).toList();
      emit(state.copyWith(allItems: _sortItems(newItems)));
    }
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
        }
      }
    }
    emit(state.copyWith(allItems: _sortItems(updatedItems), loadingBool: false, selectionModel: null, forceOverrideBool: true));
  }

  Future<void> lockSelection({required List<AListItemModel> selectedItems, required bool encryptedBool}) async {
    List<AListItemModel> updatedItems = List<AListItemModel>.from(state.allItems);
    for (int i = 0; i < updatedItems.length; i++) {
      AListItemModel item = updatedItems[i];
      if (selectedItems.contains(item)) {
        AListItemModel updatedItem = item.setEncrypted(encryptedBool: encryptedBool);
        updatedItems[i] = updatedItem;
        if (updatedItem is T) {
          unawaited(saveItem(updatedItem));
        }
      }
    }

    emit(state.copyWith(allItems: _sortItems(updatedItems), loadingBool: false, selectionModel: null, forceOverrideBool: true));
  }

  List<AListItemModel> _sortItems(List<AListItemModel> items) {
    items.sort((AListItemModel a, AListItemModel b) => a.compareTo(b));
    return items;
  }

  Future<void> deleteItem(AListItemModel item);

  @protected
  Future<List<T>> fetchAllItems();

  @protected
  Future<T?> fetchSingleItem(T item);

  @protected
  Future<void> saveItem(T item);
}
