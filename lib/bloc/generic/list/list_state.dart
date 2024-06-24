import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class ListState extends Equatable {
  final bool loadingBool;
  final List<AListItemModel> allItems;
  final FilesystemPath filesystemPath;
  final SelectionModel? selectionModel;
  final List<AListItemModel> visibleItems;

  const ListState({
    required this.loadingBool,
    required this.allItems,
    required this.filesystemPath,
    this.selectionModel,
    List<AListItemModel>? visibleItems,
  }) : visibleItems = visibleItems ?? allItems;

  ListState.loading({
    required this.filesystemPath,
  })  : loadingBool = true,
        allItems = <AListItemModel>[],
        selectionModel = null,
        visibleItems = <AListItemModel>[];

  ListState copyWith({
    bool forceOverrideBool = false,
    bool? loadingBool,
    List<AListItemModel>? allItems,
    FilesystemPath? filesystemPath,
    String? searchPattern,
    SelectionModel? selectionModel,
  }) {
    return ListState(
      loadingBool: loadingBool ?? this.loadingBool,
      allItems: allItems ?? this.allItems,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      selectionModel: forceOverrideBool ? selectionModel : selectionModel ?? this.selectionModel,
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

  List<AListItemModel> get selectedItems {
    return selectionModel?.selectedItems ?? <AListItemModel>[];
  }

  @override
  List<Object?> get props => <Object?>[loadingBool, allItems, filesystemPath, selectionModel];
}
