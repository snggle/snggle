import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/views/widgets/generic/selection_wrapper.dart';
import 'package:snggle/views/widgets/list/list_item_context_tooltip.dart';
import 'package:snggle/views/widgets/list/list_item_page_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_wrapper.dart';

class ListItemActionsWrapper<T extends AListItemModel, C extends AListCubit<T>> extends StatefulWidget {
  final Size listItemSize;
  final C listCubit;
  final AListItemModel listItemModel;
  final ValueChanged<AListItemModel> onNavigate;
  final Widget child;
  final EdgeInsets selectionPadding;

  const ListItemActionsWrapper({
    required this.listItemSize,
    required this.listCubit,
    required this.listItemModel,
    required this.onNavigate,
    required this.child,
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
    } else {
      child = GestureDetector(
        onTap: _handleNavigation,
        onLongPress: _openToolbar,
        child: child,
      );
    }

    return SizedBox(
      height: widget.listItemSize.height,
      width: double.infinity,
      child: ContextTooltipWrapper(
        controller: actionsPopupController,
        content: ListItemContextTooltip<T>(
          listItemModel: listItemModel,
          listCubit: widget.listCubit,
          pageTooltip: ListItemPageTooltip<T, C>(
            listCubit: widget.listCubit,
          ),
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

    widget.onNavigate(widget.listItemModel);
  }

  void _openToolbar() {
    actionsPopupController.showMenu();
  }

  void _closeToolbar() {
    actionsPopupController.hideMenu();
  }
}
