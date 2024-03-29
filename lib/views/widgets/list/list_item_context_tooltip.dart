import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_content.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_item.dart';

class ListItemContextTooltip<T extends AListItemModel> extends StatefulWidget {
  final AListItemModel listItemModel;
  final AListCubit<T> listCubit;
  final Widget pageTooltip;
  final VoidCallback onCloseToolbar;

  const ListItemContextTooltip({
    required this.listItemModel,
    required this.listCubit,
    required this.pageTooltip,
    required this.onCloseToolbar,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ListItemContextTooltipState<T>();
}

class _ListItemContextTooltipState<T extends AListItemModel> extends State<ListItemContextTooltip<T>> {
  @override
  Widget build(BuildContext context) {
    return ContextTooltipContent(
      title: widget.listItemModel.name ?? '',
      actions: <ContextTooltipItem>[
        ContextTooltipItem(
          iconData: AppIcons.select_container_unselected,
          label: 'Select',
          onTap: () => _handleSelectValueChanged(true),
        ),
        if (widget.listItemModel.pinnedBool)
          ContextTooltipItem(
            iconData: AppIcons.unpin,
            label: 'Unpin',
            onTap: () => _handlePinValueChanged(false),
          )
        else
          ContextTooltipItem(
            iconData: AppIcons.pin,
            label: 'Pin',
            onTap: () => _handlePinValueChanged(true),
          ),
        if (widget.listItemModel.encryptedBool)
          ContextTooltipItem(
            iconData: AppIcons.unlock,
            label: 'Unlock',
            onTap: _pressUnlockButton,
          )
        else
          ContextTooltipItem(
            iconData: AppIcons.lock,
            label: 'Lock',
            onTap: () => _handleLockValueChanged(true),
          ),
        ContextTooltipItem(
          iconData: AppIcons.close_1,
          label: 'Delete',
          onTap: _pressDeleteButton,
        ),
      ],
    );
  }

  void _handleSelectValueChanged(bool selectedBool) {
    widget.onCloseToolbar.call();
    if (widget.listCubit.state.isSelectionEnabled == false) {
      _showBottomNavigationTooltip();
    }
    if (selectedBool) {
      widget.listCubit.selectSingle(widget.listItemModel);
    } else {
      widget.listCubit.unselectSingle(widget.listItemModel);
    }
  }

  void _handlePinValueChanged(bool pinnedBool) {
    widget.onCloseToolbar.call();
    widget.listCubit.pinSelection(
      selectedItems: <AListItemModel>[widget.listItemModel],
      pinnedBool: pinnedBool,
    );
  }

  void _pressUnlockButton() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Lock',
        content: 'Are you sure you want to unlock this item?',
        onConfirm: () {
          _handleLockValueChanged(false);
        },
      ),
    );
  }

  void _handleLockValueChanged(bool lockedBool) {
    widget.onCloseToolbar.call();
    if (lockedBool) {
      _lockItem();
    } else {
      _unlockItem();
    }
  }

  Future<void> _lockItem() async {
    await widget.listCubit.lockSelection(selectedItems: <AListItemModel>[widget.listItemModel], encryptedBool: true);
  }

  Future<void> _unlockItem() async {
    await widget.listCubit.lockSelection(selectedItems: <AListItemModel>[widget.listItemModel], encryptedBool: false);
  }

  void _pressDeleteButton() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Delete',
        content: 'Are you sure you want to delete this item?',
        onConfirm: _handleDelete,
      ),
    );
  }

  Future<void> _handleDelete() async {
    widget.onCloseToolbar.call();
    await widget.listCubit.deleteItem(widget.listItemModel);
  }

  void _showBottomNavigationTooltip() {
    BottomNavigationWrapper.of(context).showTooltip(widget.pageTooltip);
  }
}
