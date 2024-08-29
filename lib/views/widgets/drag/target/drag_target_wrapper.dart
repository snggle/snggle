import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/views/widgets/drag/drag_config.dart';
import 'package:snggle/views/widgets/drag/source/custom_draggable.dart';

class DragTargetWrapper extends StatefulWidget {
  final AListItemModel listItemModel;
  final Widget child;
  final ValueChanged<DragConfig> onEnter;
  final VoidCallback onLeave;
  final DragTargetAccept<DragConfig>? onAccept;

  const DragTargetWrapper({
    required this.listItemModel,
    required this.child,
    required this.onEnter,
    required this.onLeave,
    required this.onAccept,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DragTargetWrapperState();
}

class _DragTargetWrapperState extends State<DragTargetWrapper> {
  @override
  Widget build(BuildContext context) {
    return CustomDragTarget<DragConfig>(
      onAccept: _handleTargetDrop,
      onMove: _handleTargetHovered,
      onLeave: _handleTargetLeft,
      builder: (_, __, ___) {
        return widget.child;
      },
    );
  }

  void _handleTargetDrop(DragConfig data) {
    if (_isDropEnabled) {
      widget.onAccept?.call(data);
    }
  }

  void _handleTargetHovered(DragTargetDetails<DragConfig> item) {
    if (_isDropEnabled) {
      item.data.draggedItem.draggedItemNotifier.notifyTargetHovered();
      widget.onEnter(item.data);
    } else {
      item.data.draggedItem.draggedItemNotifier.notifyTargetLeft();
    }
  }

  void _handleTargetLeft(DragConfig? item) {
    if (_isDropEnabled) {
      item?.draggedItem.draggedItemNotifier.notifyTargetLeft();
      widget.onLeave();
    } else {
      item?.draggedItem.draggedItemNotifier.notifyTargetLeft();
    }
  }

  bool get _isDropEnabled => widget.listItemModel.encryptedBool == false;
}
