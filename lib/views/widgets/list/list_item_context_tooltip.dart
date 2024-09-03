import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/pages/bottom_navigation/secrets_auth_page.dart';
import 'package:snggle/views/pages/bottom_navigation/secrets_setup_pin_page.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_content.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_item.dart';

class ListItemContextTooltip<T extends AListItemModel> extends StatefulWidget {
  final bool allowItemDeletionBool;
  final AListItemModel listItemModel;
  final AListCubit<T> listCubit;
  final Widget pageTooltip;
  final VoidCallback onCloseToolbar;

  const ListItemContextTooltip({
    required this.allowItemDeletionBool,
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
          assetIconData: AppIcons.menu_select,
          label: 'Select',
          onTap: () => _handleSelectValueChanged(true),
        ),
        if (widget.listItemModel.pinnedBool)
          ContextTooltipItem(
            assetIconData: AppIcons.menu_unpin,
            label: 'Unpin',
            onTap: () => _handlePinValueChanged(false),
          )
        else
          ContextTooltipItem(
            assetIconData: AppIcons.menu_pin,
            label: 'Pin',
            onTap: () => _handlePinValueChanged(true),
          ),
        if (widget.listItemModel.encryptedBool)
          ContextTooltipItem(
            assetIconData: AppIcons.menu_unlock,
            label: 'Unlock',
            onTap: _unlockItem,
          )
        else
          ContextTooltipItem(
            assetIconData: AppIcons.menu_lock,
            label: 'Lock',
            onTap: _lockItem,
          ),
        if (widget.allowItemDeletionBool)
          ContextTooltipItem(
            assetIconData: AppIcons.menu_delete,
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

  Future<void> _lockItem() async {
    widget.onCloseToolbar();
    await showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return SecretsSetupPinPage(
          passwordValidCallback: (PasswordModel passwordModel) async {
            await widget.listCubit.lockSelection(selectedItems: <AListItemModel>[widget.listItemModel], newPasswordModel: passwordModel);
          },
        );
      },
    );
  }

  Future<void> _unlockItem() async {
    widget.onCloseToolbar();
    await showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return SecretsAuthPage(
          title: 'REMOVE PIN',
          listItemModel: widget.listItemModel,
          passwordValidCallback: (PasswordModel passwordModel) async {
            await widget.listCubit.unlockSelection(selectedItem: widget.listItemModel, oldPasswordModel: passwordModel);
            widget.onCloseToolbar();
          },
        );
      },
    );
  }

  void _pressDeleteButton() {
    widget.onCloseToolbar.call();
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
    await widget.listCubit.deleteItem(widget.listItemModel);
  }

  void _showBottomNavigationTooltip() {
    BottomNavigationWrapper.of(context).showTooltip(widget.pageTooltip);
  }
}
