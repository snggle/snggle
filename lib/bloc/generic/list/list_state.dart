import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/selection_model.dart';

class ListState<T extends AListItemModel> extends Equatable {
  final bool loadingBool;
  final List<T> allItems;
  final SelectionModel<T>? selectionModel;
  final List<T> visibleItems;

  const ListState({
    required this.loadingBool,
    required this.allItems,
    this.selectionModel,
    List<T>? visibleItems,
  }) : visibleItems = visibleItems ?? allItems;

  ListState.loading()
      : loadingBool = true,
        allItems = <T>[],
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
      selectionModel: selectionModel ?? this.selectionModel,
    );
  }

  bool get isSelectionEnabled {
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
  List<Object?> get props => <Object?>[loadingBool, allItems, selectionModel];
}
