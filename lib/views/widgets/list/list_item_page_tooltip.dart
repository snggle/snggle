import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/pages/bottom_navigation/secrets_setup_pin_page.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class ListItemPageTooltip<T extends AListItemModel, C extends AListCubit<T>> extends StatefulWidget {
  final C listCubit;

  const ListItemPageTooltip({
    required this.listCubit,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ListItemPageTooltipState<T, C>();
}

class _ListItemPageTooltipState<T extends AListItemModel, C extends AListCubit<T>> extends State<ListItemPageTooltip<T, C>> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, ListState>(
      bloc: widget.listCubit,
      builder: (BuildContext buildContext, ListState listState) {
        SelectionModel? selectionModel = listState.selectionModel;
        if (selectionModel == null) {
          return const SizedBox();
        }

        return BottomTooltip(
          actions: <BottomTooltipItem>[
            BottomTooltipItem(
              assetIconData: selectionModel.areAllItemsSelected ? AppIcons.menu_unselect_all : AppIcons.menu_select_all,
              label: selectionModel.areAllItemsSelected ? 'Clear' : 'All',
              onTap: _pressSelectAllButton,
            ),
            BottomTooltipItem(
              assetIconData: AppIcons.menu_pin,
              label: 'Pin',
              onTap: selectionModel.canPinAll ? () => _pressPinButton(selectionModel, true) : null,
            ),
            BottomTooltipItem(
              assetIconData: AppIcons.menu_unpin,
              label: 'Unpin',
              onTap: selectionModel.canUnpinAll ? () => _pressPinButton(selectionModel, false) : null,
            ),
            BottomTooltipItem(
              assetIconData: AppIcons.menu_lock,
              label: 'Lock',
              onTap: selectionModel.canLockAll ? () => _pressLockButton(selectionModel) : null,
            ),
          ],
        );
      },
    );
  }

  void _pressSelectAllButton() {
    widget.listCubit.toggleSelectAll();
  }

  void _pressPinButton(SelectionModel selectionModel, bool pinnedBool) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: pinnedBool ? 'Pin' : 'Unpin',
        content: 'Are you sure you want to ${pinnedBool ? 'pin' : 'unpin'} selected items?',
        onConfirm: () {
          widget.listCubit.pinSelection(selectedItems: selectionModel.selectedItems, pinnedBool: pinnedBool);
          _closeTooltip();
        },
      ),
    );
  }

  void _pressLockButton(SelectionModel selectionModel) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Lock',
        content: 'Are you sure you want to lock selected items?',
        onConfirm: () {
          _closeTooltip();
          _lockSelection(selectionModel);
        },
      ),
    );
  }

  void _lockSelection(SelectionModel selectionModel) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return SecretsSetupPinPage(
          passwordValidCallback: (PasswordModel passwordModel) async {
            await widget.listCubit.lockSelection(selectedItems: selectionModel.selectedItems, newPasswordModel: passwordModel);
          },
        );
      },
    );
  }

  void _closeTooltip() {
    BottomNavigationWrapper.of(context).hideTooltip();
  }
}
