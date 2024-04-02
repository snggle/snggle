import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class ListState extends Equatable {
  final bool loadingBool;
  final int depth;
  final List<AListItemModel> allItems;
  final FilesystemPath filesystemPath;
  final GroupModel? groupModel;
  final SelectionModel? selectionModel;
  final List<AListItemModel> visibleItems;

  const ListState({
    required this.loadingBool,
    required this.depth,
    required this.allItems,
    required this.filesystemPath,
    this.groupModel,
    this.selectionModel,
    List<AListItemModel>? visibleItems,
  }) : visibleItems = visibleItems ?? allItems;

  ListState.loading({
    required this.depth,
    required this.filesystemPath,
  })  : loadingBool = true,
        allItems = <AListItemModel>[],
        groupModel = null,
        selectionModel = null,
        visibleItems = <AListItemModel>[];

  ListState copyWith({
    bool forceOverrideBool = false,
    bool? loadingBool,
    int? depth,
    List<AListItemModel>? allItems,
    FilesystemPath? filesystemPath,
    GroupModel? groupModel,
    String? searchPattern,
    SelectionModel? selectionModel,
  }) {
    return ListState(
      loadingBool: loadingBool ?? this.loadingBool,
      depth: depth ?? this.depth,
      allItems: allItems ?? this.allItems,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      groupModel: forceOverrideBool ? groupModel : groupModel ?? this.groupModel,
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

  bool get canPop {
    return isSelectionEnabled || depth > 0;
  }

  List<AListItemModel> get selectedItems {
    return selectionModel?.selectedItems ?? <AListItemModel>[];
  }

  @override
  List<Object?> get props => <Object?>[loadingBool, depth, allItems, filesystemPath, groupModel, selectionModel];
}
