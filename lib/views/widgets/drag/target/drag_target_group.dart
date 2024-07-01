import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/widgets/drag/drag_config.dart';
import 'package:snggle/views/widgets/drag/folder_navigation_animation.dart';
import 'package:snggle/views/widgets/drag/target/drag_target_layout.dart';
import 'package:snggle/views/widgets/drag/target/drag_target_wrapper.dart';
import 'package:snggle/views/widgets/icons/list_item_icon.dart';

typedef GroupAcceptedCallback = void Function(AListItemModel listItemModel, FilesystemPath groupFilesystemPath);

class DragTargetGroup extends StatefulWidget {
  final AListItemModel listItemModel;
  final GlobalKey gridLayoutKey;
  final ValueChanged<GroupModel> onFilesystemPathUpdate;
  final GroupAcceptedCallback groupAcceptedCallback;
  final Duration delayBeforeAction;

  const DragTargetGroup({
    required this.listItemModel,
    required this.gridLayoutKey,
    required this.onFilesystemPathUpdate,
    required this.groupAcceptedCallback,
    required this.delayBeforeAction,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DragTargetGroupState();
}

class _DragTargetGroupState extends State<DragTargetGroup> {
  Timer? navigationTimer;
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return DragTargetWrapper(
      listItemModel: widget.listItemModel,
      onAccept: (DragConfig? item) => widget.groupAcceptedCallback(item!.data, widget.listItemModel.filesystemPath),
      onEnter: (_) => _handleGroupHover(),
      onLeave: _disposeNavigationTimer,
      child: DragTargetLayout(
        icon: ListItemIcon(
          listItemModel: widget.listItemModel,
          size: DragTargetLayout.listItemIconSize,
        ),
        title: widget.listItemModel.name ?? '',
      ),
    );
  }

  void _handleGroupHover() {
    if (widget.listItemModel.encryptedBool == false) {
      navigationTimer ??= Timer(const Duration(milliseconds: 1000), _navigateToGroup);
    }
  }

  void _disposeNavigationTimer() {
    navigationTimer?.cancel();
    navigationTimer = null;
  }

  void _navigateToGroup() {
    if (mounted) {
      _showFolderNavigationAnimation(context);
      GroupModel groupModel = widget.listItemModel as GroupModel;
      widget.onFilesystemPathUpdate(groupModel);
    }
  }

  void _showFolderNavigationAnimation(BuildContext context) {
    RenderBox? gridRenderBox = widget.gridLayoutKey.currentContext?.findRenderObject() as RenderBox?;
    if (gridRenderBox == null) {
      return;
    }
    Offset gridOffset = gridRenderBox.localToGlobal(Offset.zero);
    Size gridSize = gridRenderBox.size;

    RenderBox tileRenderBox = context.findRenderObject() as RenderBox;
    Offset tileOffset = tileRenderBox.localToGlobal(Offset.zero);
    Size tileSize = tileRenderBox.size;

    OverlayState? overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return DragTargetWrapper(
          listItemModel: widget.listItemModel,
          onAccept: (DragConfig? item) => widget.groupAcceptedCallback(item!.data, widget.listItemModel.filesystemPath),
          onEnter: (_) {},
          onLeave: () {},
          child: FolderNavigationAnimation(
            startOffset: tileOffset,
            endOffset: gridOffset,
            startSize: tileSize,
            endSize: gridSize,
            onEnd: () {
              _overlayEntry?.remove();
            },
          ),
        );
      },
    );

    overlayState.insert(_overlayEntry!);
  }
}
