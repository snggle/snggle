import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/folder_name_dialog.dart';
import 'package:snggle/views/widgets/drag/drag_config.dart';
import 'package:snggle/views/widgets/drag/drag_popup_cursor_controller.dart';
import 'package:snggle/views/widgets/drag/drag_popup_grid.dart';
import 'package:snggle/views/widgets/drag/source/custom_draggable.dart';
import 'package:snggle/views/widgets/drag/target/drag_target_group.dart';
import 'package:snggle/views/widgets/drag/target/drag_target_item.dart';

class DragPopup<T extends AListItemModel> extends StatefulWidget {
  final String defaultPageTitle;
  final AListCubit<T> listCubit;
  final AListItemModel draggedItem;
  final VoidCallback dragCanceledCallback;
  final double minimalVerticalSpacing;
  final double minimalHorizontalSpacing;
  final Duration delayBeforeAction;

  const DragPopup({
    required this.defaultPageTitle,
    required this.listCubit,
    required this.draggedItem,
    required this.dragCanceledCallback,
    this.minimalVerticalSpacing = 10,
    this.minimalHorizontalSpacing = 10,
    this.delayBeforeAction = const Duration(milliseconds: 500),
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DragPopupState<T>();
}

class _DragPopupState<T extends AListItemModel> extends State<DragPopup<T>> {
  final DragPopupCursorController dragPopupPositionController = DragPopupCursorController();
  final GlobalKey gridLayoutKey = GlobalKey();
  Timer? navigationTimer;

  @override
  void initState() {
    super.initState();
    dragPopupPositionController.addListener(_beginNavigationTimer);
    widget.listCubit.refreshAll();
  }

  @override
  void dispose() {
    gridLayoutKey.currentState?.dispose();
    navigationTimer?.cancel();
    dragPopupPositionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets overlayPadding = MediaQuery.paddingOf(context);

    return BlocBuilder<AListCubit<T>, ListState>(
      bloc: widget.listCubit,
      builder: (BuildContext context, ListState listState) {
        String pageTitle = listState.loadingBool ? '' : listState.groupModel?.name ?? widget.defaultPageTitle;

        return CustomDragTarget<DragConfig>(
          onMove: _handleViewHover,
          onLeave: _handleViewLeave,
          onAccept: (_) => widget.dragCanceledCallback.call(),
          builder: (BuildContext context, _, __) {
            return CustomScaffold(
              popButtonVisible: false,
              title: pageTitle,
              body: DragPopupGrid(
                overlayPadding: overlayPadding,
                gridLayoutKey: gridLayoutKey,
                itemsCount: listState.allItems.length,
                minimalVerticalSpacing: widget.minimalVerticalSpacing,
                minimalHorizontalSpacing: widget.minimalHorizontalSpacing,
                dragPopupPositionController: dragPopupPositionController,
                itemBuilder: (BuildContext context, int index) {
                  AListItemModel listItemModel = listState.allItems[index];
                  late Widget child;

                  if (listItemModel is T) {
                    child = DragTargetItem(
                      depth: listState.depth,
                      listItemModel: listItemModel,
                      groupAcceptedCallback: _createGroup,
                      delayBeforeAction: widget.delayBeforeAction,
                      key: ValueKey<String>(listItemModel.filesystemPath.fullPath),
                    );
                  } else if (listItemModel is GroupModel) {
                    child = DragTargetGroup(
                      depth: listState.depth,
                      listItemModel: listItemModel,
                      gridLayoutKey: gridLayoutKey,
                      onFilesystemPathUpdate: _navigateTo,
                      groupAcceptedCallback: _addItemToGroup,
                      delayBeforeAction: widget.delayBeforeAction,
                      key: ValueKey<String>(listItemModel.filesystemPath.fullPath),
                    );
                  }

                  if (widget.draggedItem == listItemModel) {
                    return Opacity(
                      opacity: 0.2,
                      child: IgnorePointer(child: child),
                    );
                  } else {
                    return child;
                  }
                },
                onAccept: (DragConfig dragConfig) => _addItemToGroup(dragConfig.data),
              ),
            );
          },
        );
      },
    );
  }

  void _beginNavigationTimer() {
    if (dragPopupPositionController.isOutsideGridArea) {
      navigationTimer ??= Timer(const Duration(milliseconds: 1000), _navigateBack);
    } else {
      _disposeActiveNavigationTimer();
    }
  }

  Future<void> _navigateTo(GroupModel groupModel) async {
    await widget.listCubit.navigateNext(filesystemPath: groupModel.filesystemPath);
  }

  Future<void> _navigateBack() async {
    _disposeActiveNavigationTimer();
    await widget.listCubit.navigateBack();
  }

  void _disposeActiveNavigationTimer() {
    if (navigationTimer != null) {
      navigationTimer!.cancel();
      navigationTimer = null;
    }
  }

  void _handleViewHover(DragTargetDetails<DragConfig> details) {
    details.data.draggedItem.draggedItemNotifier.notifyBoundaryCrossed();
    dragPopupPositionController.setCursorOffset(details.offset);
  }

  void _handleViewLeave(DragConfig? item) {
    item?.draggedItem.draggedItemNotifier.notifyTargetLeft();
  }

  Future<void> _createGroup(AListItemModel item1, AListItemModel item2) async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return FolderNameDialog(
          onSave: (String name) async {
            await widget.listCubit.groupItems(item1, item2, name);
          },
        );
      },
    );
  }

  Future<void> _addItemToGroup(AListItemModel listItemModel, [FilesystemPath? filesystemPath]) async {
    FilesystemPath currentFilesystemPath = filesystemPath ?? widget.listCubit.state.filesystemPath;
    if (listItemModel.filesystemPath.parentPath != currentFilesystemPath.fullPath) {
      await widget.listCubit.moveItem(listItemModel, currentFilesystemPath);
    }
  }
}
