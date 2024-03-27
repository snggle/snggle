import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/a_list_item.dart';
import 'package:snggle/shared/models/selection_model.dart';

class ListState<T extends AListItem> extends Equatable {
  final bool loadingBool;
  final List<T> allItems;
  final String? searchPattern;
  final SelectionModel<T>? selectionModel;
  final List<T> visibleItems;

  const ListState({
    required this.loadingBool,
    required this.allItems,
    this.searchPattern,
    this.selectionModel,
    List<T>? visibleItems,
  }) : visibleItems = visibleItems ?? allItems;

  ListState.loading()
      : loadingBool = true,
        allItems = <T>[],
        searchPattern = null,
        selectionModel = null,
        visibleItems = <T>[];

  ListState<T> copyWith({
    bool? loadingBool,
    List<T>? allItems,
    String? searchPattern,
    SelectionModel<T>? selectionModel,
  }) {
    return ListState<T>(
      loadingBool: loadingBool ?? this.loadingBool,
      allItems: allItems ?? this.allItems,
      searchPattern: searchPattern ?? this.searchPattern,
      selectionModel: selectionModel ?? this.selectionModel,
    );
  }

  bool get isSelectingEnabled {
    return selectionModel != null;
  }

  bool get isScrollDisabled {
    return loadingBool || isEmpty;
  }

  bool get isEmpty {
    return loadingBool == false && allItems.isEmpty;
  }

  List<T> get selectedItems {
    return selectionModel?.selectedItems ?? <T>[];
  }

  @override
  List<Object?> get props => <Object?>[loadingBool, allItems.hashCode, searchPattern, selectionModel];
}
