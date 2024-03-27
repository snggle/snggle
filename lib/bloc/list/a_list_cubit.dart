import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/list/list_state.dart';
import 'package:snggle/shared/models/a_list_item.dart';
import 'package:snggle/shared/models/selection_model.dart';

abstract class AListCubit<T extends AListItem> extends Cubit<ListState<T>> {
  AListCubit() : super(ListState<T>.loading());

  Future<void> delete(T item) async {
    await deleteFromDatabase(item);
    await refreshAll();
  }

  Future<void> refreshSingle(T item) async {
    T? newItem = await fetchSingleFromDatabase(item);
    if (newItem == null) {
      List<T> newItems = state.allItems..remove(item);
      emit(state.copyWith(allItems: newItems));
    } else {
      List<T> newItems = state.allItems.map((T e) => e == item ? newItem : e).toList();
      emit(state.copyWith(allItems: newItems));
    }
  }

  Future<void> refreshAll() async {
    List<T> allItems = await fetchAllFromDatabase();
    emit(ListState<T>(loadingBool: false, allItems: allItems));
  }

  void search(String? searchPattern) {
    emit(ListState<T>(
      loadingBool: false,
      searchBoxVisibleBool: searchPattern != null,
      selectionModel: state.selectionModel,
      searchPattern: searchPattern,
      allItems: state.allItems,
    ));
  }

  void selectSingle(T item) {
    List<T> selectedItems = List<T>.from(state.selectedItems, growable: true)..add(item);
    emit(state.copyWith(selectionModel: SelectionModel<T>(selectedItems)));
  }

  void selectAll() {
    if (state.selectedItems.length == state.allItems.length) {
      emit(state.copyWith(selectionModel: SelectionModel<T>.empty()));
    } else {
      emit(state.copyWith(selectionModel: SelectionModel<T>(state.allItems)));
    }
  }

  void unselectSingle(T item) {
    List<T> selectedItems = List<T>.from(state.selectedItems, growable: true)..remove(item);
    emit(state.copyWith(selectionModel: SelectionModel<T>(selectedItems)));
  }

  void disableSelection() {
    emit(ListState<T>(allItems: state.allItems, loadingBool: false));
  }

  Future<void> pinSelection({required List<T> selectedItems, required bool pinnedBool}) async {
    List<T> updatedItems = List<T>.from(state.allItems);
    for (T item in updatedItems) {
      if (selectedItems.contains(item)) {
        item.setPinned(pinnedBool: pinnedBool);
        unawaited(saveToDatabase(item));
      }
    }
    emit(ListState<T>(allItems: updatedItems, loadingBool: false));
  }

  Future<void> updateEncryptionStatus({required List<T> selectedItems, required bool encryptedBool}) async {
    List<T> updatedItems = List<T>.from(state.allItems);
    for (T item in updatedItems) {
      if (selectedItems.contains(item)) {
        item.setEncrypted(encryptedBool: encryptedBool);
      }
    }
    emit(ListState<T>(allItems: updatedItems, loadingBool: false));
  }

  Future<void> deleteFromDatabase(T item);

  Future<T?> fetchSingleFromDatabase(T item);

  Future<List<T>> fetchAllFromDatabase();

  Future<void> saveToDatabase(T item);
}
