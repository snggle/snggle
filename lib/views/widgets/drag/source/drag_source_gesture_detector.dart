import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/widgets/drag/drag_config.dart';
import 'package:snggle/views/widgets/drag/drag_popup.dart';
import 'package:snggle/views/widgets/drag/dragged_item/dragged_item_notifier.dart';
import 'package:snggle/views/widgets/drag/dragged_item/dragged_item_wrapper.dart';
import 'package:snggle/views/widgets/drag/source/custom_draggable.dart';

typedef DragUpdateCallback = void Function(DragUpdateDetails dragUpdateDetails, DragConfig dragConfig);

class DragSourceGestureDetector<T extends AListItemModel> extends StatefulWidget {
  final String defaultPageTitle;
  final AListItemModel data;
  final Widget child;
  final Widget draggedItem;
  final AListCubit<T> listCubit;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDragPopupOpen;
  final DraggedItemNotifier draggedItemNotifier;

  const DragSourceGestureDetector({
    required this.defaultPageTitle,
    required this.data,
    required this.child,
    required this.draggedItem,
    required this.listCubit,
    required this.onTap,
    required this.onLongPress,
    required this.onDragPopupOpen,
    required this.draggedItemNotifier,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DragSourceGestureDetectorState<T>();
}

class _DragSourceGestureDetectorState<T extends AListItemModel> extends State<DragSourceGestureDetector<T>> {
  late int initialDepth = widget.listCubit.state.depth;
  late FilesystemPath initialFilesystemPath = widget.listCubit.state.filesystemPath;

  @override
  Widget build(BuildContext context) {
    DraggedItemWrapper draggedItemWrapper = DraggedItemWrapper(
      draggedItemNotifier: widget.draggedItemNotifier,
      child: widget.draggedItem,
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: CustomPressableDraggable<DragConfig>(
        onLongPress: widget.onLongPress,
        onPopupOpen: widget.onDragPopupOpen,
        dragAnchorStrategy: customPointerDragAnchorStrategy,
        rootOverlay: true,
        maxSimultaneousDrags: 1,
        data: DragConfig(
          data: widget.data,
          draggedItem: draggedItemWrapper,
        ),
        background: DragPopup<T>(
          defaultPageTitle: widget.defaultPageTitle,
          listCubit: widget.listCubit,
          dragCanceledCallback: _handleDragCancelled,
          draggedItem: widget.data,
        ),
        feedback: draggedItemWrapper,
        childWhenDragging: Container(),
        child: widget.child,
      ),
    );
  }

  void _handleDragCancelled() {
    widget.listCubit.navigateTo(filesystemPath: initialFilesystemPath, depth: initialDepth);
  }
}
