import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/selection_model.dart';

abstract class AListCubit<T extends AListItemModel> extends Cubit<ListState<T>> {
  AListCubit() : super(ListState<T>.loading());

  Future<void> delete(T item) async {
    await deleteFromDatabase(item);
    await refreshAll();
  }

  Future<void> refreshSingle(T item) async {
    T? newItem = await fetchSingleFromDatabase(item);
    if (newItem == null) {
      List<T> newItems = state.allItems..remove(item);
      emit(state.copyWith(allItems: sortItems(newItems)));
    } else {
      List<T> newItems = state.allItems.map((T e) => e == item ? newItem : e).toList();
      emit(state.copyWith(allItems: sortItems(newItems)));
    }
  }

  Future<void> refreshAll() async {
    List<T> allItems = await fetchAllFromDatabase();
    emit(ListState<T>(loadingBool: false, allItems: sortItems(allItems)));
  }

  void selectSingle(T item) {
    List<T> selectedItems = List<T>.from(state.selectedItems, growable: true)..add(item);
    emit(state.copyWith(selectionModel: SelectionModel<T>(selectedItems: selectedItems, allItemsCount: state.allItems.length)));
  }

  void selectAll() {
    if (state.selectedItems.length == state.allItems.length) {
      emit(state.copyWith(selectionModel: SelectionModel<T>.empty(allItemsCount: state.allItems.length)));
    } else {
      emit(state.copyWith(selectionModel: SelectionModel<T>(selectedItems: state.allItems, allItemsCount: state.allItems.length)));
    }
  }

  void unselectSingle(T item) {
    List<T> selectedItems = List<T>.from(state.selectedItems, growable: true)..remove(item);
    emit(state.copyWith(selectionModel: SelectionModel<T>(selectedItems: selectedItems, allItemsCount: state.allItems.length)));
  }

  void disableSelection() {
    emit(ListState<T>(allItems: sortItems(state.allItems), loadingBool: false));
  }

  Future<void> pinSelection({required List<T> selectedItems, required bool pinnedBool}) async {
    List<T> updatedItems = List<T>.from(state.allItems);
    for (int i = 0; i < updatedItems.length; i++) {
      T item = updatedItems[i];
      if (selectedItems.contains(item)) {
        T updatedItem = item.setPinned(pinnedBool: pinnedBool) as T;
        updatedItems[i] = updatedItem;
        unawaited(saveToDatabase(updatedItem));
      }
    }
    emit(ListState<T>(allItems: sortItems(updatedItems), loadingBool: false));
  }

  Future<void> updateEncryptionStatus({required List<T> selectedItems, required bool encryptedBool}) async {
    List<T> updatedItems = List<T>.from(state.allItems);
    for (int i = 0; i < updatedItems.length; i++) {
      T item = updatedItems[i];
      if (selectedItems.contains(item)) {
        updatedItems[i] = item.setEncrypted(encryptedBool: encryptedBool) as T;
      }
    }

    emit(ListState<T>(allItems: sortItems(updatedItems), loadingBool: false));
  }

  @protected
  Future<void> saveToDatabase(T item);

  @protected
  Future<void> deleteFromDatabase(T item);

  @protected
  Future<T?> fetchSingleFromDatabase(T item);

  @protected
  Future<List<T>> fetchAllFromDatabase();

  @protected
  Future<List<T>> filterBySearchPattern(List<T> allItems, String searchPattern);

  @protected
  List<T> sortItems(List<T> items);
}
