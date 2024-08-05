import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/bottom_navigation/secrets_auth_page.dart';
import 'package:snggle/views/widgets/drag/dragged_item/dragged_item_notifier.dart';
import 'package:snggle/views/widgets/drag/source/drag_source_gesture_detector.dart';
import 'package:snggle/views/widgets/generic/selection_wrapper.dart';
import 'package:snggle/views/widgets/icons/list_item_icon.dart';
import 'package:snggle/views/widgets/list/list_item_context_tooltip.dart';
import 'package:snggle/views/widgets/list/list_item_page_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_wrapper.dart';

typedef NavigatedCallback = void Function(AListItemModel listItemModel, PasswordModel passwordModel);

class ListItemActionsWrapper<T extends AListItemModel, C extends AListCubit<T>> extends StatefulWidget {
  final Size listItemSize;
  final String defaultPageTitle;
  final C listCubit;
  final AListItemModel listItemModel;
  final NavigatedCallback onNavigate;
  final Widget child;
  final DraggedItemNotifier draggedItemNotifier;
  final bool allowItemDeletionBool;
  final EdgeInsets selectionPadding;

  const ListItemActionsWrapper({
    required this.listItemSize,
    required this.defaultPageTitle,
    required this.listCubit,
    required this.listItemModel,
    required this.onNavigate,
    required this.child,
    required this.draggedItemNotifier,
    this.allowItemDeletionBool = true,
    this.selectionPadding = EdgeInsets.zero,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ListItemActionsWrapperState<T, C>();
}

class _ListItemActionsWrapperState<T extends AListItemModel, C extends AListCubit<T>> extends State<ListItemActionsWrapper<T, C>> {
  final CustomPopupMenuController actionsPopupController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    ListState listState = widget.listCubit.state;
    AListItemModel listItemModel = widget.listItemModel;

    Widget child = widget.child;

    if (listState.isSelectionEnabled) {
      child = SelectionWrapper(
        padding: widget.selectionPadding,
        selectedBool: widget.listCubit.state.selectedItems.contains(listItemModel),
        onSelectValueChanged: _handleSelectValueChanged,
        child: IgnorePointer(child: widget.child),
      );
    } else if (widget.listItemModel is GroupModel) {
      child = GestureDetector(
        onTap: _handleNavigation,
        onLongPress: _openToolbar,
        child: child,
      );
    } else {
      child = DragSourceGestureDetector<T>(
        defaultPageTitle: widget.defaultPageTitle,
        draggedItemNotifier: widget.draggedItemNotifier,
        data: widget.listItemModel,
        draggedItem: ListItemIcon(
          listItemModel: listItemModel,
          size: widget.listItemSize,
        ),
        listCubit: widget.listCubit,
        onTap: _handleNavigation,
        onLongPress: _openToolbar,
        onDragPopupOpen: _closeToolbar,
        child: child,
      );
    }

    return SizedBox(
      height: widget.listItemSize.height,
      width: double.infinity,
      child: ContextTooltipWrapper(
        controller: actionsPopupController,
        content: ListItemContextTooltip<T>(
          allowItemDeletionBool: widget.allowItemDeletionBool,
          listItemModel: listItemModel,
          listCubit: widget.listCubit,
          pageTooltip: ListItemPageTooltip<T, C>(listCubit: widget.listCubit),
          onCloseToolbar: _closeToolbar,
        ),
        child: child,
      ),
    );
  }

  void _handleSelectValueChanged(bool selectedBool) {
    if (selectedBool) {
      widget.listCubit.selectSingle(widget.listItemModel);
    } else {
      widget.listCubit.unselectSingle(widget.listItemModel);
    }
  }

  void _handleNavigation() {
    FocusScope.of(context).requestFocus(FocusNode());
    actionsPopupController.hideMenu();

    if (widget.listItemModel.encryptedBool) {
      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) => SecretsAuthPage(
          title: 'ENTER PIN',
          listItemModel: widget.listItemModel,
          passwordValidCallback: (PasswordModel passwordModel) {
            widget.onNavigate(widget.listItemModel, passwordModel);
          },
        ),
      );
    } else {
      widget.onNavigate(widget.listItemModel, PasswordModel.defaultPassword());
    }
  }

  void _openToolbar() {
    actionsPopupController.showMenu();
  }

  void _closeToolbar() {
    actionsPopupController.hideMenu();
  }
}
