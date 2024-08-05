import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/views/widgets/drag/drag_config.dart';
import 'package:snggle/views/widgets/drag/target/drag_target_layout.dart';
import 'package:snggle/views/widgets/drag/target/drag_target_wrapper.dart';
import 'package:snggle/views/widgets/icons/group_icon.dart';
import 'package:snggle/views/widgets/icons/list_item_icon.dart';

typedef GroupAcceptedCallback = void Function(AListItemModel a, AListItemModel b);

class DragTargetItem extends StatefulWidget {
  final int depth;
  final AListItemModel listItemModel;
  final GroupAcceptedCallback groupAcceptedCallback;
  final Duration delayBeforeAction;

  const DragTargetItem({
    required this.depth,
    required this.listItemModel,
    required this.groupAcceptedCallback,
    required this.delayBeforeAction,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DragTargetItemState();
}

class _DragTargetItemState extends State<DragTargetItem> {
  static double size = 80;

  AListItemModel? draggedItem;
  Timer? animationTimer;

  @override
  void dispose() {
    animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = DragTargetLayout(
      icon: ListItemIcon(listItemModel: widget.listItemModel, size: DragTargetLayout.listItemIconSize),
      title: widget.listItemModel.name ?? '',
    );

    if (draggedItem != null) {
      child = DragTargetLayout(
        icon: GroupIcon(
          pinnedBool: false,
          encryptedBool: false,
          listItemsPreview: <AListItemModel>[widget.listItemModel],
          size: size,
        ),
        title: '',
      );
    }

    if (widget.depth != 0) {
      return child;
    } else {
      return DragTargetWrapper(
        listItemModel: widget.listItemModel,
        onAccept: _handleDrop,
        onEnter: _handleItemHover,
        onLeave: _disposeAnimationTimer,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: child,
        ),
      );
    }
  }

  void _handleDrop(DragConfig? item) {
    widget.groupAcceptedCallback(widget.listItemModel, item!.data);
  }

  void _handleItemHover(DragConfig dragConfig) {
    _showGroupAnimation(dragConfig.data);
  }

  void _showGroupAnimation(AListItemModel listItemModel) {
    animationTimer ??= Timer(widget.delayBeforeAction, () => _setDraggedItem(listItemModel));
  }

  void _disposeAnimationTimer() {
    setState(() => draggedItem = null);
    animationTimer?.cancel();
    animationTimer = null;
  }

  void _setDraggedItem(AListItemModel listItemModel) {
    if (mounted) {
      setState(() => draggedItem = listItemModel);
    }
  }
}
